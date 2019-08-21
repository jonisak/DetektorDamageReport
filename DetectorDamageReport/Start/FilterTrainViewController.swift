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
                //$0.options = ["🍝", "🍟", "🍕", "🍚"]
                //$0.value = ["🍝", "🍕" ]
                }.cellSetup({ (cell, row) in
                    
                    //row.options = ["🍝", "🍟", "🍕", "🍚"]
                    
                    var opt = [String]()
                    var sel = Set<String>()
                    for apa in (UIApplication.shared.delegate as! AppDelegate).trainFilterDTO.DeviceTypeDTOList
                    {
                        opt.append(apa.DeviceTypeDisplayName)
                        if(apa.Selected)
                        {
                            sel.insert(apa.DeviceTypeDisplayName)
                        }
                        //row.value = sel;
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

            <<< PhoneRow(){
                $0.title = "Phone Row"
                $0.placeholder = "And numbers here"
            }
            +++ Section("Section2")
            <<< DateRow(){
                $0.title = "Date Row"
                $0.value = Date(timeIntervalSinceReferenceDate: 0)
        }
    }
    

    
    
    
    @objc func closeView(){
        self.dismiss(animated: true, completion: nil)
    }


}
