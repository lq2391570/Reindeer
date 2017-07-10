//
//  ChangePhoneNumVC.swift
//  Reindeer
//
//  Created by shiliuhua on 2017/6/29.
//  Copyright © 2017年 shiliuhua. All rights reserved.
//

import UIKit
import SVProgressHUD
class ChangePhoneNumVC: BaseViewVC {

    @IBOutlet var beforePhoneNumTextField: UITextField!
    
    @IBOutlet var nowPhoneNumTextField: UITextField!
    
    @IBOutlet var verCodeTextField: UITextField!
    
    @IBOutlet var verCodebtn: UIButton!
    
     var countdownTimer: Timer?
    var isCounting = false {
        willSet{
            if newValue {
                countdownTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTime(_:)), userInfo: nil, repeats: true)
                remainingSeconds = 60
                verCodebtn.backgroundColor = UIColor.gray
            }else{
                countdownTimer?.invalidate()
                countdownTimer = nil
                verCodebtn.backgroundColor = UIColor.init(red: 229/255.0, green: 220/255.0, blue: 213/255.0, alpha: 1)
                
            }
            verCodebtn.isEnabled = !newValue
        }
    }
    
    var remainingSeconds:Int = 0 {
        willSet{
            verCodebtn.setTitle("\(newValue)秒后重新获取", for: .normal)
            if newValue <= 0{
                verCodebtn.setTitle("获取验证码", for: .normal)
                isCounting = false
            }
        }
        
    }
    @IBAction func verCodeBtnClick(_ sender: UIButton) {
        
        if nowPhoneNumTextField.text == "" {
            SVProgressHUD.showInfo(withStatus: "请填写新手机号")
        }
        
        //启动倒计时
        isCounting = true
        getVerCode()
    }
    func updateTime(_ time:Timer) -> Void {
        remainingSeconds -= 1
    }
    func getVerCode() -> Void {
        getVerificationCode(dic: ["phone":nowPhoneNumTextField.text!], actionHandler: { (jsonStr) in
            if jsonStr["code"] == 0 {
                SVProgressHUD.showSuccess(withStatus: "获取成功")
                
                
            }else {
                SVProgressHUD.showInfo(withStatus: jsonStr["msg"].stringValue)
            }
            
        }) {
            SVProgressHUD.showInfo(withStatus: "获取失败")
        }
    }

    @IBAction func commitBtnClick(_ sender: UIButton) {
        
        changePnonenumInterface(dic: ["token":GetUser(key: TOKEN),"oldPhone":beforePhoneNumTextField.text!,"phone":nowPhoneNumTextField.text!,"code":verCodeTextField.text!], actionHander: { (jsonStr) in
            if jsonStr["code"] == 0 {
                SVProgressHUD.showSuccess(withStatus: "修改成功")
            }else{
                SVProgressHUD.showInfo(withStatus: jsonStr["msg"].stringValue)
            }
        }) { 
            SVProgressHUD.showInfo(withStatus: "请求失败")
        }
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
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
