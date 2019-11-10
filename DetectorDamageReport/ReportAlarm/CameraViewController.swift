//
//  CameraViewController.swift
//  DetectorDamageReport
//
//  Created by Jonas Isaksson on 2019-11-07.
//  Copyright © 2019 Jonas Isaksson. All rights reserved.
//

import AVFoundation
import UIKit
import Alamofire
import SwiftKeychainWrapper
import FTLinearActivityIndicator
class CameraViewController: UIViewController {

    var alarmReportDTO: AlarmReportDTO?
    var isLoading:Bool = false;

    var capturePreviewView: UIView =
    {
        let t = UIView()
        t.translatesAutoresizingMaskIntoConstraints = false;
        return t;
    }()
    
    var captureButton: UIButton =
    {
        let t = UIButton()
        t.translatesAutoresizingMaskIntoConstraints = false;
        return t;
    }()

    
    var toggleCameraButton: UIButton =
    {
        let t = UIButton()
        t.translatesAutoresizingMaskIntoConstraints = false;
        let btnImage = UIImage(named: "Rear Camera Icon")
        t.setImage(btnImage , for: UIControl.State.normal)
        
        return t;
    }()
   
    var toggleFlashButton: UIButton =
    {
        let t = UIButton()
        t.translatesAutoresizingMaskIntoConstraints = false;
        let btnImage = UIImage(named: "Flash Off Icon")
        t.setImage(btnImage , for: UIControl.State.normal)
        
        return t;
    }()
    

        let cameraController = CameraController()
        override var prefersStatusBarHidden: Bool { return true }
        
    }

    extension CameraViewController {
        override func viewDidLoad() {
            
            
            
            
            self.view.addSubview(capturePreviewView)
            capturePreviewView.addSubview(captureButton)
            capturePreviewView.addSubview(toggleCameraButton)
            capturePreviewView.addSubview(toggleFlashButton)

            
            
            
           // capturePreviewView.addSubview(photoModeButton)

            capturePreviewView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0).isActive = true
            capturePreviewView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0).isActive = true
            capturePreviewView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 0) .isActive = true;
            capturePreviewView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 0) .isActive = true;

            //captureButton.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0).isActive = true
            captureButton.bottomAnchor.constraint(equalTo: capturePreviewView.bottomAnchor, constant: 0).isActive = true
            captureButton.heightAnchor.constraint(equalToConstant: 100).isActive = true;
            captureButton.widthAnchor.constraint(equalToConstant: 100).isActive = true;
            captureButton.centerXAnchor.constraint(equalToSystemSpacingAfter: capturePreviewView.centerXAnchor, multiplier: 0).isActive = true
            captureButton.addTarget(self, action: #selector(self.captureImage(_:)), for: .touchUpInside)

            /*
            photoModeButton.bottomAnchor.constraint(equalTo: capturePreviewView.bottomAnchor, constant: 0).isActive = true
            photoModeButton.heightAnchor.constraint(equalToConstant: 100).isActive = true;
            photoModeButton.widthAnchor.constraint(equalToConstant: 100).isActive = true;
            photoModeButton.centerXAnchor.constraint(equalToSystemSpacingAfter: capturePreviewView.centerXAnchor, multiplier: 0).isActive = true
            photoModeButton.addTarget(self, action: #selector(self.captureImage(_:)), for: .touchUpInside)

            */
            
            toggleCameraButton.topAnchor.constraint(equalTo: capturePreviewView.topAnchor, constant: 20).isActive = true
            toggleCameraButton.heightAnchor.constraint(equalToConstant: 100).isActive = true;
            toggleCameraButton.widthAnchor.constraint(equalToConstant: 100).isActive = true;
            toggleCameraButton.rightAnchor.constraint(equalTo: capturePreviewView.rightAnchor, constant: -100).isActive = true
            toggleCameraButton.addTarget(self, action: #selector(self.switchCameras), for: .touchUpInside)

            toggleFlashButton.topAnchor.constraint(equalTo: toggleCameraButton.bottomAnchor, constant: 20).isActive = true
            toggleFlashButton.heightAnchor.constraint(equalToConstant: 100).isActive = true;
            toggleFlashButton.widthAnchor.constraint(equalToConstant: 100).isActive = true;
            toggleFlashButton.rightAnchor.constraint(equalTo: capturePreviewView.rightAnchor, constant: -100).isActive = true
            toggleFlashButton.addTarget(self, action: #selector(self.toggleFlash(_:)), for: .touchUpInside)

            
            func configureCameraController() {
                cameraController.prepare {(error) in
                    if let error = error {
                        print(error)
                    }
                    
                    try? self.cameraController.displayPreview(on: self.capturePreviewView)
                }
            }
            
            func styleCaptureButton() {
                captureButton.layer.borderColor = UIColor.black.cgColor
                captureButton.layer.borderWidth = 2
                
                captureButton.layer.cornerRadius = min(captureButton.frame.width, captureButton.frame.height) / 2
            }
            
            styleCaptureButton()
            configureCameraController()
            
        }
    }

    extension CameraViewController {
        @objc func toggleFlash(_ sender: UIButton) {
            if cameraController.flashMode == .on {
                cameraController.flashMode = .off
                toggleFlashButton.setImage(#imageLiteral(resourceName: "Flash Off Icon"), for: .normal)
            }
                
            else {
                cameraController.flashMode = .on
                toggleFlashButton.setImage(#imageLiteral(resourceName: "Flash On Icon"), for: .normal)
            }
        }
        
        @objc func switchCameras(_ sender: UIButton) {
            do {
                try cameraController.switchCameras()
            }
                
            catch {
                print(error)
            }
            
            switch cameraController.currentCameraPosition {
            case .some(.front):
                toggleCameraButton.setImage(#imageLiteral(resourceName: "Front Camera Icon"), for: .normal)
                
            case .some(.rear):
                toggleCameraButton.setImage(#imageLiteral(resourceName: "Rear Camera Icon"), for: .normal)
                
            case .none:
                return
            }
        }
        
        @objc func captureImage(_ sender: UIButton) {
            cameraController.captureImage {(image, error) in
                guard  image != nil else {
                    print(error ?? "Image capture error")
                    return
                }
                
                let imageData =  image!.superCompress(image!, maxHeight: 1080.0, maxWidth: 1080.0)
                let base64String = imageData.base64EncodedString(options: .lineLength64Characters)
                
                let alarmReportImageBinDTOs = AlarmReportImageBinDTO(AlarmReportImageBinId: nil, Image: base64String)
                
                
                let alarmReportImageDTOs = AlarmReportImageDTO(AlarmReportImageId: nil, AlarmReportId: self.alarmReportDTO?.AlarmReportId!, Description: "", AlarmReportImageBinDTO: alarmReportImageBinDTOs, AlarmReportImageThumbnailBinDTO: nil)
                
                
                
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
                    self.isLoading = false;
                    //self.standAloneIndicator.stopAnimating()

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
                        self.dismiss(animated: true, completion: nil)
                    }
                    uploadedMessage.addAction(okAction);
                    self.present(uploadedMessage, animated: true, completion: nil)
                }
            }
        }
    }

