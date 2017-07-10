//
//  ChangeMiMaVC.swift
//  Reindeer
//
//  Created by shiliuhua on 2017/6/29.
//  Copyright © 2017年 shiliuhua. All rights reserved.
//

import UIKit
import SVProgressHUD
class ChangeMiMaVC: BaseViewVC {

    @IBOutlet var oldMimaTextField: UITextField!
    
    @IBOutlet var newMimaTextField: UITextField!
    
    @IBOutlet var newMimaTextField2: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func commitBtnClick(_ sender: UIButton) {
        if oldMimaTextField.text == "" {
            SVProgressHUD.showInfo(withStatus: "请输入旧密码")
            return
        }else if newMimaTextField.text == ""{
            SVProgressHUD.showInfo(withStatus: "请输入新密码")
            return
        }else if newMimaTextField.text != newMimaTextField2.text {
            SVProgressHUD.showInfo(withStatus: "新密码不一致")
            return
        }
        
        let dic:NSDictionary = [
            "token":GetUser(key: TOKEN),
            "oldPassword":oldMimaTextField.text!,
            "password":newMimaTextField.text!
        ]
        changeMimaInterface(dic: dic, actionHander: { (jsonStr) in
            if jsonStr["code"] == 0 {
                SVProgressHUD.showSuccess(withStatus: "修改成功")
                _ = self.navigationController?.popViewController(animated: true)
            }else{
                SVProgressHUD.showInfo(withStatus: jsonStr["msg"].stringValue)
            }
            
        }) { 
            SVProgressHUD.showInfo(withStatus: "请求失败")
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
