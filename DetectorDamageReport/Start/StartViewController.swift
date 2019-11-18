//
//  StartViewController.swift
//  DetectorDamageReport
//
//  Created by Jonas Isaksson on 2019-07-16.
//  Copyright © 2019 Jonas Isaksson. All rights reserved.
//

import UIKit
import Alamofire
import SwiftKeychainWrapper
import FTLinearActivityIndicator

class StartViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, reloadStartViewDelegate {

    
    var currentPage = 1;
    var totalPages = 0;
    var pageSize = 10;
    var trainListDTO = [TrainListDTO]();
    var isLoading:Bool = false;
    let kLoadingCellTag2 = 1273;

    var tblView: UITableView = {
        let t = UITableView()
        t.translatesAutoresizingMaskIntoConstraints = false;
        return t;
    }()
    var standAloneIndicator: FTLinearActivityIndicator =
    {
        let t = FTLinearActivityIndicator()
        t.translatesAutoresizingMaskIntoConstraints = false;
        return t;
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.view.addSubview(tblView)
        tblView.addSubview(standAloneIndicator)
        //self.view.addSubview(standAloneIndicator)

        let filterBtn = UIBarButtonItem(title: "Filter", style: .plain, target: self, action: #selector(self.openFilterViewController))
        filterBtn.tintColor = UIColor.white
        self.navigationItem.rightBarButtonItem = filterBtn
        
        let mapButton = UIButton()
        mapButton.setTitle("Karta", for: .normal)
        mapButton.sizeToFit()
        let mapBarButton = UIBarButtonItem(customView: mapButton)
        navigationItem.leftBarButtonItem = mapBarButton
        mapButton.addTarget(self, action: #selector(self.openDetectorMapViewController), for: .touchUpInside)

        
        
        standAloneIndicator.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0).isActive = true
        standAloneIndicator.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: 0).isActive = true
        standAloneIndicator.heightAnchor.constraint(equalToConstant: 10).isActive = true;
        standAloneIndicator.widthAnchor.constraint(equalToConstant: 80).isActive = true;
        
        self.navigationItem.title = "Passager"
        tblView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        tblView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        tblView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        tblView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        tblView.register(TrainTableViewCell.self, forCellReuseIdentifier: "CELL")
        tblView.delegate = self
        tblView.dataSource = self
        tblView.rowHeight = UITableView.automaticDimension
        tblView.estimatedRowHeight = UITableView.automaticDimension
        
        tblView.separatorStyle = .none;
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
        tblView.addSubview(refreshControl)
        self.fetchData()
        self.fetchDetectorData()
        
    }
 
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    
    @objc func openFilterViewController(){
        let filterTrainViewController = FilterTrainViewController()
        filterTrainViewController.delegate = self;
        let nav = UINavigationController(rootViewController: filterTrainViewController)
        self.present(nav, animated: true, completion: nil)
    }
    @objc func openDetectorMapViewController(){
        let detectorMapViewController = DetectorMapViewController()
        detectorMapViewController.delegate = self;
        let nav = UINavigationController(rootViewController: detectorMapViewController)
        self.present(nav, animated: true, completion: nil)
    }
    
    
    func reload() {
        currentPage = 1;
        pageSize = 50;
        self.trainListDTO.removeAll()
        self.tblView.reloadData();
        fetchData();
    }
    
    @objc func refresh(_ refreshControl: UIRefreshControl) {
        reload();
        refreshControl.endRefreshing()

    }
    

    
    
    func fetchData(){
        if self.isLoading {
            return;
        }
        DispatchQueue.main.async {
            self.standAloneIndicator.startAnimating()
        }

        
        (UIApplication.shared.delegate as! AppDelegate).trainFilterDTO.MaxResultCount = 10000
        (UIApplication.shared.delegate as! AppDelegate).trainFilterDTO.Page = currentPage
        (UIApplication.shared.delegate as! AppDelegate).trainFilterDTO.PageSize = pageSize
        
        var dict = [String: Any]()
        //var jsonSring = ""
        do {
            dict = try (UIApplication.shared.delegate as! AppDelegate).trainFilterDTO.asDictionary()
        }catch {
            print("Unexpected error: \(error).")
            return
        }
        
    
        var headers: HTTPHeaders!
        if KeychainWrapper.standard.string(forKey: "detectordamagereport_email") != nil && KeychainWrapper.standard.string(forKey: "detectordamagereport_password") != nil
        {
            headers = [.authorization(username: KeychainWrapper.standard.string(forKey: "detectordamagereport_email")!, password: KeychainWrapper.standard.string(forKey: "detectordamagereport_password")!)]
        }else
        {
            let settingsViewcontroller = SettingsViewController();
            settingsViewcontroller.delegate = self
            let nav = UINavigationController(rootViewController: settingsViewcontroller)
            self.present(nav, animated: true, completion: nil)

            return;
        }
        
        AF.request((UIApplication.shared.delegate as! AppDelegate).WebapiURL +  "Train", method: HTTPMethod.post, parameters: dict, encoding: JSONEncoding.default, headers: headers, interceptor: nil).responseJSON { (response) in
            print("Request: \(String(describing: response.request))")   // original url request
            print("Response: \(String(describing: response.response))") // http url response
            print("Result: \(response.result)")                         // response serialization result
            self.isLoading = false;
            DispatchQueue.main.async {
                self.standAloneIndicator.stopAnimating()
                self.tblView.setEmptyMessage("")

            }

            if let err = response.error
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
                    let tr = try decoder.decode([TrainListDTO].self, from: d)
                    self.trainListDTO.append(contentsOf: tr)
                    if(self.trainListDTO.count>0 && self.currentPage==1)
                    {
                        self.totalPages =  (self.trainListDTO[0].TotalCount! + self.pageSize - 1) / self.pageSize;
                    }
                    DispatchQueue.main.async {
                            self.tblView.reloadData()
                    }
                    
                    if self.trainListDTO.count == 0
                    {
                        DispatchQueue.main.async {
                            self.tblView.setEmptyMessage("Hittade inga tåg")
                        }
                    }
                    
                } catch {
                    let errorAlertMessage = UIAlertController(title: "Ett oväntat fel uppstod", message: error.localizedDescription, preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
                    errorAlertMessage.addAction(okAction);
                    
                    self.present(errorAlertMessage, animated: true, completion: nil)
                    
                }
                
            }
        }
        
    }
    func fetchDetectorData(){
         var headers: HTTPHeaders!
         if KeychainWrapper.standard.string(forKey: "detectordamagereport_email") != nil && KeychainWrapper.standard.string(forKey: "detectordamagereport_password") != nil
         {
             headers = [.authorization(username: KeychainWrapper.standard.string(forKey: "detectordamagereport_email")!, password: KeychainWrapper.standard.string(forKey: "detectordamagereport_password")!)]
         }
         
        AF.request((UIApplication.shared.delegate as! AppDelegate).WebapiURL +  "Detector", method: HTTPMethod.get, parameters: nil, encoding: JSONEncoding.default, headers: headers, interceptor: nil).responseJSON { (response) in
             print("Request: \(String(describing: response.request))")   // original url request
             print("Response: \(String(describing: response.response))") // http url response
             print("Result: \(response.result)")                         // response serialization result

            DispatchQueue.main.async {
                self.tblView.setEmptyMessage("")
            }

             if let err = response.error
             {
                print(err);
                return;
             }
            
             
             if let d = response.data{
                 do {
                    let decoder = JSONDecoder() //or any other Decoder
                    decoder.dateDecodingStrategy = .iso8601
                    (UIApplication.shared.delegate as! AppDelegate).detectornDTOList.removeAll()
                    let detectors = try decoder.decode([DetectorDTO].self, from: d)
                    (UIApplication.shared.delegate as! AppDelegate).detectornDTOList.append(contentsOf: detectors);
                    
                 } catch {
                    print(error)
                    
                    let errorAlertMessage = UIAlertController(title: "Ett oväntat fel uppstod", message: error.localizedDescription, preferredStyle: .alert)
                     let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
                     errorAlertMessage.addAction(okAction);
                     
                     self.present(errorAlertMessage, animated: true, completion: nil)
                     
                 }
                 
             }
         }
         
     }
    
    
    func realoadData()
    {
        trainListDTO.removeAll();
        currentPage=1;
        pageSize=10;
        self.fetchData()
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(self.trainListDTO.count==0)
        {
            self.tblView.setEmptyMessage("")

            return 0;
        }
        
        if(self.currentPage==0)
        {
            return 1;
        }
        
        if (self.currentPage<self.totalPages) {
            return self.trainListDTO.count+1;
        }
        return self.trainListDTO.count
    }
    
    /*
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return self.trainDTOList.count
    }
    */
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if ((indexPath as NSIndexPath).row < self.trainListDTO.count) {
            return self.beerCellForIndexPath(indexPath);
        }else{
            return self.loadingCell();
        }
    }
    
    func loadingCell()->UITableViewCell
    {
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier:nil)
        cell.contentView.backgroundColor = UIColor(red: 228.0/255, green: 212.0/255, blue: 203.0/255, alpha: 0.8)
        let activityIndicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.gray)
        activityIndicator.center = cell.center
        cell.addSubview(activityIndicator);
        activityIndicator.startAnimating()
        cell.tag = kLoadingCellTag2;
        return cell;
    }
    
    
    
    func beerCellForIndexPath(_ indexPath: IndexPath)  -> UITableViewCell
    {
        var cell : TrainTableViewCell! = self.tblView.dequeueReusableCell(withIdentifier: "CELL") as?TrainTableViewCell
        
        if (cell == nil) {
            cell = TrainTableViewCell.init(style: UITableViewCell.CellStyle.default,
                                           reuseIdentifier:"CELL");
        }
        
        
        
        
        
        
        cell.layoutViews(trainListDTO: self.trainListDTO[indexPath.row])
        
        
        if let isoDatum = self.trainListDTO[indexPath.row].MessageSent.iso8601
        {
            cell.sentLabel.text = "Datum: " + DateFormatter.localizedString(from: isoDatum, dateStyle: .short, timeStyle: .medium)
        }else
        {
            cell.sentLabel.text = "Datum: " + self.trainListDTO[indexPath.row].MessageSent
        }
        
        
        if let detector = self.trainListDTO[indexPath.row].Detector
        {
            cell.detectorLabel.text = "Detektor: " + /*String.random(length: 8)*/  detector.Name

        }else
        {
            cell.detectorLabel.text = "Detektor: " + /*String.random(length: 8)*/   self.trainListDTO[indexPath.row].SGLN
        }
        
        
        cell.trainOperatorLabel.text = self.trainListDTO[indexPath.row].TrainOperator
        cell.trainNumberLabel.text = "Tågnummer: " /*+ String.random(length: 4) */ + self.trainListDTO[indexPath.row].TrainNumber
        cell.trainDirectionLabel.text = self.trainListDTO[indexPath.row].TrainDirection + " riktning"
        cell.vehicleCountLabel.text = String(self.trainListDTO[indexPath.row].VehicleCount) + " st fordon"
        cell.accessoryType = .disclosureIndicator
        
        
        if self.trainListDTO[indexPath.row].isHotBoxHotWheel
        {
            cell.messageTypeLabel.text = "Varmgång/Tjuvbroms"
        }
        if self.trainListDTO[indexPath.row].isWheelDamage
        {
            cell.messageTypeLabel.text = "Hjulskada"
        }
        
        
        if(indexPath.row == self.trainListDTO.count-1)
        {
            if self.currentPage <= self.totalPages
            {
                self.currentPage = self.currentPage + 1;
                self.fetchData()
            }
        }
        
        if self.trainListDTO[indexPath.row].TrainHasAlarmItem
        {
            cell.warningImageView.isHidden = false
        }else
        {
            cell.warningImageView.isHidden = true
        }
        
        let bottomLineView = UIView(frame: CGRect(x: 0, y: cell.bounds.size.height-1, width: self.view.bounds.size.width, height: 1))
        bottomLineView.translatesAutoresizingMaskIntoConstraints = false
        bottomLineView.backgroundColor = UIColor.gray
        cell.addSubview(bottomLineView)
    
        bottomLineView.translatesAutoresizingMaskIntoConstraints = false;
        bottomLineView.backgroundColor = UIColor.gray
        bottomLineView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        bottomLineView.widthAnchor.constraint(equalTo: cell.widthAnchor).isActive = true
        bottomLineView.bottomAnchor.constraint(equalTo: cell.bottomAnchor, constant: 0).isActive = true;
        return cell;
    }
        
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if (cell.tag == kLoadingCellTag2) {
            self.currentPage += 1;
            self.fetchData()
            cell.tag = 99
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 250
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let ve = VehicleViewController();
        //ve.trainDTOList = self.trainListDTO;
        
        ve.trainListDTO = self.trainListDTO[indexPath.row];
        self.navigationController?.pushViewController(ve, animated: true);
    }
    
    

}


