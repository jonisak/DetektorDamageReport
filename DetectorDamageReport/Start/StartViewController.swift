//
//  StartViewController.swift
//  DetectorDamageReport
//
//  Created by Jonas Isaksson on 2019-07-16.
//  Copyright © 2019 Jonas Isaksson. All rights reserved.
//

import UIKit
import Alamofire





class StartViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var trainDTOList = [TrainDTO]();
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
        tblView.register(TrainTableViewCell.self, forCellReuseIdentifier: "CELL")
        tblView.delegate = self
        tblView.dataSource = self
        tblView.rowHeight = UITableView.automaticDimension
        tblView.estimatedRowHeight = UITableView.automaticDimension

        /*
        AF.request("http://104.40.239.29/Detectordamagereport/api/Train/GetUserTrains", method: HTTPMethod.get, parameters: nil, encoding: JSONEncoding.default, headers: headers, interceptor: nil).responseDecodable { (response: DataResponse<[TrainDTO]>) in
           // print(response.value?.TrainId)
            print("Result: \(response.result)")
            // response serialization result

            if let trainDTO = response.value
            {
                print(trainDTO.count)
                
            }
            print(response.error)
            
        }
*/

        let headers: HTTPHeaders = [.authorization(username: "test", password: "1111")]
        AF.request((UIApplication.shared.delegate as! AppDelegate).WebapiURL +  "Train", method: HTTPMethod.get, parameters: nil, encoding: JSONEncoding.default, headers: headers, interceptor: nil).responseJSON { (response) in
            print("Request: \(String(describing: response.request))")   // original url request
            print("Response: \(String(describing: response.response))") // http url response
            print("Result: \(response.result)")                         // response serialization result
            
            
            if let d = response.data{
                do {
                    let decoder = JSONDecoder() //or any other Decoder
                    let t = try? decoder.decode([TrainDTO].self, from: d)
                    if let tr = t
                    {
                        self.trainDTOList = tr;
                        self.tblView.reloadData()
                    }
                } catch { print(error) }

            }
        }
    }
 
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return self.trainDTOList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell : TrainTableViewCell! = tableView.dequeueReusableCell(withIdentifier: "CELL") as?TrainTableViewCell
        
        if (cell == nil) {
            cell = TrainTableViewCell.init(style: UITableViewCell.CellStyle.default,
                                                  reuseIdentifier:"CELL");
        }
        
        cell.sentLabel.text = "Skickat: " + self.trainDTOList[indexPath.row].MessageSent
        cell.detectorLabel.text = "Detektor: " + self.trainDTOList[indexPath.row].Detector
        cell.trainOperatorLabel.text = self.trainDTOList[indexPath.row].TrainOperator
        cell.trainNumberLabel.text = "Tågnummer: " + self.trainDTOList[indexPath.row].TrainNumber
        cell.trainDirectionLabel.text = self.trainDTOList[indexPath.row].TrainDirection + " riktning"
        cell.vehicleCountLabel.text = String(self.trainDTOList[indexPath.row].VehicleCount) + " st fordon"
        cell.accessoryType = .disclosureIndicator
        
        return cell;
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 200
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let ve = VehicleViewController();
        ve.trainDTOList = self.trainDTOList;
        ve.selectedTraindIndex = indexPath.row
        self.navigationController?.pushViewController(ve, animated: true);
    }
    
    
 
 /*
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
 */
}
