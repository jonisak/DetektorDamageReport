//
//  SortTrainViewController.swift
//  DetectorDamageReport
//
//  Created by Jonas Isaksson on 2019-08-09.
//  Copyright © 2019 Jonas Isaksson. All rights reserved.
//

import UIKit
import Eureka
class FilterTrainViewController: FormViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Stäng", style: UIBarButtonItem.Style.done, target: self, action: #selector(self.closeView))
        // Do any additional setup after loading the view.
        form +++ Section("")
            <<< SwitchRow(){ row in
                row.title = "Larm"
                row.value = (UIApplication.shared.delegate as! AppDelegate).trainFilterDTO.ShowTrainWithAlarmOnly
                
                }.onChange({ (row) in
                   
                    if let v = row.value
                    {
                        (UIApplication.shared.delegate as! AppDelegate).trainFilterDTO.ShowTrainWithAlarmOnly = v
                    }
                    
                    
                })
            
            <<< MultipleSelectorRow<String>() {
                $0.title = "Detektortyp"
                }.cellSetup({ (cell, row) in
                    var opt = [String]()
                    var sel = Set<String>()
                    for apa in (UIApplication.shared.delegate as! AppDelegate).trainFilterDTO.DeviceTypeDTOList
                    {
                        opt.append(apa.DeviceTypeDisplayName)
                        if(apa.Selected)
                        {
                            sel.insert(apa.DeviceTypeDisplayName)
                        }
                    }
                    row.options = opt
                    row.value = sel
                }).onCellSelection({ (push, row) in
                    print(row.value);
                }).onChange({ (row) in
                    print(row.value)
                    for index in 0..<(UIApplication.shared.delegate as! AppDelegate).trainFilterDTO.DeviceTypeDTOList.count
                    {
                       (UIApplication.shared.delegate as! AppDelegate).trainFilterDTO.DeviceTypeDTOList[index].Selected = false
                    }
                    if let v = row.value
                    {
                        for selItem in v
                        {
                            for  index in 0..<(UIApplication.shared.delegate as! AppDelegate).trainFilterDTO.DeviceTypeDTOList.count
                            {
                                
                                if selItem ==  (UIApplication.shared.delegate as! AppDelegate).trainFilterDTO.DeviceTypeDTOList[index].DeviceTypeDisplayName
                                {
                                    (UIApplication.shared.delegate as! AppDelegate).trainFilterDTO.DeviceTypeDTOList[index].Selected = true
                                }
                            }
                        }
                    }
                })
            <<< PhoneRow()
            {
                $0.title = "Tågnummer"
                //$0.value = Int((UIApplication.shared.delegate as! AppDelegate).trainFilterDTO.TrainNumber)
                }.onChange({ (row) in
                    if let v = row.value
                    {
                     
                        if v.count == 0
                        {
                            (UIApplication.shared.delegate as! AppDelegate).trainFilterDTO.TrainNumber = ""
                        }else
                        {
                            (UIApplication.shared.delegate as! AppDelegate).trainFilterDTO.TrainNumber = v
                        }
                    }else
                    {
                        (UIApplication.shared.delegate as! AppDelegate).trainFilterDTO.TrainNumber = ""
                    }
                }).cellSetup({ (cell, row) in
                    if (UIApplication.shared.delegate as! AppDelegate).trainFilterDTO.TrainNumber.count > 0
                    {
                        row.value = (UIApplication.shared.delegate as! AppDelegate).trainFilterDTO.TrainNumber
                    }else
                    {
                        row.value = nil
                    }
                })
          
            +++ Section("Datum")
            <<< DateRow(){
                $0.title = "From"
                //$0.value = Date(timeIntervalSinceReferenceDate: 0)
                }.cellSetup({ (dateCell, DateRow) in
                    
                    if((UIApplication.shared.delegate as! AppDelegate).trainFilterDTO.FromDate.count>0)
                    {
                        if let date = (UIApplication.shared.delegate as! AppDelegate).trainFilterDTO.FromDate.iso8601 {
                            DateRow.value = date;
                        }
                    }else
                    {
                        DateRow.value = nil
                    }
                    
                    
                    
                }).onChange({ (row) in
                  
                    if let d =  row.value
                    {
                     (UIApplication.shared.delegate as! AppDelegate).trainFilterDTO.FromDate  = d.iso8601
                    }
                    
                   //
                })
            <<< DateRow(){
                $0.title = "Tom"
                //$0.value = Date(timeIntervalSinceReferenceDate: 0)
                }.cellSetup({ (dateCell, DateRow) in
                    if((UIApplication.shared.delegate as! AppDelegate).trainFilterDTO.ToDate.count>0)
                    {
                        if let date = (UIApplication.shared.delegate as! AppDelegate).trainFilterDTO.ToDate.iso8601 {
                            DateRow.value = date;
                        }
                    }else
                    {
                        DateRow.value = nil
                    }
                    
                }).onChange({ (row) in
                    if let d =  row.value
                    {
                        (UIApplication.shared.delegate as! AppDelegate).trainFilterDTO.ToDate =  d.iso8601
                    }
                    
                })
    }
    

    
    
    
    @objc func closeView(){
        self.dismiss(animated: true, completion: nil)
    }


}
