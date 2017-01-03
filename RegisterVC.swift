//
//  RegisterVC.swift
//  Reindeer
//
//  Created by shiliuhua on 16/12/26.
//  Copyright © 2016年 shiliuhua. All rights reserved.
//

import UIKit
import SVProgressHUD
class RegisterVC: UIViewController {

    
 
    @IBOutlet var phoneNumTextFileField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func nextBtnClick(_ sender: UIButton) {
        
        if phoneNumTextFileField.text == nil || phoneNumTextFileField.text == "" {
            SVProgressHUD.showInfo(withStatus: "手机号不能为空")
            return
        }
        getVerificationCode(dic: ["phone":phoneNumTextFileField.text!], actionHandler: { (jsonStr) in
           print("jsonStr=\(jsonStr)")
            if jsonStr["code"] == 0 {
                SVProgressHUD.showSuccess(withStatus: "成功")
                
            let vc = UIStoryboard(name: "LoginAndUserStoryboard", bundle: nil).instantiateViewController(withIdentifier: "VerificationVC") as? VerificationVC
            vc?.phoneNumStr = self.phoneNumTextFileField.text!
                
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
