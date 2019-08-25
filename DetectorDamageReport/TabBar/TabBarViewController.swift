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
        
        
        let tabTrainBarItem = UITabBarItem(title: "Tåg", image: UIImage(named: "train_icon"), selectedImage: nil)

        let nav = UINavigationController(rootViewController: start)
        nav.tabBarItem = tabTrainBarItem
    
        let tabTwo = SettingsViewController()
        let tabSettingsBarItem = UITabBarItem(title: "Inställningar", image: UIImage(named: "settings_icon"), selectedImage: nil)

        tabTwo.tabBarItem = tabSettingsBarItem

        
        //start.tabBarItem = tabOneBarItem
        
        /*
        // Create Tab two
        let tabTwo = TabTwoViewController()
        let tabTwoBarItem2 = UITabBarItem(title: "Tab 2", image: UIImage(named: "defaultImage2.png"), selectedImage: UIImage(named: "selectedImage2.png"))
        
        tabTwo.tabBarItem = tabTwoBarItem2
        */
        
        self.viewControllers = [nav, tabTwo]
    }
    
    // UITabBarControllerDelegate method
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        //print("Selected \(viewController.title!)")
    }

}
