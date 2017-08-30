//
//  RecommendTalentVC.swift
//  Reindeer
//
//  Created by shiliuhua on 2017/8/23.
//  Copyright © 2017年 shiliuhua. All rights reserved.
//

import UIKit
import YYText
import SwiftyJSON
import SVProgressHUD
class RecommendTalentVC: BaseViewVC,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate {

    @IBOutlet var textfield1: MyTextField!
    
    @IBOutlet var textView: YYTextView!
    
    @IBOutlet var tableView: UITableView!
    //求职意向id
    var intendId:String = "0"
    //简历id
    var resumeId:Int = 0
    var phoneNum:String = ""
    
    var searchBassClass:PhoneNumSearchPhoneNumSearchBassClass?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.title = "推荐人才"
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib.init(nibName: "PhoneSearchCell", bundle: nil), forCellReuseIdentifier: "PhoneSearchCell")
        tableView.isHidden = true
        
        textfield1.placeholder = "请输入手机号(推荐给谁)"
        textfield1.delegate = self
        let placeholder1 = NSMutableAttributedString.init(string: textfield1.placeholder!)
        placeholder1.addAttribute(NSFontAttributeName, value: UIFont.systemFont(ofSize: 15), range: NSMakeRange(0, (textfield1.placeholder?.length)!))
        textfield1.attributedPlaceholder = placeholder1
        textView.placeholderFont = UIFont.systemFont(ofSize: 15)
        textView.textContainerInset = UIEdgeInsetsMake(10, 20, 0, 0)
        textView.font = UIFont.systemFont(ofSize: 15)
        textView.placeholderText = "请进行评价..."
        let keyboardDoneButtonView = UIToolbar()
        keyboardDoneButtonView.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneBtnClick))
        doneButton.tintColor = UIColor.black
        keyboardDoneButtonView.setItems([doneButton], animated: true)
        textView.inputAccessoryView = keyboardDoneButtonView
        let rightBarBtnitem = UIBarButtonItem(title: "完成", style: .plain, target: self, action: #selector(rightBarBtnItemClick))
        
        self.navigationItem.rightBarButtonItem = rightBarBtnitem
        
        textfield1.becomeFirstResponder()
        textfield1.keyboardType = .numbersAndPunctuation
        self.navigationItem.rightBarButtonItem?.setTitleTextAttributes([NSForegroundColorAttributeName:UIColor.mainColor], for: .normal)
        
    }
    //获得电话号码联想
    func getPhoneNumSearchAssociate(phoneNumStr:String) -> Void {
        let dic:NSDictionary = [
            "token":GetUser(key: TOKEN),
            "phone":phoneNumStr,
            "no":1,
            "size":10
        ]
        let jsonStr = JSON(dic)
        let newDic:NSDictionary = jsonStr.dictionaryValue as NSDictionary
        
        PhoneNumSearchListInterface(dic: newDic, actionHander: { (bassClass) in
            self.searchBassClass = bassClass
            self.tableView.reloadData()
        }) { 
            
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        print("textField.text = \(textField.text)")
        
        if self.textfield1.text != "" {
            tableView.isHidden = false
            getPhoneNumSearchAssociate(phoneNumStr: textField.text!)
        }else{
            tableView.isHidden = true
        }
        return true
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if self.searchBassClass != nil {
            return (self.searchBassClass?.list?.count)!
        }
        return 0
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let model:PhoneNumSearchList = (self.searchBassClass?.list![indexPath.row])!
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "PhoneSearchCell") as! PhoneSearchCell
        
        cell.installCell(headImageStr: model.avatar, name: model.name, phoneNumStr: model.phone)
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model:PhoneNumSearchList = (self.searchBassClass?.list![indexPath.row])!
        textfield1.text = model.phone
        self.phoneNum = model.phone!
        tableView.isHidden = true
        
    }
    func rightBarBtnItemClick() -> Void {
        print("完成")
        SVProgressHUD.show()
        let dic:NSDictionary = [
            "token":GetUser(key: TOKEN),
            "id":resumeId,
            "phone":self.phoneNum,
            "reason":textView.text ?? "",
            "intentId":intendId
        ]
        let jsonStr = JSON(dic)
        let newDic:NSDictionary = jsonStr.dictionaryValue as NSDictionary
        
        talentRecommendInterface(dic: newDic, actionHander: { (jsonStr) in
            if jsonStr["code"] == 0 {
                SVProgressHUD.showSuccess(withStatus: "推荐成功")
                _ = self.navigationController?.popViewController(animated: true)
            }else{
                SVProgressHUD.showInfo(withStatus: jsonStr["msg"].stringValue)
            }
            
        }) { 
            
        }
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    @IBAction func recommendRecordsClick(_ sender: UIButton) {
        print("推荐记录")
        let vc = UIStoryboard(name: "UserFirstStoryboard", bundle: nil).instantiateViewController(withIdentifier: "RecommendHRListVC") as! RecommendHRListVC
        
        self.navigationController?.pushViewController(vc, animated: true)
        
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
