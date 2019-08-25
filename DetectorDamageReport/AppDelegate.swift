//
//  AppDelegate.swift
//  DetectorDamageReport
//
//  Created by Jonas Isaksson on 2019-07-16.
//  Copyright © 2019 Jonas Isaksson. All rights reserved.
//

import UIKit
import Alamofire
import SwiftKeychainWrapper
@UIApplicationMain


class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    var WebapiURL = "http://104.46.44.217/Detectordamagereport/api/"
    var trainFilterDTO : TrainFilterDTO!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        var deviceTypeList = [DeviceTypeDTO]()
        deviceTypeList.append(DeviceTypeDTO(deviceType: "HOTBOXHOTWHEEL", deviceTypeDisplayName: "Varmgång/Tjuvbroms detektor", selected: true))
        deviceTypeList.append(DeviceTypeDTO(deviceType: "WHEELDAMAGE", deviceTypeDisplayName: "Hjulskadedetektor", selected: true))

        self.trainFilterDTO = TrainFilterDTO(maxResultCount: 1000, page: 1, pageSize: 20 ,showTrainWithAlarmOnly:true, deviceTypeDTOList: deviceTypeList)
        
        /*
        UINavigationBar.appearance().backgroundColor = UIColor.init(red: 204.0, green: 46.0, blue: 44.0, alpha: 1.0)
        UIBarButtonItem.appearance().tintColor = UIColor.black
        UINavigationBar.appearance().isTranslucent = false
//        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key(rawValue: UITextAttributeTextColor): UIColor.blue]
        UITabBar.appearance().backgroundColor = UIColor.yellow;
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor.orange]
*/
        
        UINavigationBar.appearance().backgroundColor = UIColor(red: 204.0/255.0, green: 46.0/255.0, blue: 44.0/255.0, alpha: 1.0)
        UINavigationBar.appearance().barTintColor = UIColor(red: 204.0/255.0, green: 46.0/255.0, blue: 44.0/255.0, alpha: 1.0)

        UIBarButtonItem.appearance().tintColor = UIColor.white
//        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor.orange]
        //UITabBar.appearance().backgroundColor = UIColor.yellow;
        
        let userDefaults = UserDefaults.standard
        if userDefaults.bool(forKey: "hasRunBefore") == false {
            // remove keychain items here
            _ = KeychainWrapper.standard.removeObject(forKey:"detectordamagereport_email")
            _ = KeychainWrapper.standard.removeObject(forKey: "detectordamagereport_password")
            userDefaults.set(true, forKey: "hasRunBefore")
            userDefaults.synchronize()
            return true;
        }
        


        //self.trainFilterDTO(
        //self.trainFilterDTO(trainFilterDTO)
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        //self.window?.rootViewController = StartViewController()
        self.window?.rootViewController = TabBarViewController()
        self.window?.makeKeyAndVisible()


        
        
        
        return true
    }

    
    
    
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}







