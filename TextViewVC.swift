//
//  TextViewVC.swift
//  Reindeer
//
//  Created by shiliuhua on 17/2/21.
//  Copyright © 2017年 shiliuhua. All rights reserved.
//

import UIKit
import YYText
import IQKeyboardManagerSwift
import SVProgressHUD
class TextViewVC: UIViewController,YYTextViewDelegate {

    //textView类型
    enum textViewType {
        //我的优势
        case typeAdvantage
        //工作内容及其他
        case typeWorkContent
        //在校经历
        case typeSchoolExp
    }
    
    @IBOutlet var saveBtn: UIButton!
    
    @IBOutlet var textView: YYTextView!
    var textViewTypeEnum:textViewType = .typeWorkContent
    var placeholdText = ""
    var navTitle = ""
    //简历id（更新我的优势时可以用到）
    var resumeBassClass:ResumeBaseClass?
    
    //点击保存
    var saveBtnClickClosure:((String) -> ())?
    
    @IBOutlet var textRangeLabel: UILabel!
    
    @IBOutlet var bottomBtn: UIButton!
    
    @IBOutlet var bottomline: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.title = navTitle
        textView.placeholderText = placeholdText
        textView.delegate = self
        saveBtn.addTarget(self, action: #selector(saveBtnClick(btn:)), for: .touchUpInside)
        if textViewTypeEnum == .typeAdvantage {
            bottomBtn.isHidden = false
            bottomline.isHidden = false
            textView.text = self.resumeBassClass?.mYAdvantage
            textRangeLabel.text = "\(textView.text.length)/300"
        }
        
    }
    @IBAction func bottomBtnClick(_ sender: UIButton) {
        
        
    }
    func textView(_ textView: YYTextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool
    {
        print("text.lengh = \(range.location)")
        textRangeLabel.text = "\(range.location)/300"
        if range.location > 9 {
            SVProgressHUD.showInfo(withStatus: "字数超过限制")
            return false
        }else{
            return true
        }
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        textView.resignFirstResponder()
    }
    
    func saveBtnClick(btn:UIButton) -> Void {
        
        if self.textViewTypeEnum == .typeAdvantage {
            if textView.text == "" {
                SVProgressHUD.showInfo(withStatus: "请输入内容")
                return
            }
            let resumeId = NSNumber.init(value: (self.resumeBassClass?.id)!).stringValue
            updateMyAdvantageInterface(dic: ["resumeId":resumeId,"content":textView.text], actionHander: { (jsonStr) in
                if jsonStr["code"] == 0 {
                    //保存
                    if (self.saveBtnClickClosure != nil) {
                        self.saveBtnClickClosure! (self.textView.text)
                    }
                    _ = self.navigationController?.popViewController(animated: true)
                    
                }else{
                    SVProgressHUD.showInfo(withStatus: jsonStr["msg"].stringValue)
                }
                
            }, fail: { 
                SVProgressHUD.showInfo(withStatus: "请求失败")
            })
        }else{
            //保存
            if (saveBtnClickClosure != nil) {
                saveBtnClickClosure! (textView.text)
            }
            _ = self.navigationController?.popViewController(animated: true)
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
