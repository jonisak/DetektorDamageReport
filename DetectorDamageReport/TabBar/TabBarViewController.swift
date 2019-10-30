//
//  TabBarViewController.swift
//  DetectorDamageReport
//
//  Created by Jonas Isaksson on 2019-07-19.
//  Copyright © 2019 Jonas Isaksson. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController, UITabBarControllerDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Assign self for delegate for that ViewController can respond to UITabBarControllerDelegate methods
        self.delegate = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create Tab one
        let start = StartViewController()
        
        let img_train_icon = UIImage(named: "train_icon")?.resize(withSize: CGSize.init(width: 30.0, height: 30.0))
        let img_settings_icon = UIImage(named: "settings_icon")?.resize(withSize: CGSize.init(width: 30.0, height: 30.0))
        let img_transaction_list_icon = UIImage(named: "transaction_list")?.resize(withSize: CGSize.init(width: 30.0, height: 30.0))

        
        
        let tabTrainBarItem = UITabBarItem(title: "Tåg", image: img_train_icon, selectedImage: nil)

        let navTrain = UINavigationController(rootViewController: start)
        navTrain.tabBarItem = tabTrainBarItem
    
        
        let navSettings = UINavigationController(rootViewController: SettingsViewController())
        let tabTwo = navSettings
        let tabSettingsBarItem = UITabBarItem(title: "Inställningar", image: img_settings_icon, selectedImage: nil)
        tabTwo.tabBarItem = tabSettingsBarItem

        
        
        
        let navAlarmList = UINavigationController(rootViewController: ListAlarmsViewController())
        let tabThree = navAlarmList
        let tabAlarmListBarItem = UITabBarItem(title: "Larm", image: img_transaction_list_icon, selectedImage: nil)
        tabThree.tabBarItem = tabAlarmListBarItem

        
        
        
        
        self.viewControllers = [navTrain, tabThree, navSettings]
    }
    
    // UITabBarControllerDelegate method
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        //print("Selected \(viewController.title!)")
    }

}
