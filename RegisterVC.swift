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
    
    @IBOutlet var bgImageView: UIImageView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
         createAnimationForBGImageView()
        // Do any additional setup after loading the view.
         phoneNumTextFileField.attributedPlaceholder = NSAttributedString(string: " 请输入手机号", attributes: [NSForegroundColorAttributeName:UIColor.white])
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

    @IBAction func nextBtnClick(_ sender: UIButton) {
        SVProgressHUD.show()
        if phoneNumTextFileField.text == nil || phoneNumTextFileField.text == "" {
            SVProgressHUD.showInfo(withStatus: "手机号不能为空")
            return
        }
        
        
        getVerificationCode(dic: ["phone":phoneNumTextFileField.text!], actionHandler: { (jsonStr) in
           print("jsonStr=\(jsonStr)")
            if jsonStr["code"] == 0 {
                SVProgressHUD.showSuccess(withStatus: "成功")
                
            let vc = UIStoryboard(name: "LoginAndUserStoryboard", bundle: nil).instantiateViewController(withIdentifier: "VerificationVC2") as? VerificationVC2
            vc?.phoneNumStr = self.phoneNumTextFileField.text!
                
            self.navigationController?.pushViewController(vc!, animated: true)
                
            }else{
                SVProgressHUD.showInfo(withStatus: jsonStr["msg"].string)
            }
        }, fail: {
             SVProgressHUD.showError(withStatus: "请求失败")
        })
        
    }
    
    @IBAction func returnBtnClick(_ sender: UIButton) {
       _ = self.navigationController?.popViewController(animated: true)
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
