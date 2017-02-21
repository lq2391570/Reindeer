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
class TextViewVC: UIViewController,YYTextViewDelegate {

    
    
    
    @IBOutlet var saveBtn: UIButton!
    
    @IBOutlet var textView: YYTextView!
   
    var placeholdText = ""
    var navTitle = ""
    //点击保存
    var saveBtnClickClosure:((String) -> ())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.title = navTitle
        textView.placeholderText = placeholdText
        textView.delegate = self
        saveBtn.addTarget(self, action: #selector(saveBtnClick(btn:)), for: .touchUpInside)
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        textView.resignFirstResponder()
    }
    
    func saveBtnClick(btn:UIButton) -> Void {
        //保存
        if (saveBtnClickClosure != nil) {
            saveBtnClickClosure! (textView.text)
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
