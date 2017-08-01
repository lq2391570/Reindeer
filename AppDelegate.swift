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
import UserNotifications




@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,WXApiDelegate,UNUserNotificationCenterDelegate {

    var window: UIWindow?
    var _mapManager:BMKMapManager?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.

        // iOS10 下需要使用新的 API （百度推送）
        if #available(iOS 10.0, *) {
            // modern code
            print("UIDevice.current.systemVersion = \(UIDevice.current.systemVersion)")
            let center:UNUserNotificationCenter = UNUserNotificationCenter.current()
            center.delegate = self
            center.requestAuthorization(options: [UNAuthorizationOptions.alert,UNAuthorizationOptions.badge,UNAuthorizationOptions.sound], completionHandler: { (granted, error) in
                print("granted = \(granted) ,error = \(error)")
                if granted == true {
                    print("注册成功")
                    application.registerForRemoteNotifications()
                    center.getNotificationSettings(completionHandler: { (settings) in
                        print("setting = \(settings)")
                    })
                }else{
                    print("注册失败")
                }
            })
            
        } else if #available(iOS 8.0, *){
            print("UIDevice.current.systemVersion = \(UIDevice.current.systemVersion)")
            let myTypes:UIUserNotificationType = [UIUserNotificationType.alert, UIUserNotificationType.sound,UIUserNotificationType.badge]
            
            let settings:UIUserNotificationSettings = UIUserNotificationSettings(types: myTypes, categories: nil)
            UIApplication.shared.registerUserNotificationSettings(settings)
            
        }else{
            print("UIDevice.current.systemVersion = \(UIDevice.current.systemVersion)")
            let myTypes:UIUserNotificationType = [UIUserNotificationType.alert, UIUserNotificationType.sound,UIUserNotificationType.badge]
            
            let settings:UIUserNotificationSettings = UIUserNotificationSettings(types: myTypes, categories: nil)
            UIApplication.shared.registerUserNotificationSettings(settings)
            
        }
        
        BPush.registerChannel(launchOptions, apiKey: "jlHoVGhl344MIRM5QHHi6C0Lfr2YODYt", pushMode: BPushMode.development, withFirstAction: "打开", withSecondAction: "关闭", withCategory: "test", useBehaviorTextInput: true, isDebug: true)
       
      //  let userInfo:NSDictionary = launchOptions[UIApplicationLaunchOptionsKey.remoteNotification]
        if launchOptions?[UIApplicationLaunchOptionsKey.remoteNotification] != nil {
            let userInfo = launchOptions?[UIApplicationLaunchOptionsKey.remoteNotification] as? NSDictionary
            if userInfo != nil {
                BPush.handleNotification(userInfo as! [NSObject : Any])
            }
        }
        
        
        
        
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
        NIMSDK.shared().register(withAppID: "5525f5715f8118ba266d4faadfa627d2", cerName: "ENTERPRISE")
    
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
    @available(iOS 10.0, *)
func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Swift.Void)
    {
    let userInfo = notification.request.content.userInfo
        let request = notification.request //收到推送的请求
        let content = request.content
        let badge = content.badge
        let body = content.body
        let sound = content.sound
        let subtitle = content.subtitle
        let title = content.title
        if (notification.request.trigger?.isKind(of: UNPushNotificationTrigger.classForCoder()))! {
            print("ios 10 前台收到远程通知 ")
            //功能：可设置是否在应用内弹出通知
            completionHandler(UNNotificationPresentationOptions.alert);
            
        }else{
            //判断为本地通知
            print("ios10 前台收到本地通知 badge=\(badge),body=\(body),sound=\(sound),subtitle=\(subtitle),title=\(title)")
            //功能：可设置是否在应用内弹出通知
            completionHandler(UNNotificationPresentationOptions.alert);
        }
        
        
        
    }
    func application(_ application: UIApplication, didRegister notificationSettings: UIUserNotificationSettings) {
        application.registerForRemoteNotifications()
    }
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        //app 收到推送的通知
        BPush.handleNotification(userInfo)
        //应用在前台或者后台开启状态下，不跳转页面，让用户选择
        if application.applicationState == .active {
            //前台
            print("应用在前台")
            let alertView = UIAlertView (title: "收到一条消息", message: "通知", delegate: nil , cancelButtonTitle: " 取消 ",otherButtonTitles:"确定")
            alertView.show ()
        }else if application.applicationState == .background {
            //后台
            print("应用在后台")
        }else if application.applicationState == .inactive {
            //应用被杀掉的状态
            print("应用被kill")
        }
    }
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        print("test:\(deviceToken)")
        //向云推送注册device token
        BPush.registerDeviceToken(deviceToken)
        // 绑定channel.将会在回调中看获得channnelid appid userid 等
        BPush.bindChannel { (result, error) in
            print("error?.localizedDescription = \(error?.localizedDescription)")
            let r: NSDictionary = result as! NSDictionary
//            let baiduUser = result["user_id"] as! String
//            let channelID = result["channel_id"] as! String
            
        }
       
    }
    //当DeviceToken获取失败时，系统会回调此方法
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("DeviceToken 获取失败，原因:\(error)")
        
    }
    // 此方法是 用户点击了通知，应用在前台 或者开启后台并且应用在后台 时调起

    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        //App 收到推送的通知
        BPush.handleNotification(userInfo)
        
    }
    // 注册通知 alert 、 sound 、 badge （ 8.0 之后，必须要添加下面这段代码，否则注册失败）
    func application(application: UIApplication , didRegisterUserNotificationSettings notificationSettings: UIUserNotificationSettings ) {
        application.registerForRemoteNotifications ()
    }

    func application(_ application: UIApplication, didReceive notification: UILocalNotification) {
        print("接收本地通知")
        BPush.showLocalNotification(atFront: notification, identifierKey: nil)
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

