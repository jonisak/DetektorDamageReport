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
        let tabOneBarItem = UITabBarItem(title: "Start", image: nil, selectedImage: nil)
        
        let nav = UINavigationController(rootViewController: start)
        nav.tabBarItem = tabOneBarItem
        //start.tabBarItem = tabOneBarItem
        
        /*
        // Create Tab two
        let tabTwo = TabTwoViewController()
        let tabTwoBarItem2 = UITabBarItem(title: "Tab 2", image: UIImage(named: "defaultImage2.png"), selectedImage: UIImage(named: "selectedImage2.png"))
        
        tabTwo.tabBarItem = tabTwoBarItem2
        */
        
        self.viewControllers = [nav]
    }
    
    // UITabBarControllerDelegate method
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        print("Selected \(viewController.title!)")
    }

}
