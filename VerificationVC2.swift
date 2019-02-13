//
//  VerificationVC2.swift
//  Reindeer
//
//  Created by shiliuhua on 2017/9/1.
//  Copyright © 2017年 shiliuhua. All rights reserved.
//

import UIKit
import SVProgressHUD
class VerificationVC2: UIViewController,UITextFieldDelegate {

    
    @IBOutlet var numTextField1: UITextField!
    
    @IBOutlet var numTextField2: UITextField!
    
    @IBOutlet var numTextField3: UITextField!
    
    @IBOutlet var numTextField4: UITextField!
    @IBOutlet var bgImageView: UIImageView!
    
    var phoneNumStr = ""
    
    @IBOutlet var reSandBtn: TimeCountDownBtn!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        numTextField1.tag = 1
        numTextField1.delegate = self
        numTextField1.layer.borderWidth = 1
        numTextField1.layer.borderColor = UIColor.mainColor.cgColor
        numTextField1.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        numTextField2.tag = 2
        numTextField2.delegate = self
        numTextField2.layer.borderWidth = 1
        numTextField2.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        numTextField2.layer.borderColor = UIColor.mainColor.cgColor
        numTextField3.tag = 3
        numTextField3.delegate = self
        numTextField3.layer.borderWidth = 1
        numTextField3.layer.borderColor = UIColor.mainColor.cgColor
        numTextField3.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        numTextField4.tag = 4
        numTextField4.delegate = self
        numTextField4.layer.borderWidth = 1
        numTextField4.layer.borderColor = UIColor.mainColor.cgColor
        numTextField4.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        numTextField1.becomeFirstResponder()
        createAnimationForBGImageView()
        
    reSandBtn.isCounting = true
        // Do any additional setup after loading the view.
    }
    func textFieldDidChange(_ textField:UITextField) -> Void {
        if textField.tag == 1 {
            if textField.text?.length == 1 {
                numTextField2.becomeFirstResponder()
            }
        }else if textField.tag == 2{
            if textField.text?.length == 1 {
                numTextField3.becomeFirstResponder()
            }
        }else if textField.tag == 3 {
            if textField.text?.length == 1 {
                numTextField4.becomeFirstResponder()
            }
        }else if textField.tag == 4 {
            if textField.text?.length == 1 {
                numTextField4.resignFirstResponder()
            }
        }
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        if (string == "\n") {
            textField.resignFirstResponder()
            return false;
        } else if (string.length == 0) {
            return true;
        } else if textField.text?.length == 1 {
            return false
        }
        return true
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

    @IBAction func reSandBtnClick(_ sender: TimeCountDownBtn) {
        sender.isCounting = true
        
        getVerificationCode(dic: ["phone":phoneNumStr], actionHandler: { (jsonStr) in
            print("jsonStr=\(jsonStr)")
            if jsonStr["code"] == 0 {
                SVProgressHUD.showSuccess(withStatus: "成功")
                
            }else{
                SVProgressHUD.showInfo(withStatus: jsonStr["msg"].string)
            }
        }, fail: {
            SVProgressHUD.showError(withStatus: "请求失败")
        })

        
        
    }
    
    
    @IBAction func returnBtnClick(_ sender: UIButton) {
        print("返回")
        
        _  = self.navigationController?.popViewController(animated: true)
        
    }
    
    @IBAction func nextBtnClick(_ sender: UIButton) {
        
//        if verificationTextField.text == nil || verificationTextField.text == "" {
//            SVProgressHUD.showInfo(withStatus: "验证码不能为空")
//            return
//        }
        SVProgressHUD.show()
        if numTextField1.text == "" || numTextField1.text == nil {
            SVProgressHUD.showInfo(withStatus: "验证码不完整")
            return
        }
        if numTextField2.text == "" || numTextField2.text == nil {
            SVProgressHUD.showInfo(withStatus: "验证码不完整")
            return
        }
        if numTextField3.text == "" || numTextField3.text == nil {
            SVProgressHUD.showInfo(withStatus: "验证码不完整")
            return
        }
        if numTextField4.text == "" || numTextField4.text == nil {
            SVProgressHUD.showInfo(withStatus: "验证码不完整")
            return
        }
        
        let verCodeStr = "\(numTextField1.text!)\(numTextField2.text!)\(numTextField3.text!)\(numTextField4.text!)"
        print("verCode = \(verCodeStr)")
        
        verifyPhonenum(dic: ["phone":phoneNumStr,"code":verCodeStr], actionHandler: { (jsonStr) in
            print("jsonStr=\(jsonStr)")
            if jsonStr["code"] == 0 {
                SVProgressHUD.showSuccess(withStatus: jsonStr["msg"].string)
                let vc = UIStoryboard(name: "LoginAndUserStoryboard", bundle: nil).instantiateViewController(withIdentifier: "SecurityVC") as? SecurityVC
                vc?.phoneNumStr = self.phoneNumStr
                
                self.navigationController?.pushViewController(vc!, animated: true)
                
            }else{
                SVProgressHUD.showError(withStatus: jsonStr["msg"].string)
            }
            
        }, fail: {
            SVProgressHUD.showError(withStatus: "请求失败")
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
