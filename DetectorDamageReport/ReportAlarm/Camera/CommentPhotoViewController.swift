//
//  CommentPhotoViewController.swift
//  DetectorDamageReport
//
//  Created by Jonas Isaksson on 2019-11-11.
//  Copyright © 2019 Jonas Isaksson. All rights reserved.
//

import UIKit
import AVFoundation
import UIKit
import Alamofire
import SwiftKeychainWrapper
import SwiftSpinner
import FTLinearActivityIndicator


protocol reloadDelegate {
    func reload()
}

enum CommentPhotoMode {
    case new
    case edit
}


class CommentPhotoViewController: UIViewController {
    var delegate:reloadDelegate?
    var mode: CommentPhotoMode!
    var isLoading:Bool = false;

    var alarmReportDTO: AlarmReportDTO?
    var AlarmReportImageId : Int? = nil
    var selectedImage = UIImage()
    var photoImageview: UIImageView =
    {
        let t = UIImageView()
        t.translatesAutoresizingMaskIntoConstraints = false;
        return t;
    }()
    
    var commentTextView: UITextView =
    {
        let t = UITextView()
        let color = UIColor(red: 186/255, green: 186/255, blue: 186/255, alpha: 1.0).cgColor
        t.layer.borderColor = color
        t.layer.borderWidth = 0.5
        t.layer.cornerRadius = 5
        t.text = "Kommentar"
        t.translatesAutoresizingMaskIntoConstraints = false;
        return t;
    }()

    var standAloneIndicator: FTLinearActivityIndicator =
    {
        let t = FTLinearActivityIndicator()
        t.translatesAutoresizingMaskIntoConstraints = false;
        return t;
    }()

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.black
        self.view.addSubview(commentTextView)
        self.view.addSubview(photoImageview)
        self.view.addSubview(standAloneIndicator)

        if self.mode == CommentPhotoMode.edit
        {
            
            self.fetchImage()
            commentTextView.isUserInteractionEnabled = false;
            let deleteutton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.trash, target: self, action: #selector(self.deleteImage))
            navigationItem.rightBarButtonItem = deleteutton
        }else
        {
            let uploadButton = UIButton()
            uploadButton.setTitle("Ladda upp", for: .normal)
            uploadButton.sizeToFit()
            let uploadBarButton = UIBarButtonItem(customView: uploadButton)
            navigationItem.rightBarButtonItem = uploadBarButton
            uploadButton.addTarget(self, action: #selector(self.uploadImage), for: .touchUpInside)
        }
        
        
        commentTextView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 70).isActive = true
         
         commentTextView.heightAnchor.constraint(equalToConstant: 100).isActive = true;
         
         commentTextView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 10) .isActive = true;
         
         commentTextView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -10) .isActive = true;
        
        self.commentTextView.addDoneButton(title: "Done", target: self, selector: #selector(tapDone(sender:)))

        photoImageview.topAnchor.constraint(equalTo: commentTextView.bottomAnchor, constant: 20).isActive = true

        let screenSize = UIScreen.main.bounds
        let screenWidth = screenSize.width

        photoImageview.heightAnchor.constraint(equalToConstant: screenWidth).isActive = true;
        
        photoImageview.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 10) .isActive = true;
        
        photoImageview.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -10) .isActive = true;

        photoImageview.image = selectedImage
        
        let cancelButton = UIButton()
        cancelButton.setTitle("Avbryt", for: .normal)
        cancelButton.sizeToFit()
        let cancelBarButton = UIBarButtonItem(customView: cancelButton)
        navigationItem.leftBarButtonItem = cancelBarButton
        cancelButton.addTarget(self, action: #selector(self.cancelImageEditing), for: .touchUpInside)
        

    }

    @objc func tapDone(sender: Any) {
        self.view.endEditing(true)
    }
    @objc func cancelImageEditing() {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @objc func uploadImage() {
        SwiftSpinner.show("Laddar upp...")

        
        let imageData =  self.selectedImage.superCompress(self.selectedImage, maxHeight: 1080.0, maxWidth: 1080.0)
            let base64String = imageData.base64EncodedString(options: .lineLength64Characters)
            
            let alarmReportImageBinDTOs = AlarmReportImageBinDTO(AlarmReportImageBinId: nil, Image: base64String)
            
            
        let alarmReportImageDTOs = AlarmReportImageDTO(AlarmReportImageId: nil, AlarmReportId: self.alarmReportDTO?.AlarmReportId!, Description: commentTextView.text, AlarmReportImageBinDTO: alarmReportImageBinDTOs, AlarmReportImageThumbnailBinDTO: nil)
            
            
            
            var dict = [String: Any]()
              do {
                  dict = try alarmReportImageDTOs.asDictionary()
              }catch {
                  print("Unexpected error: \(error).")
                  return
              }
            
            var headers: HTTPHeaders!
             if KeychainWrapper.standard.string(forKey: "detectordamagereport_email") != nil && KeychainWrapper.standard.string(forKey: "detectordamagereport_password") != nil
             {
                 headers = [.authorization(username: KeychainWrapper.standard.string(forKey: "detectordamagereport_email")!, password: KeychainWrapper.standard.string(forKey: "detectordamagereport_password")!)]
             }
            
            AF.request((UIApplication.shared.delegate as! AppDelegate).WebapiURL +  "AlarmReport/UploadAlarmReportImage", method: HTTPMethod.post, parameters: dict, encoding: JSONEncoding.default, headers: headers, interceptor: nil).response { (response) in
                print("Request: \(String(describing: response.request))")   // original url request
                print("Response: \(String(describing: response.response))") // http url response
                print("Result: \(response.result)")                         // response serialization result
                //self.standAloneIndicator.stopAnimating()

                SwiftSpinner.hide()
                
                if let err = response.error
                {
                    let errorAlertMessage = UIAlertController(title: "Ett oväntat fel uppstod", message: err.localizedDescription, preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
                    errorAlertMessage.addAction(okAction);
                    
                    self.present(errorAlertMessage, animated: true, completion: nil)
                    return;
                }
                
                
                let uploadedMessage = UIAlertController(title: "Bild uppladdad", message: "", preferredStyle: .alert)
                
                let okAction = UIAlertAction(title: "Ok", style: .default) { (action) in
                    self.delegate?.reload()

                    self.dismiss(animated: true, completion: nil)
                }
                uploadedMessage.addAction(okAction);
                self.present(uploadedMessage, animated: true, completion: nil)
            }

    }
    
    
    
    func fetchImage(){
        if self.isLoading {
            return;
        }

        standAloneIndicator.startAnimating()

    
        var headers: HTTPHeaders!
        if KeychainWrapper.standard.string(forKey: "detectordamagereport_email") != nil && KeychainWrapper.standard.string(forKey: "detectordamagereport_password") != nil
        {
            headers = [.authorization(username: KeychainWrapper.standard.string(forKey: "detectordamagereport_email")!, password: KeychainWrapper.standard.string(forKey: "detectordamagereport_password")!)]
        }
        
        AF.request((UIApplication.shared.delegate as! AppDelegate).WebapiURL +  "AlarmReport/GetAlarmReportImage/" +  String(self.AlarmReportImageId!), method: HTTPMethod.get, parameters: nil, encoding: JSONEncoding.default, headers: headers, interceptor: nil).responseJSON { (response) in
            print("Request: \(String(describing: response.request))")   // original url request
            print("Response: \(String(describing: response.response))") // http url response
            print("Result: \(response.result)")                         // response serialization result
            self.isLoading = false;
            self.standAloneIndicator.stopAnimating()

            
            if let err = response.error
            {
                let errorAlertMessage = UIAlertController(title: "Ett oväntat fel uppstod", message: err.localizedDescription, preferredStyle: .alert)
                let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
                errorAlertMessage.addAction(okAction);
                
                self.present(errorAlertMessage, animated: true, completion: nil)
                return;
            }
            
            
            if let d = response.data{
                do {
                    let decoder = JSONDecoder() //or any other Decoder
                    decoder.dateDecodingStrategy = .iso8601
                    let tr = try decoder.decode(AlarmReportImageDTO.self, from: d)
                    
                    if let img = tr.AlarmReportImageBinDTO
                    {
                        let decodedData = Data(base64Encoded: img.Image, options: NSData.Base64DecodingOptions(rawValue: 0))
                        let decodedimage = UIImage(data: decodedData!)
                        self.photoImageview.image =  decodedimage
                        DispatchQueue.main.async {
                            self.photoImageview.reloadInputViews()
                        }
                    }
                   
              
                } catch {
                    let errorAlertMessage = UIAlertController(title: "Ett oväntat fel uppstod", message: error.localizedDescription, preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
                    errorAlertMessage.addAction(okAction);
                    
                    self.present(errorAlertMessage, animated: true, completion: nil)
                    
                }
                
            }
        }
        
    }
    @objc func deleteImage(){
      
        
        let alertController = UIAlertController(title: "Är du säker på att du vill ta bort denna bild?", message: "", preferredStyle: .actionSheet)
        let okAction = UIAlertAction(title: "Ok", style: .default) { (action) in
            
            
            
                   if self.isLoading {
                         return;
                     }

            self.standAloneIndicator.startAnimating()

            
                var headers: HTTPHeaders!
                if KeychainWrapper.standard.string(forKey: "detectordamagereport_email") != nil && KeychainWrapper.standard.string(forKey: "detectordamagereport_password") != nil
                {
                    headers = [.authorization(username: KeychainWrapper.standard.string(forKey: "detectordamagereport_email")!, password: KeychainWrapper.standard.string(forKey: "detectordamagereport_password")!)]
                }
                
               AF.request((UIApplication.shared.delegate as! AppDelegate).WebapiURL +  "AlarmReport/DeleteAlarmReportImage/" +  String(self.AlarmReportImageId!), method: HTTPMethod.delete, parameters: nil, encoding: JSONEncoding.default, headers: headers, interceptor: nil).response { (response) in
                    print("Request: \(String(describing: response.request))")   // original url request
                    //print("Response: \(String(describing: ))") // http url response
                    print("Result: \(response.result)")                         // response serialization result
                    self.isLoading = false;
                    self.standAloneIndicator.stopAnimating()

                    
                    if let err = response.error
                    {
                        let errorAlertMessage = UIAlertController(title: "Ett oväntat fel uppstod", message: err.localizedDescription, preferredStyle: .alert)
                        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
                        errorAlertMessage.addAction(okAction);
                        
                        self.present(errorAlertMessage, animated: true, completion: nil)
                        return;
                    }
                    
                   if response.response?.statusCode == 200
                   {
                       self.delegate?.reload()
                       self.dismiss(animated: true, completion: nil)
                   }
                }
        }
        let cancelAction = UIAlertAction(title: "Avbryt", style: UIAlertAction.Style.cancel, handler: nil)
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
        
 
     }
    
    
}

