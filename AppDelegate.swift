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
class AppDelegate: UIResponder, UIApplicationDelegate,WXApiDelegate {

    var window: UIWindow?
    var _mapManager:BMKMapManager?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        //注册微信
        WXApi.registerApp("wxc02c094325351685")
        
        
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
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        if url.host == "safepay" {
            //跳转支付宝钱包支付处理支付结果
            AlipaySDK.defaultService().processOrder(withPaymentResult: url, standbyCallback: { (resultDic) in
                print("result = \(resultDic!)")
                var memo = ""
                let resultStatus:Int = resultDic?["resultStatus"] as! Int
                if resultStatus == 9000 {
                    memo = "支付成功"
                    SVProgressHUD.showSuccess(withStatus: memo)
                }else{
                    switch resultStatus {
                    case 4000 :
                        memo = "失败原因:订单支付失败"
                        break
                    case 6001:
                        memo = "失败原因:用户中途取消"
                        break
                    case 6002:
                        memo = "失败原因:网络连接出错！"
                        break
                    case 8000:
                        memo = "正在处理中..."
                        break
                    default:
                        memo = resultDic?["memo"] as! String
                        break
                    }
                }
                
                SVProgressHUD.showInfo(withStatus: memo)
            })
            return true
        }else if url.host == "pay" {
            print("url.host = \(url.host)")
            return WXApi.handleOpen(url, delegate: self as WXApiDelegate)
        }
     return true
        
        
    }
    // MARK: - WXApiDelegate 支付结果
    func onResp(_ resp: BaseResp!) {
        if resp.isKind(of: PayResp.classForCoder()) {
            
            //支付返回结果，实际支付结果需要去微信服务器端查询
            let strMsg: String?, strTitle = "支付结果"
            switch resp.errCode {
            case 0:
                strMsg = "支付结果：成功！";
                print("支付成功－PaySuccess，retcode = \(resp.errCode)")
                //支付成功后发送一个通知
                let notiMesRecv = NSNotification.init(name: NSNotification.Name(rawValue: "wxPaySucceed"), object: nil)
                 NotificationCenter.default.post(notiMesRecv as Notification)
                
            default:
                strMsg = "支付结果：失败！retcode = \(resp.errCode), retstr = \(resp.errCode)"
                print("错误，retcode = \(resp.errCode), retstr = \(resp.errStr)")
            }
        }

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

