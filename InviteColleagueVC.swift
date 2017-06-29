//
//  InviteColleagueVC.swift
//  Reindeer
//
//  Created by shiliuhua on 2017/6/28.
//  Copyright © 2017年 shiliuhua. All rights reserved.
//

import UIKit
import SVProgressHUD
class InviteColleagueVC: BaseViewVC {

    
    @IBOutlet var phoneNumTextField: UITextField!
    
    @IBOutlet var verCodeTextField: UITextField!
    
    @IBOutlet var getVerCodeBtn: UIButton!
    
    @IBOutlet var commitBtn: UIButton!
    
    var countdownTimer: Timer?
   // var remainingSeconds = 0
    
    
    var isCounting = false {
        willSet{
            if newValue {
                countdownTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTime(_:)), userInfo: nil, repeats: true)
                remainingSeconds = 60
                getVerCodeBtn.backgroundColor = UIColor.gray
            }else{
                countdownTimer?.invalidate()
                countdownTimer = nil
                getVerCodeBtn.backgroundColor = UIColor.init(red: 229/255.0, green: 220/255.0, blue: 213/255.0, alpha: 1)
                
            }
            getVerCodeBtn.isEnabled = !newValue
        }
    }
    
    var remainingSeconds:Int = 0 {
        willSet{
            getVerCodeBtn.setTitle("\(newValue)秒后重新获取", for: .normal)
            if newValue <= 0{
                getVerCodeBtn.setTitle("获取验证码", for: .normal)
                isCounting = false
            }
        }
       
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    // Do any additional setup after loading the view.
    }
    func updateTime(_ time:Timer) -> Void {
        remainingSeconds -= 1
    }
    
    @IBAction func commitBtnClick(_ sender: UIButton) {
        let dic:NSDictionary = [
            "token":GetUser(key: TOKEN),
            "phone":phoneNumTextField.text!,
            "code":verCodeTextField.text ?? ""
        ]
        print("dic = \(dic)")
        inviteFriendInterface(dic: dic, actionHander: { (jsonStr) in
            if jsonStr["code"] == 0 {
                SVProgressHUD.showSuccess(withStatus: "邀请成功")
                _ = self.navigationController?.popViewController(animated: true)
            }else{
                SVProgressHUD.showInfo(withStatus: jsonStr["msg"].stringValue)
            }
        }) { 
            
        }
        
        
    }
    @IBAction func verCodeBtnClick(_ sender: UIButton) {
        if phoneNumTextField.text == "" {
            SVProgressHUD.showInfo(withStatus: "请填写手机号")
            return
        }
        
        //启动倒计时
        isCounting = true
        getVerCode()
        
        
    }
    func getVerCode() -> Void {
        getVerificationCodeLogin(dic: ["phone":phoneNumTextField.text!], actionHandler: { (jsonStr) in
            if jsonStr["code"] == 0 {
                SVProgressHUD.showSuccess(withStatus: "获取成功")
                
                
            }else {
                SVProgressHUD.showInfo(withStatus: jsonStr["msg"].stringValue)
            }
            
        }) { 
            SVProgressHUD.showInfo(withStatus: "获取失败")
        }
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
