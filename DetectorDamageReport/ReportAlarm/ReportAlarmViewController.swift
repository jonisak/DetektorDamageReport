//
//  ReportAlarmViewController.swift
//  DetectorDamageReport
//
//  Created by Jonas Isaksson on 2019-08-26.
//  Copyright © 2019 Jonas Isaksson. All rights reserved.
//

import UIKit
import Eureka
import SwiftSpinner
import Alamofire
import SwiftKeychainWrapper
import FTLinearActivityIndicator
import CameraKit_iOS

class ReportAlarmViewController : FormViewController {
    var trainListDTO:TrainListDTO!
    //var indexPath = 0
    //var trainDTO : TrainDTO!
    var alarmReportReasonDTO : AlarmReportReasonDTO!
    var isLoading:Bool = false;
    var standAloneIndicator: FTLinearActivityIndicator =
    {
        let t = FTLinearActivityIndicator()
        t.translatesAutoresizingMaskIntoConstraints = false;
        return t;
    }()
    
    var alarmReportDTO: AlarmReportDTO?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Rapportera larm"
     //   self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Stäng", style: UIBarButtonItem.Style.done, target: self, action: #selector(self.closeView))
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .camera, target: self, action: #selector(self.uploadImage)) //UIBarButtonItem(title: "Stäng", style: UIBarButtonItem.Style.done, target: self, action: #selector(self.closeView))

        
        
        self.view.addSubview(standAloneIndicator)
        standAloneIndicator.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0).isActive = true
        standAloneIndicator.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: 0).isActive = true
        standAloneIndicator.heightAnchor.constraint(equalToConstant: 10).isActive = true;
        standAloneIndicator.widthAnchor.constraint(equalToConstant: 80).isActive = true;

        
        form +++
            Section("")
            <<< PickerRow<String>("Välj orsak") { (row : PickerRow<String>) -> Void in
                row.options = []
                row.tag = "ReasonPicker"
                for alarmReportReasonDTO in (UIApplication.shared.delegate as! AppDelegate).alarmReportReasonDTOList
                {
                    row.options.append(alarmReportReasonDTO.Name);
                }
                }.onChange({ (row) in
                 
                    guard let value = row.value else {return}
                    print(value)
                    
                    for alarmReportReasonDTO in (UIApplication.shared.delegate as! AppDelegate).alarmReportReasonDTOList
                    {
                        if value == alarmReportReasonDTO.Name
                        {
                            self.alarmReportReasonDTO = alarmReportReasonDTO
                            break;
                        }
                    }
                })

            <<< TextAreaRow(){
                $0.placeholder = "Kommentar"
                $0.textAreaHeight = .dynamic(initialTextViewHeight: 96)
                $0.tag = "CommentTextAreaRow"
        }
        
            <<< ButtonRow(){row in
                row.title = "Spara"
                
                }.onCellSelection { [weak self] (cell, row) in
                    self?.createAlarmReport()
        }
        
    }
    
    @objc func  uploadImage(){
        // Init a photo capture session
        let session = CKFPhotoSession()
        
        // Use CKFVideoSession for video capture
        // let session = CKFVideoSession()
        
        let previewView = CKFPreviewView(frame: self.view.bounds)
        previewView.session = session
        
        
        session.capture({ (image, settings) in
            // TODO: Add your code here
        }) { (error) in
            // TODO: Handle error
        }

        
    }
    
    /*
    @objc func closeView(){
        self.dismiss(animated: true, completion: nil)
    }
*/
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        getAlarmReport();
    }
    
    
    func getAlarmReport(){
         if self.isLoading {
             return;
         }

         standAloneIndicator.startAnimating()

        
        
        var headers: HTTPHeaders!
         if KeychainWrapper.standard.string(forKey: "detectordamagereport_email") != nil && KeychainWrapper.standard.string(forKey: "detectordamagereport_password") != nil
         {
             headers = [.authorization(username: KeychainWrapper.standard.string(forKey: "detectordamagereport_email")!, password: KeychainWrapper.standard.string(forKey: "detectordamagereport_password")!)]
         }
         
        AF.request((UIApplication.shared.delegate as! AppDelegate).WebapiURL +  "AlarmReport" + "/" +  String(self.trainListDTO.TrainId), method: HTTPMethod.get, parameters: nil, encoding: JSONEncoding.default, headers: headers, interceptor: nil).responseJSON { (response) in
             print("Request: \(String(describing: response.request))")   // original url request
             print("Response: \(String(describing: response.response))") // http url response
             print("Result: \(response.result)")                         // response serialization result

            self.isLoading = false;
            self.standAloneIndicator.stopAnimating()

            if response.response?.statusCode == 404
            {
                self.alarmReportDTO = nil
                
            }
            else if let err = response.error
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
                    
                    self.alarmReportDTO  = try decoder.decode(AlarmReportDTO.self, from: d)
                    self.alarmReportReasonDTO = self.alarmReportDTO?.alarmReportReasonDTO
                    self.reloadForm()


                 } catch {
                    print(error)
                    /*
                    let errorAlertMessage = UIAlertController(title: "Ett oväntat fel uppstod", message: error.localizedDescription, preferredStyle: .alert)
                     let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
                     errorAlertMessage.addAction(okAction);
                     
                     self.present(errorAlertMessage, animated: true, completion: nil)
                     */
                 }
                 
             }
         }
         
     }
    
    
    
    
    fileprivate func reloadForm()
    {
        let pr = self.form.rowBy(tag: "ReasonPicker") as? PickerRow<String>
        let textAreaRow = self.form.rowBy(tag: "CommentTextAreaRow") as! TextAreaRow

        if let dmsr = pr
        {
            if let al = self.alarmReportDTO
            {
                dmsr.value = al.alarmReportReasonDTO.Name
                print(al.alarmReportReasonDTO.Name)
                print(dmsr.value)
                dmsr.reload()

                textAreaRow.value = al.Comment;
                textAreaRow.reload()

            }
            
        }
    }
    
    
    func createAlarmReport()
    {
        if form.validate().count != 0
        {
            return;
        }
        
        if self.alarmReportReasonDTO == nil
        {
            let alert = UIAlertController(title: "Orsak ej vald", message: "", preferredStyle: UIAlertController.Style.alert)
            if let popoverController = alert.popoverPresentationController {
                popoverController.sourceView =  self.view
            }
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return;
        }
        
        if self.alarmReportReasonDTO.AlarmReportReasonId == -1
        {
            let alert = UIAlertController(title: "Orsak ej vald", message: "", preferredStyle: UIAlertController.Style.alert)
            if let popoverController = alert.popoverPresentationController {
                popoverController.sourceView =  self.view
            }
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return;
        }

        let textAreaRow: TextAreaRow? = form.rowBy(tag: "CommentTextAreaRow")
        var comment = ""
        if let te = textAreaRow
        {
            if let v = te.value
            {
                comment = v
            }
        }
        
        if self.alarmReportDTO != nil
        {
            self.alarmReportDTO?.Comment = comment
        }else
        {
            self.alarmReportDTO = AlarmReportDTO(AlarmReportId: nil, alarmReportReasonDTO: self.alarmReportReasonDTO, TrainId: self.trainListDTO.TrainId, ReportedDateTime: Date.init().iso8601, Comment: comment)
        }
        
        self.alarmReportDTO?.alarmReportReasonDTO = self.alarmReportReasonDTO
        print(self.alarmReportDTO?.alarmReportReasonDTO.Name)
        SwiftSpinner.show("Sparar...")
        
        
        // let appDel = UIApplication.shared.delegate as! AppDelegate
        let requestString: String = (UIApplication.shared.delegate as! AppDelegate).WebapiURL +  "AlarmReport" + "/SaveAlarmReport"
        print(requestString)
        
        
        var headers: HTTPHeaders!
        if KeychainWrapper.standard.string(forKey: "detectordamagereport_email") != nil && KeychainWrapper.standard.string(forKey: "detectordamagereport_password") != nil
        {
            headers = [.authorization(username: KeychainWrapper.standard.string(forKey: "detectordamagereport_email")!, password: KeychainWrapper.standard.string(forKey: "detectordamagereport_password")!)]
        }
        
        
        var dict = [String: Any]()
        do {
            dict = try self.alarmReportDTO.asDictionary()
        }catch {
            print("Unexpected error: \(error).")
            return
        }
        
        
        AF.request(requestString, method: HTTPMethod.post, parameters: dict, encoding: JSONEncoding.default, headers: headers, interceptor: nil).responseJSON { (response) in
            print("Request: \(String(describing: response.request))")   // original url request
            print("Response: \(String(describing: response.response))") // http url response
            print("Result: \(response.result)")                         // response serialization result
            

            if (response.response != nil && response.response!.statusCode >= 200 && response.response!.statusCode < 300 )
            {
                SwiftSpinner.hide()
                
                let alert = UIAlertController(title: "Larmrapport sparad", message: "", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { (action) in
                    self.navigationController?.popViewController(animated: true)
                    //self.dismiss(animated: true, completion: nil)
                }))
                
                if let popoverController = alert.popoverPresentationController {
                    popoverController.sourceView =  self.view
                }
                
                self.present(alert, animated: true, completion: nil)
                return
            }
                
            else if(response.error != nil)
            {
                
                SwiftSpinner.hide()
                
                print(response.error)
                
                let alert = UIAlertController(title: "Fel", message: "Ett oväntat fel inträffade", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                if let popoverController = alert.popoverPresentationController {
                    popoverController.sourceView =  self.view
                }
                
                self.present(alert, animated: true, completion: nil)
                return;
            }else{
                //print(response?.statusCode)
                //print(NSString(data: data!, encoding:NSUTF8StringEncoding));
                
                let alert = UIAlertController(title: "Fel", message: "Ett oväntat fel inträffade", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                if let popoverController = alert.popoverPresentationController {
                    popoverController.sourceView =  self.view
                }
                
                self.present(alert, animated: true, completion: nil)
                SwiftSpinner.hide()
                return
            }
            
            
            
        }
    }
}
