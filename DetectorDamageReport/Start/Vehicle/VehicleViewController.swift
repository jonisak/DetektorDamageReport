//
//  VehicleViewController.swift
//  DetectorDamageReport
//
//  Created by Jonas Isaksson on 2019-07-19.
//  Copyright © 2019 Jonas Isaksson. All rights reserved.
//

import UIKit
import Alamofire
import SwiftKeychainWrapper
class VehicleViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    var trainListDTO : TrainListDTO!
    var trainDTO : TrainDTO!
    var isLoading = false
    var tblView: UITableView = {
        let t = UITableView()
        t.translatesAutoresizingMaskIntoConstraints = false;
        return t;
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.view.addSubview(tblView)
        
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
       
        tblView.separatorStyle = .none;

    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated);
        
        self.fetchData()
        
    }
    
    func fetchData(){
        
        
        
        if self.isLoading {
            return;
        }
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true;

        var headers: HTTPHeaders!
        if KeychainWrapper.standard.string(forKey: "detectordamagereport_email") != nil && KeychainWrapper.standard.string(forKey: "detectordamagereport_password") != nil
        {
            headers = [.authorization(username: KeychainWrapper.standard.string(forKey: "detectordamagereport_email")!, password: KeychainWrapper.standard.string(forKey: "detectordamagereport_password")!)]
        }
        
        AF.request((UIApplication.shared.delegate as! AppDelegate).WebapiURL +  "Train/" + String(trainListDTO.TrainId), method: HTTPMethod.get, parameters: nil, encoding: JSONEncoding.default, headers: headers, interceptor: nil).responseJSON { (response) in
            print("Request: \(String(describing: response.request))")   // original url request
            print("Response: \(String(describing: response.response))") // http url response
            print("Result: \(response.result)")                         // response serialization result
            
            self.isLoading = false;
            print(response.error);
            
            if let d = response.data{
                do {
                    let decoder = JSONDecoder() //or any other Decoder
                    let tr = try decoder.decode(TrainDTO.self, from: d)

                    self.trainDTO = tr
                    
                    
                    DispatchQueue.main.async {
                        self.tblView.reloadData()
                    }
                    //}
                } catch {
                    print(error)
                    
                }
                
            }
        }
        
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.trainDTO != nil
        {
            if let v =  self.trainDTO.Vehicles
            {
                return v.count
            }else
            {
                return 0
            }
        }
        return 0
    }
    
    enum IndentLevelLabel:Int {
        case Level0 = 0
        case Level1 = 20
        case Level2 = 30
       case  Level3 = 40

    }
    
    func getCellLabel(labelText:String, indentLevel:IndentLevelLabel, image:UIImage?)->UILabel
    {

        let label = UILabel.init()
        label.textColor = .black
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        //label.text = labelText
        label.padding = UIEdgeInsets(top: 0, left: CGFloat(indentLevel.rawValue), bottom: 0, right: 0)

        let completeText = NSMutableAttributedString(string: labelText)

        if let img = image
        {
            let imageAttachment =  NSTextAttachment()
            imageAttachment.image = img
            let imageOffsetY:CGFloat = 0.0;
            //imageAttachment.bounds = CGRect(x: 0, y: imageOffsetY, width: imageAttachment.image!.size.width, height: imageAttachment.image!.size.height)
            imageAttachment.bounds = CGRect(x: 0, y: imageOffsetY, width: 25, height: 25)

            let attachmentString = NSAttributedString(attachment: imageAttachment)
            completeText.append(attachmentString)

        }
        //Add image to mutable string
        //Add your text to mutable string
        //let  textAfterIcon =
        //completeText.append(NSMutableAttributedString(string: labelText))
        label.textAlignment = .left;
        label.attributedText = completeText;

        return label
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell : VehicleDetailTableViewCell! = tableView.dequeueReusableCell(withIdentifier: "CELL_DETAIL") as?VehicleDetailTableViewCell

        for view in cell.contentView.subviews
        {
            view.removeFromSuperview()
        }
        

        
        if let ve = self.trainDTO.Vehicles?[indexPath.row]
        {
            var labelArr = [UILabel]()
            labelArr.append(getCellLabel(labelText: "Fordonsnummer: " + ve.VehicleNumber, indentLevel: IndentLevelLabel.Level0, image: nil))
            labelArr.append(getCellLabel(labelText: "Hastighet: " + String(ve.Speed), indentLevel: IndentLevelLabel.Level0, image: nil))
            labelArr.append(getCellLabel(labelText: "Antal axlar: " + String(ve.AxleCount), indentLevel: IndentLevelLabel.Level0, image: nil))

            
            if ve.WheelDamageMeasureDataVehicleList.count>0
            {
                labelArr.append(getCellLabel(labelText: "Lastfördelning", indentLevel: IndentLevelLabel.Level0, image: nil))

                for item in ve.WheelDamageMeasureDataVehicleList
                {
                    if item.FrontRearLoadRatio > 0
                    {
                        labelArr.append(getCellLabel(labelText: "Fram/Bak" + String(item.FrontRearLoadRatio), indentLevel: IndentLevelLabel.Level1, image: nil))
                    }
                    if item.LeftRightLoadRatio > 0
                    {
                        labelArr.append(getCellLabel(labelText: "Vänster/Höger" + String(item.LeftRightLoadRatio), indentLevel: IndentLevelLabel.Level1, image: nil))
                    }
                    if item.WeightInTons > 0
                    {
                        labelArr.append(getCellLabel(labelText: "Vikt: " + String(item.WeightInTons) + " ton", indentLevel: IndentLevelLabel.Level1, image: nil))
                    }

                }
                
            }
            

            for axle in ve.AxleList
            {
                if let axlenumber = axle.AxleNumber
                {
                    labelArr.append(getCellLabel(labelText: "Axel: " + String(String(axlenumber)), indentLevel: IndentLevelLabel.Level1, image: nil))
                }else
                {
                    labelArr.append(getCellLabel(labelText: "Axel: - ", indentLevel: IndentLevelLabel.Level1, image: nil))
                }
                
                
                
                if let wheelDamageMeasureDataAxleList = axle.WheelDamageMeasureDataAxleList
                {
                    for we in wheelDamageMeasureDataAxleList
                    {
                        if let axleLoad = we.AxleLoad
                        {
                            if(axleLoad > 0 )
                            {
                                labelArr.append(getCellLabel(labelText: "Axellast: " + String(format: "%.2f", axleLoad) + " Ton", indentLevel: IndentLevelLabel.Level2, image: nil))
                            }
                        }
                    }
                }
                
                
                if let wheelList =  axle.WheelList
                {
                    var hjulnummer = 1
                    
                    for wheel in wheelList
                    {
                        
                        labelArr.append(getCellLabel(labelText: "Hjul: " + String(hjulnummer), indentLevel: IndentLevelLabel.Level2, image: nil))
                        hjulnummer = hjulnummer + 1
                        
                        

                        if let alerts = wheel.AlertList
                        {
                            if alerts.count > 0
                            {
                                for alert in alerts
                                {
                                    labelArr.append(getCellLabel(labelText: alert.AlarmLevel + " " + alert.DecriptionText, indentLevel: IndentLevelLabel.Level2, image: UIImage(named: "AlertImage")))

                                }

                            }
                        }
                        
                        
                        if let hotBoxHotWheelMeasureWheelDataList = wheel.HotBoxHotWheelMeasureWheelDataList
                        {
                            for hotBoxHotWheelMeasureWheelData in hotBoxHotWheelMeasureWheelDataList
                            {
                                if let hotBoxLeftValue =  hotBoxHotWheelMeasureWheelData.HotBoxLeftValue{
                                    labelArr.append(getCellLabel(labelText: "Varmgång vänster: " + String(hotBoxLeftValue) + "°C", indentLevel: IndentLevelLabel.Level3, image: nil))
                                    
                                }
                                if let hotBoxRightValue =  hotBoxHotWheelMeasureWheelData.HotBoxRightValue{
                                    labelArr.append(getCellLabel(labelText: "Varmgång höger: " + String(hotBoxRightValue) + "°C", indentLevel: IndentLevelLabel.Level3, image: nil))
                                }
                                
                                if let hotWheelLeftValue =  hotBoxHotWheelMeasureWheelData.HotWheelLeftValue{
                                    labelArr.append(getCellLabel(labelText: "Tjuvbroms vänster: " + String(hotWheelLeftValue) + "°C", indentLevel: IndentLevelLabel.Level3, image: nil))
                                    
                                }
                                if let hotWheelRightValue =  hotBoxHotWheelMeasureWheelData.HotWheelRightValue{
                                    labelArr.append(getCellLabel(labelText: "Tjuvbroms höger: " + String(hotWheelRightValue) + "°C", indentLevel: IndentLevelLabel.Level3, image: nil))
                                }
                            }
                        }
                        
                        
                        if let wheelDamageMeasureDataWheelList = wheel.WheelDamageMeasureDataWheelList
                        {
                            for wheelDamageMeasureDataWheel in wheelDamageMeasureDataWheelList
                            {
                                if let LeftWheelDamageMeanValue =  wheelDamageMeasureDataWheel.LeftWheelDamageMeanValue {
                                    labelArr.append(getCellLabel(labelText: "Vänster Mean: " + String(LeftWheelDamageMeanValue), indentLevel: IndentLevelLabel.Level3, image: nil))
                                }
                                if let RightWheelDamageMeanValue =  wheelDamageMeasureDataWheel.RightWheelDamageMeanValue {
                                    labelArr.append(getCellLabel(labelText: "Höger Mean: " + String(RightWheelDamageMeanValue), indentLevel: IndentLevelLabel.Level3, image: nil))
                                }
                                if let LeftWheelDamagePeakValue =  wheelDamageMeasureDataWheel.LeftWheelDamagePeakValue {
                                    labelArr.append(getCellLabel(labelText: "Vänster Peak: " + String(LeftWheelDamagePeakValue), indentLevel: IndentLevelLabel.Level3, image: nil))
                                }
                                if let RightWheelDamageMeanValue =  wheelDamageMeasureDataWheel.RightWheelDamageMeanValue {
                                    labelArr.append(getCellLabel(labelText: "Höger Peak: " + String(RightWheelDamageMeanValue), indentLevel: IndentLevelLabel.Level3, image: nil))
                                }
                                /*
                                if let LeftWheelDamageDistributedLoadValue =  wheelDamageMeasureDataWheel.LeftWheelDamageDistributedLoadValue {
                                    labelArr.append(getCellLabel(labelText: "LeftWheelDamageDistributedLoadValue: " + String(LeftWheelDamageDistributedLoadValue), indentLevel: IndentLevelLabel.Level3))
                                }
                                if let RightWheelDamageDistributedLoadValue =  wheelDamageMeasureDataWheel.RightWheelDamageDistributedLoadValue {
                                    labelArr.append(getCellLabel(labelText: "RightWheelDamageDistributedLoadValue: " + String(RightWheelDamageDistributedLoadValue), indentLevel: IndentLevelLabel.Level3))
                                }
                                if let LeftWheelDamageQualityFactor =  wheelDamageMeasureDataWheel.LeftWheelDamageQualityFactor {
                                    labelArr.append(getCellLabel(labelText: "LeftWheelDamageQualityFactor: " + String(LeftWheelDamageQualityFactor), indentLevel: IndentLevelLabel.Level3))
                                }
                                if let RightWheelDamageQualityFactor =  wheelDamageMeasureDataWheel.RightWheelDamageQualityFactor {
                                    labelArr.append(getCellLabel(labelText: "RightWheelDamageQualityFactor: " + String(RightWheelDamageQualityFactor), indentLevel: IndentLevelLabel.Level3))
                                }
 */
                                
                            }
                        }
                        /*
                        <trv:LeftWheelDamageDistributedLoadValue>8.7</trv:LeftWheelDamageDistributedLoadValue>
                        
                        <trv:LeftWheelDamageMeanValue>85</trv:LeftWheelDamageMeanValue>
                        
                        <trv:LeftWheelDamagePeakValue>124</trv:LeftWheelDamagePeakValue>
                        
                        <trv:LeftWheelDamageQualityFactor>0.31</trv:LeftWheelDamageQualityFactor>
                        */
                        
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
 
}
