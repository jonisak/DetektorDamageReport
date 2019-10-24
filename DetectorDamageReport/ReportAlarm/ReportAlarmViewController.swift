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

class ReportAlarmViewController : FormViewController {
    
    //var indexPath = 0
    var trainDTO : TrainDTO!
    var alarmReportReasonDTO : AlarmReportReasonDTO!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Rapportera larm"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Stäng", style: UIBarButtonItem.Style.done, target: self, action: #selector(self.closeView))

        
        form +++
            

            Section("")
            <<< PickerRow<String>("Välj orsak") { (row : PickerRow<String>) -> Void in
                
                row.options = []
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
                    
                    
                   // s//elf.indexPath = self.index(ofAccessibilityElement: row.options)
                    
                    // print(row.indexPath)
                /*
                    if let row = row.indexPath
                   {
                    
                    self.indexPath =  row.row
                    }
 */
                    
                })
//        Section("Kommentar")
            

            <<< TextAreaRow(){
                //$0.tag = tag
                $0.placeholder = "Kommentar"
                $0.textAreaHeight = .dynamic(initialTextViewHeight: 96)
                $0.tag = "TEXT_AREA"
        }
        
            <<< ButtonRow(){row in
                row.title = "Spara"
                
                }.onCellSelection { [weak self] (cell, row) in
                    self?.createAlarmReport()
        }
        
    }
    
    @objc func closeView(){
        self.dismiss(animated: true, completion: nil)
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

    
        
        
        
        let textAreaRow: TextAreaRow? = form.rowBy(tag: "TEXT_AREA")

        let comment = (textAreaRow?.value)!;

        
        let alarmReportDTO = AlarmReportDTO(AlarmReportId: 1, alarmReportReasonDTO: self.alarmReportReasonDTO, trainDTo: trainDTO, ReportedDateTime: Date.init().iso8601, Comment: comment)
        
        
        SwiftSpinner.show("Sparar...")
        
        
        // let appDel = UIApplication.shared.delegate as! AppDelegate
        let requestString: String = (UIApplication.shared.delegate as! AppDelegate).WebapiURL +  "AlarmReport"
        print(requestString)
        
        
        var headers: HTTPHeaders!
        if KeychainWrapper.standard.string(forKey: "detectordamagereport_email") != nil && KeychainWrapper.standard.string(forKey: "detectordamagereport_password") != nil
        {
            headers = [.authorization(username: KeychainWrapper.standard.string(forKey: "detectordamagereport_email")!, password: KeychainWrapper.standard.string(forKey: "detectordamagereport_password")!)]
        }
        
        
        var dict = [String: Any]()
        //var jsonSring = ""
        do {
            //  let encoder = JSONEncoder()
            //  let data = try encoder.encode(pagingDTO)
            //  jsonSring = String(data: data, encoding: .utf8)!
            dict = try alarmReportDTO.asDictionary()
        }catch {
            print("Unexpected error: \(error).")
            return
        }
        
        
        AF.request((UIApplication.shared.delegate as! AppDelegate).WebapiURL +  "AlarmReport", method: HTTPMethod.post, parameters: dict, encoding: JSONEncoding.default, headers: headers, interceptor: nil).responseJSON { (response) in
            print("Request: \(String(describing: response.request))")   // original url request
            print("Response: \(String(describing: response.response))") // http url response
            print("Result: \(response.result)")                         // response serialization result
            

            if (response.response != nil && response.response!.statusCode >= 200 && response.response!.statusCode < 300 )
            {
                SwiftSpinner.hide()
                
                
                
                
                let alert = UIAlertController(title: "Larmrapport skapad", message: "", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { (action) in
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
