//
//  GotoInviteVC.swift
//  Reindeer
//
//  Created by shiliuhua on 2017/8/21.
//  Copyright © 2017年 shiliuhua. All rights reserved.
//

import UIKit
import YYText
import SVProgressHUD
class GotoInviteVC: BaseViewVC,UITextFieldDelegate,YYTextViewDelegate {

    
    @IBOutlet var textField1: MyTextField!
    
    @IBOutlet var textField2: MyTextField!
    
    @IBOutlet var textView: YYTextView!
    
    var returnClosure:(() -> ())?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "我要邀请"
        textField1.placeholder = "请输入对方姓名"
        textField2.placeholder = "请输入对方手机号"
        textField1.delegate = self
        textField2.delegate = self
        
        
     let placeholder1 = NSMutableAttributedString.init(string: textField1.placeholder!)
        placeholder1.addAttribute(NSFontAttributeName, value: UIFont.systemFont(ofSize: 15), range: NSMakeRange(0, (textField1.placeholder?.length)!))
        textField1.attributedPlaceholder = placeholder1
        
        
     let placeholder2 = NSMutableAttributedString.init(string: textField2.placeholder!)
        placeholder2.addAttribute(NSFontAttributeName, value: UIFont.systemFont(ofSize: 15), range: NSMakeRange(0, (textField2.placeholder?.length)!))
        textField2.attributedPlaceholder = placeholder2
        textField2.keyboardType = .numberPad
        textView.placeholderFont = UIFont.systemFont(ofSize: 15)
        textView.textContainerInset = UIEdgeInsetsMake(10, 20, 0, 0)
        textView.font = UIFont.systemFont(ofSize: 15)
        // Do any additional setup after loading the view.
        
        let keyboardDoneButtonView = UIToolbar()
        keyboardDoneButtonView.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneBtnClick))
        
        doneButton.tintColor = UIColor.black
        keyboardDoneButtonView.setItems([doneButton], animated: true)
        textView.inputAccessoryView = keyboardDoneButtonView
        
    }
    @IBAction func sureBtnClick(_ sender: UIButton) {
        SVProgressHUD.show()
        if textField1.text == "" {
            SVProgressHUD.showInfo(withStatus: "请输入姓名")
            return
        }else if textField2.text == "" {
            SVProgressHUD.showInfo(withStatus: "请输入手机号")
            return
        }
        HRInviteUser(dic: ["token":GetUser(key: TOKEN),"name":textField1.text ?? "","phone":textField2.text ?? "","remark":textView.text ?? ""], actionHander: { (jsonStr) in
            if jsonStr["code"] == 0 {
                SVProgressHUD.showSuccess(withStatus: jsonStr["msg"].stringValue)
                if self.returnClosure != nil {
                    self.returnClosure!()
                }
                _ = self.navigationController?.popViewController(animated: true)
            }else{
                SVProgressHUD.showInfo(withStatus: jsonStr["msg"].stringValue)
            }
            
        }) { 
            
        }
        
    }
    
    
    func doneBtnClick() -> Void {
        self.textView.resignFirstResponder()
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
