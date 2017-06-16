//
//  AppDelegate.swift
//  Reindeer
//
//  Created by shiliuhua on 16/12/21.
//  Copyright © 2016年 shiliuhua. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import SVProgressHUD
import NIMSDK

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var _mapManager:BMKMapManager?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        
        //注册百度地图
        _mapManager = BMKMapManager()
        let ret:Bool = (_mapManager?.start("jlHoVGhl344MIRM5QHHi6C0Lfr2YODYt", generalDelegate: nil))!
        if ret == false {
            print("manager start failed!")
        }else{
            print("启动百度地图成功")
        }
        
        //初始化网易云sdk
        NIMSDK.shared().register(withAppID: "45c6af3c98409b18a84451215d0bdd6e", cerName: "ENTERPRISE")
        
        
        
        //IQKeyboardManager 开关
        IQKeyboardManager.sharedManager().enable = true
        
        //SVProgressHUD
        SVProgressHUD.setDefaultStyle(.dark)
        SVProgressHUD.setDefaultMaskType(.clear)
        SVProgressHUD.setDefaultAnimationType(.native)
        SVProgressHUD.setMinimumDismissTimeInterval(2)
        
        let vc = UIStoryboard(name: "LoginAndUserStoryboard", bundle: nil).instantiateInitialViewController()
        let nav = UINavigationController(rootViewController: vc!)
        //    nav.isNavigationBarHidden = true
        self.window?.rootViewController = nav
        
        
        return true
    }
    
//    func onReceive(_ callID: UInt64, from caller: String, type: NIMNetCallMediaType, message extendMessage: String?) {
//        print("收到呼叫")
//    }

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

