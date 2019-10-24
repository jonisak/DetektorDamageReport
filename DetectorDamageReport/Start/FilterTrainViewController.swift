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
    var delegate:reloadStartViewDelegate?

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

                }).onChange({ (row) in

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
            <<< MultipleSelectorRow<String>() {
                $0.title = "Detektorer"
                 
                //$0.options = (UIApplication.shared.delegate as! AppDelegate).detectornDTOList.a
                }.cellSetup({ (cell, row) in
                    var opt = [String]()
                    var sel = Set<String>()
                    
                    for detektor in (UIApplication.shared.delegate as! AppDelegate).detectornDTOList
                    {
                        opt.append(detektor.Name)
                        for det in (UIApplication.shared.delegate as! AppDelegate).trainFilterDTO.SelectedDetectorsDTOList
                        {
                            if det.DetectorId == detektor.DetectorId
                            {
                                sel.insert(detektor.Name)
                                continue
                            }
                        }
                    }
                
                    row.options = opt
                    row.value = sel
                }).onCellSelection({ (push, row) in
                    
                    
                }).onChange({ (row) in

                    (UIApplication.shared.delegate as! AppDelegate).trainFilterDTO.SelectedDetectorsDTOList.removeAll()

                    if let v = row.value
                    {
                        for selItem in v
                        {
                            
                            for de in (UIApplication.shared.delegate as! AppDelegate).detectornDTOList
                            {
                                
                                if selItem == de.Name
                                {
                                    (UIApplication.shared.delegate as! AppDelegate).trainFilterDTO.SelectedDetectorsDTOList.append(de)
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
         self.delegate?.reload()
        self.dismiss(animated: true, completion: nil)
    }


}
