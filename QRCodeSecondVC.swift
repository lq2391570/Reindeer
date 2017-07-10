//
//  QRCodeSecondVC.swift
//  Reindeer
//
//  Created by shiliuhua on 2017/7/1.
//  Copyright © 2017年 shiliuhua. All rights reserved.
//

import UIKit
import SVProgressHUD
class QRCodeSecondVC: BaseViewVC {

    
    @IBOutlet var sureBtn: UIButton!
    
    @IBOutlet var cancelBtn: UIButton!
    //扫出的二维码串码
    var scanCode = ""
    
    var cancelBtnClickClosure:(() ->())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        installBtn()
        
    }
    //设置btn
    func installBtn() -> Void {
        sureBtn.layer.cornerRadius = 5
        sureBtn.layer.borderColor = UIColor.green.cgColor
        sureBtn.setTitleColor(UIColor.green, for: .normal)
        sureBtn.layer.borderWidth = 1
        
        cancelBtn.layer.cornerRadius = 5
        cancelBtn.layer.borderColor = UIColor.red.cgColor
        cancelBtn.setTitleColor(UIColor.red, for: .normal)
        cancelBtn.layer.borderWidth = 1
        
    }
    
    
    @IBAction func cancelBtnClick(_ sender: UIButton) {
        cancelBtnClickClosure!()
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func sureBtnClick(_ sender: UIButton) {
         //扫码第二步
        scanCodeSecond(dic: ["token":GetUser(key: TOKEN),"code":scanCode], actionHander: { (jsonStr) in
            if jsonStr["code"] == 0 {
                SVProgressHUD.showSuccess(withStatus: "扫码登录成功")
                self.cancelBtnClickClosure!()
                 self.dismiss(animated: true, completion: nil)
                
            }else{
                SVProgressHUD.showInfo(withStatus: jsonStr["msg"].stringValue)
            }
            
        }) { 
            
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
