//
//  PhoneNumVC.swift
//  Reindeer
//
//  Created by shiliuhua on 17/2/13.
//  Copyright © 2017年 shiliuhua. All rights reserved.
//

//输入信息页面

import UIKit
import JVFloatLabeledTextField
import SVProgressHUD
class PhoneNumVC: BaseViewVC {

    
    @IBOutlet var phoneTextField: JVFloatLabeledTextField!
    
    var doneClosure:((String) -> ())?
    var placeholderStr:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+0.5, execute: {
            self.phoneTextField.becomeFirstResponder()
        })
        self.phoneTextField.placeholder = placeholderStr
        
        let rightBarBtnItem = UIBarButtonItem.init(title: "完成", style: .plain, target: self, action: #selector(completeBtnClick))
        self.navigationItem.rightBarButtonItem = rightBarBtnItem
        
        
    }
    //完成
    func completeBtnClick() -> Void {
        //完成按钮点击
        if (doneClosure != nil) {
            doneClosure!(self.phoneTextField.text!)
        }
        if self.phoneTextField.text == nil || self.phoneTextField.text == "" {
            SVProgressHUD.showInfo(withStatus: "请输入内容")
        }
        
        
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
