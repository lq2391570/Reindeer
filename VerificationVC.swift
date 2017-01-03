//
//  VerificationVC.swift
//  Reindeer
//
//  Created by shiliuhua on 16/12/26.
//  Copyright © 2016年 shiliuhua. All rights reserved.
//

import UIKit

import SVProgressHUD

class VerificationVC: UIViewController {

    @IBOutlet var promptLabel: UILabel!
    
    @IBOutlet var verificationTextField: UITextField!
    
    @IBOutlet var countdownTextField: UITextField!
    
    var phoneNumStr = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        promptLabel.text="我们已为您的手机号码+86-\(phoneNumStr)发送了一条验证短信"
        //创建属性字典
        
        verificationTextField.attributedPlaceholder = NSAttributedString(string: " 请输入短信验证码", attributes: [NSFontAttributeName:UIFont.systemFont(ofSize: 15)])
        
        
    }

    @IBAction func nextBtnClick(_ sender: UIButton) {
        if verificationTextField.text == nil || verificationTextField.text == "" {
        SVProgressHUD.showInfo(withStatus: "验证码不能为空")
            return
        }
        
        verifyPhonenum(dic: ["phone":phoneNumStr,"code":verificationTextField.text!], actionHandler: { (jsonStr) in
            print("jsonStr=\(jsonStr)")
            if jsonStr["code"] == 0 {
                SVProgressHUD.showSuccess(withStatus: "成功")
                let vc = UIStoryboard(name: "LoginAndUserStoryboard", bundle: nil).instantiateViewController(withIdentifier: "SecurityVC") as? SecurityVC
                
                self.navigationController?.pushViewController(vc!, animated: true)
                
            }else{
                SVProgressHUD.showError(withStatus: "请求失败")
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
