//
//  LoginVC.swift
//  Reindeer
//
//  Created by shiliuhua on 16/12/26.
//  Copyright © 2016年 shiliuhua. All rights reserved.
//

import UIKit
import SVProgressHUD
class LoginVC: UIViewController {

    
//    var token = "eyJhbGciOiJIUzUxMiIsInppcCI6IkdaSVAifQ.H4sIAAAAAAAAAKtWKi5NUrJSMlKqBQBuk7zJCwAAAA.RPGxEneRZjimYveUz7Gol_QN8dtRaQx_LotSBSUCxWUk7FadPiWQQSaoK-e66yyORad-D02F7LfwlIrY-f5bQg"
    
    @IBOutlet var phoneNumTextField: UITextField!
    
    @IBOutlet var passwordTextField: UITextField!
    
    
    @IBOutlet var bgphoneNumTextFieldView: UIView!
    
    @IBOutlet var bgpasswordTextFieldView: UIView!
    
   
    @IBOutlet var bgImageView: UIImageView!
    
    
    @IBAction func LoginBtnClick(_ sender: UIButton) {
        print("点击登陆")
        SVProgressHUD.show()
        loginWithPhoneNumAndSecurityNum(dic: ["phone":phoneNumTextField.text!,"password":passwordTextField.text!], actionHandler: { (jsonStr) in
            if jsonStr["code"] == 0 {
                SVProgressHUD.showSuccess(withStatus: "登陆成功")
                //登陆成功后存储token,用户名及密码
                SetUser(value: jsonStr["token"].string!, key: TOKEN)
                SetUser(value: self.phoneNumTextField.text!, key: PHONENUM)
                SetUser(value: self.passwordTextField.text!, key: PASSWORD)
                
                //判断group（找工作 1 或HR 2 或 未选择 -1）
                if jsonStr["group"] == -1{
                    //未选择
                    let vc = UIStoryboard(name: "LoginAndUserStoryboard", bundle: nil).instantiateViewController(withIdentifier: "ChoseGroupVC") as! ChoseGroupVC
                    self.navigationController?.pushViewController(vc, animated: true)
                }else if jsonStr["group"] == 1{
                    //找工作
                       //判断是否完善了信息若没完善则去完善，若完善了则进入首页
                    if jsonStr["hasIntent"] == 0 && jsonStr["perfectInfo"] == 0 {
                        //既完善了个人信息也发布了求职意向则跳转首页
                        let vc = UIStoryboard(name: "UserFirstStoryboard", bundle: nil).instantiateViewController(withIdentifier: "HomePageVC") as! HomePageVC
                        let nav = UINavigationController.init(rootViewController: vc)
                        self.view.window?.rootViewController = nav
                        
                    }else if jsonStr["perfectInfo"] == -1 {
                        //没有完善个人信息则去完善个人信息
                        let vc = UIStoryboard(name: "LoginAndUserStoryboard", bundle: nil).instantiateViewController(withIdentifier: "CompleteUserMesVC") as! CompleteUserMesVC
                        let nav = UINavigationController.init(rootViewController: vc)
                        self.view.window?.rootViewController = nav
                        
                    }else if jsonStr["perfectInfo"] == 0 && jsonStr["hasIntent"] == -1
                    {
                        //完善了个人信息但是没有发布求职意向则直接去发布求职意向
                        let vc = UIStoryboard(name: "UserCenter", bundle: nil).instantiateViewController(withIdentifier: "AddJobIntensionVC") as! AddJobIntensionVC
                        let nav = UINavigationController.init(rootViewController: vc)
                        self.view.window?.rootViewController = nav
                        
                    }
                
                }else if jsonStr["group"] == 2{
                    let vc = UIStoryboard(name: "UserFirstStoryboard", bundle: nil).instantiateViewController(withIdentifier: "HomePageVC") as! HomePageVC
                    let nav = UINavigationController.init(rootViewController: vc)
                    self.view.window?.rootViewController = nav
                }
            }else{
                SVProgressHUD.showInfo(withStatus: jsonStr["msg"].stringValue)
            }
            
        }, fail: {
            
        })
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
      //  self.navigationController?.isNavigationBarHidden = true
       
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        createAnimationForBGImageView()
        phoneNumTextField.text = GetUser(key: "phone")
        passwordTextField.text = GetUser(key: "password")
        self.navigationController?.isNavigationBarHidden = true
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
