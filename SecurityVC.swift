//
//  SecurityVC.swift
//  Reindeer
//
//  Created by shiliuhua on 16/12/29.
//  Copyright © 2016年 shiliuhua. All rights reserved.
//

import UIKit
import SVProgressHUD

class SecurityVC: UIViewController {

    @IBOutlet var securityTextField1: UITextField!
    
    @IBOutlet var securityTextField2: UITextField!

    var phoneNumStr = "13484582565"
    
    @IBOutlet var bgImageView: UIImageView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        createAnimationForBGImageView()
        
    }
    //背景做动画
    func createAnimationForBGImageView() -> Void {
        let scaleAnimation = CABasicAnimation.init(keyPath: "transform.scale")
        scaleAnimation.fromValue = NSNumber(value: 1)
        scaleAnimation.toValue = NSNumber(value: 2)
        scaleAnimation.duration = 10
        scaleAnimation.repeatCount = MAXFLOAT
        bgImageView.layer.add(scaleAnimation, forKey: nil)
    }

    @IBAction func finishBtnClick(_ sender: UIButton) {
        
        if securityTextField1.text == nil || securityTextField1.text == ""{
            SVProgressHUD.showInfo(withStatus: "密码不能为空")
            return
        }else if securityTextField1.text != securityTextField2.text{
            SVProgressHUD.showInfo(withStatus: "两次密码不同")
            return
        }
        registerWithPhoneNumAndSecurityNum(dic: ["phone":phoneNumStr,"password":securityTextField1.text!], actionHandler: { (jsonStr) in
            print("registerJsonStr=\(jsonStr)")
            if jsonStr["code"] == 0 {
                let token = jsonStr["token"].stringValue
                SetUser(value: token, key: "token")
                
                SVProgressHUD.showSuccess(withStatus: "注册成功")
            }else{
                
                SVProgressHUD.showInfo(withStatus: "注册失败")
            }
            
        }, fail: {
            
        })
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
