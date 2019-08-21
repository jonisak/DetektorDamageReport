//
//  VehicleViewController.swift
//  DetectorDamageReport
//
//  Created by Jonas Isaksson on 2019-07-19.
//  Copyright © 2019 Jonas Isaksson. All rights reserved.
//

import UIKit

class VehicleViewController: UIViewController//, UITableViewDelegate, UITableViewDataSource
{

    //var trainDTOList = [TrainDTO]();
    
    var trainListDTO : TrainListDTO!
    
    var selectedTraindIndex = 0;
    var tblView: UITableView = {
        let t = UITableView()
        t.translatesAutoresizingMaskIntoConstraints = false;
        return t;
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.view.addSubview(tblView)
        /*
        tblView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        tblView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        tblView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        tblView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        tblView.register(VehicleTableViewCell.self, forCellReuseIdentifier: "CELL")
        tblView.register(VehicleDetailTableViewCell.self, forCellReuseIdentifier: "CELL_DETAIL")

        tblView.delegate = self
        tblView.dataSource = self
        tblView.rowHeight = UITableView.automaticDimension
        tblView.estimatedRowHeight = 100
 */
    }

    
    /*
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let ve = self.trainDTOList[selectedTraindIndex].Vehicles
        {
            return ve.count
        }else
        {
            return 0
        }
        
    }
    
    enum IndentLevelLabel:Int {
        case Level0 = 0
        case Level1 = 20
        case Level2 = 30
       case  Level3 = 40

    }
    
    func getCellLabel(labelText:String, indentLevel:IndentLevelLabel)->UILabel
    {
        let label = UILabel.init()
        label.textColor = .black
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = labelText
        label.padding = UIEdgeInsets(top: 0, left: CGFloat(indentLevel.rawValue), bottom: 0, right: 0)

        return label
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell : VehicleDetailTableViewCell! = tableView.dequeueReusableCell(withIdentifier: "CELL_DETAIL") as?VehicleDetailTableViewCell

        for view in cell.contentView.subviews
        {
            view.removeFromSuperview()
        }
        
        
        if let ve = self.trainDTOList[selectedTraindIndex].Vehicles?[indexPath.row]
        {
            var labelArr = [UILabel]()
            labelArr.append(getCellLabel(labelText: "Fordonsnummer: " + ve.VehicleNumber, indentLevel: IndentLevelLabel.Level0))
            labelArr.append(getCellLabel(labelText: "Hastighet: " + String(ve.Speed), indentLevel: IndentLevelLabel.Level0))
            labelArr.append(getCellLabel(labelText: "Antal axlar: " + String(ve.AxleCount), indentLevel: IndentLevelLabel.Level0))

            
            if ve.WheelDamageMeasureDataVehicleList.count>0
            {
                labelArr.append(getCellLabel(labelText: "Lastfördelning", indentLevel: IndentLevelLabel.Level0))

                for item in ve.WheelDamageMeasureDataVehicleList
                {
                    labelArr.append(getCellLabel(labelText: "Fram/Bak" + String(item.FrontRearLoadRatio), indentLevel: IndentLevelLabel.Level1))
                    labelArr.append(getCellLabel(labelText: "Vänster/Höger" + String(item.LeftRightLoadRatio), indentLevel: IndentLevelLabel.Level1))
                    labelArr.append(getCellLabel(labelText: "Vikt" + String(item.WeightInTons) + " ton", indentLevel: IndentLevelLabel.Level1))

                }
                
            }
            
            
            for axle in ve.AxleList
            {
                
                if let axlenumber = axle.AxleNumber
                {
                    labelArr.append(getCellLabel(labelText: "Axel: " + String(String(axlenumber)), indentLevel: IndentLevelLabel.Level1))
                }else
                {
                    labelArr.append(getCellLabel(labelText: "Axel: - ", indentLevel: IndentLevelLabel.Level1))
                }
                
                if let wheelList =  axle.WheelList
                {
                    var hjulnummer = 1

                    for wheel in wheelList
                    {
                        labelArr.append(getCellLabel(labelText: "Hjul: " + String(hjulnummer), indentLevel: IndentLevelLabel.Level2))
                        hjulnummer = hjulnummer + 1
                        
                        if let hotBoxHotWheelMeasureWheelDataList = wheel.HotBoxHotWheelMeasureWheelDataList
                        {
                            for hotBoxHotWheelMeasureWheelData in hotBoxHotWheelMeasureWheelDataList
                            {
                                if let hotBoxLeftValue =  hotBoxHotWheelMeasureWheelData.HotBoxLeftValue{
                                    labelArr.append(getCellLabel(labelText: "Varmgång vänster: " + String(hotBoxLeftValue) + "°C", indentLevel: IndentLevelLabel.Level3))

                                }
                                if let hotBoxRightValue =  hotBoxHotWheelMeasureWheelData.HotBoxRightValue{
                                    labelArr.append(getCellLabel(labelText: "Varmgång höger: " + String(hotBoxRightValue) + "°C", indentLevel: IndentLevelLabel.Level3))
                                }
                                
                                if let hotWheelLeftValue =  hotBoxHotWheelMeasureWheelData.HotWheelLeftValue{
                                    labelArr.append(getCellLabel(labelText: "Tjuvbroms vänster: " + String(hotWheelLeftValue) + "°C", indentLevel: IndentLevelLabel.Level3))
                                    
                                }
                                if let hotWheelRightValue =  hotBoxHotWheelMeasureWheelData.HotWheelRightValue{
                                    labelArr.append(getCellLabel(labelText: "Tjuvbroms höger: " + String(hotWheelRightValue) + "°C", indentLevel: IndentLevelLabel.Level3))
                                }
                            }
                        }
                    }
                }
                
                
 
                
            }
            
            let stackView = UIStackView.init(arrangedSubviews: labelArr)
            stackView.translatesAutoresizingMaskIntoConstraints = false
            stackView.axis = .vertical
            stackView.distribution = .fill
            stackView.alignment = .fill
            cell.contentView.addSubview(stackView)
            stackView.centerXAnchor.constraint(equalTo: cell.contentView.centerXAnchor).isActive = true
            stackView.centerYAnchor.constraint(equalTo: cell.contentView.centerYAnchor).isActive = true
            stackView.widthAnchor.constraint(equalTo: cell.contentView.widthAnchor).isActive = true
            stackView.heightAnchor.constraint(equalTo: cell.contentView.heightAnchor).isActive = true
            stackView.isLayoutMarginsRelativeArrangement = true
            stackView.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 15, leading: 15, bottom: 15, trailing: 15)
        }
        
        
        
        
        
        
        /*
        var cell : VehicleTableViewCell! = tableView.dequeueReusableCell(withIdentifier: "CELL") as?VehicleTableViewCell
        
        
        
        if (cell == nil) {
            cell = VehicleTableViewCell.init(style: UITableViewCell.CellStyle.default,
                                           reuseIdentifier:"CELL");
        }
       
        if let ve = self.trainDTOList[selectedTraindIndex].Vehicles
        {
            cell.vehicleNumberLabel.text = "Fordonsnummer: " + ve[indexPath.row].VehicleNumber
            cell.speedLabel.text = "Hastighet: " + String(ve[indexPath.row].Speed)
            cell.axleCountLabel.text = "Axlar: " + String(ve[indexPath.row].AxleCount)
            cell.accessoryType = .disclosureIndicator
        }
 */
        return cell;
    }
    /*
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
 */
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    /*
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let ve = VehicleViewController();
        ve.trainDTOList = self.trainDTOList;
        ve.selectedTraindIndex = indexPath.row
        self.navigationController?.pushViewController(ve, animated: true);
    }
    */
    
    
    /*
     
     func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
     return UITableView.automaticDimension
     }
     */
 */
}
