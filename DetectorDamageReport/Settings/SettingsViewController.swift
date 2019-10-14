//
//  SettingsViewController.swift
//  DetectorDamageReport
//
//  Created by Jonas Isaksson on 2019-08-22.
//  Copyright © 2019 Jonas Isaksson. All rights reserved.
//

import UIKit
import Eureka
import SwiftSpinner
import Alamofire
import SwiftKeychainWrapper


protocol reloadStartViewDelegate {
    func reload()
}


class SettingsViewController: FormViewController {
    var delegate:reloadStartViewDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
       
/*
        form +++
             Section("Inloggningsuppgifter")
            <<< EmailRow(){row in
                row.title = "E-post"
            }
            
            <<< PasswordRow(){ row in
                row.title = "Lösenord"
        }
        <<< ButtonRow(){row in
            row.title = "Spara"
            
        }
        */
        
        form +++
            Section("")
            <<< EmailRow(){ row in
                row.title = "Epost"
                row.placeholder = ""
                row.tag = "EMAIL_TEXT"
                
                if KeychainWrapper.standard.string(forKey: "detectordamagereport_email") != nil
                {
                    row.value = KeychainWrapper.standard.string(forKey: "detectordamagereport_email")!
                }
                
                
                
                //row.add(rule: RuleEmail())
                
                //row.validationOptions = .validatesOnChange
                /*
                }.cellUpdate { cell, row in
                    if !row.isValid {
                        cell.titleLabel?.textColor = .red
                    }
                }.cellUpdate({ (cell, row) in
                    cell.textLabel?.textColor =  UIColor(red: 170.0/255, green: 170.0/255.0, blue: 170.0/255, alpha: 1.0)
                })*/
            }
            <<< PasswordRow(){ row in
                row.title = "Lösenord"
                row.placeholder = ""
                row.tag = "PASSWORD_TEXT"
                if KeychainWrapper.standard.string(forKey: "detectordamagereport_password") != nil
                {
                    row.value = KeychainWrapper.standard.string(forKey: "detectordamagereport_password")!
                }
                
            }
            
            +++ Section()
            <<< ButtonRow() { (row: ButtonRow) -> Void in
                row.title = "Logga in"
                }
                .onCellSelection { [weak self] (cell, row) in
                    self?.Login()
        }
        
        
    }
    
    func Login()
    {
        
        if form.validate().count != 0
        {
            return;
        }
        let emailRow: EmailRow? = form.rowBy(tag: "EMAIL_TEXT")
        let passwordRow: PasswordRow? = form.rowBy(tag: "PASSWORD_TEXT")
        
        
        if emailRow?.value == nil || emailRow!.value?.count == 0 {
            let alert = UIAlertController(title: "E-post saknas", message: "", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            if let popoverController = alert.popoverPresentationController {
                popoverController.sourceView =  self.view
            }
            
            self.present(alert, animated: true, completion: nil)
            return;
        }
        if passwordRow?.value == nil || passwordRow!.value?.count == 0 {
            let alert = UIAlertController(title: "Lösenord saknas", message: "", preferredStyle: UIAlertController.Style.alert)
            if let popoverController = alert.popoverPresentationController {
                popoverController.sourceView =  self.view
            }
            
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return;
        }
        
        SwiftSpinner.show("Loggar in...")
        
        
       // let appDel = UIApplication.shared.delegate as! AppDelegate
        let requestString: String = (UIApplication.shared.delegate as! AppDelegate).WebapiURL +  "Train" + "/Login"
        print(requestString)
        let email = (emailRow?.value)!;
        let password = (passwordRow?.value)!;
        
        
        let headers: HTTPHeaders = [.authorization(username: email, password: password)]

        
        AF.request(requestString, method: HTTPMethod.get, parameters: nil, encoding: URLEncoding.default, headers: headers, interceptor: nil).responseString { (response) in
            print("Request: \(String(describing: response.request))")   // original url request
            print("Response: \(String(describing: response.response))") // http url response
            print("Result: \(response.result)")                         // response serialization result

            if(response.response!.statusCode == 401)//fel lösenord
            {
                SwiftSpinner.hide()
                
                let alert = UIAlertController(title: "Ogiltig inloggning", message: "", preferredStyle: UIAlertController.Style.alert)
                let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
                    UIAlertAction in
                    
                }
                if let popoverController = alert.popoverPresentationController {
                    popoverController.sourceView =  self.view
                }
                
                alert.addAction(okAction)
                self.present(alert, animated: true, completion: nil)
                
                return;
            }
            else if (response.response!.statusCode >= 200 && response.response!.statusCode < 300 )
            {
                SwiftSpinner.hide()
                
                
                _ = KeychainWrapper.standard.set((emailRow?.value)!, forKey: "detectordamagereport_email")
                _ = KeychainWrapper.standard.set((passwordRow?.value)!, forKey: "detectordamagereport_password")
                //self.delegate!.runGetAppStartinfo();
                //self.dismiss(animated: true, completion: nil);
                
                
                let alert = UIAlertController(title: "Inloggning Ok", message: "", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler:  { (action) in
                    self.delegate?.reload()

                    self.dismiss(animated: true, completion: nil)
                    
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
