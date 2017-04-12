//
//  CompleteHRMesVC.swift
//  Reindeer
//
//  Created by shiliuhua on 17/2/8.
//  Copyright © 2017年 shiliuhua. All rights reserved.
//

import UIKit
import SVProgressHUD
class CompleteHRMesVC: UIViewController,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate {

    @IBOutlet var tableView: UITableView!
    
    //头像url
    var headImageStr = ""
    //性别str
    var sexStr = "男"
    //真实姓名Str
    var trueNameStr:String?
    //职务Str
    var dutyNameStr:String?
    //公司名称Str
    var companyNameStr:String?
    //公司ID（新建公司无id，选择的公司有id）
    var companyId:NSInteger?
    //公司简介Str
    var companyBriefStr:String?
    //emailStr
    var emailStr:String?
    //是否开通视频面试
    var isOpenVideoInvite = true
    //是否开通简历招聘
    var isOpenResumeInvite = true
    
    //公司名称TextField
    var mytextField:UITextField!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
            // Do any additional setup after loading the view.
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.barTintColor=UIColor.black
        //消除毛玻璃效果
        self.navigationController?.navigationBar.isTranslucent = false;
        self.title = "完善个人信息"
        self.navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName:UIFont.systemFont(ofSize: 20)]
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.mainColor]
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib.init(nibName: "TextFieldCell", bundle: nil), forCellReuseIdentifier: "TextFieldCell")
        tableView.register(UINib.init(nibName: "CompleteHRMesHeadCell", bundle: nil), forCellReuseIdentifier: "CompleteHRMesHeadCell")
        tableView.register(UINib.init(nibName: "OpenChoseCell", bundle: nil), forCellReuseIdentifier: "OpenChoseCell")
        tableView.tableFooterView = createFootView()
        
    }
    func createFootView() -> UIView {
        let footView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width , height: 60))
        let btn = UIButton(frame: CGRect.init(x: 20, y: 10, width: tableView.frame.size.width - 40, height: 40))
        btn.backgroundColor = UIColor.black
        btn.setTitle("下一步", for: .normal)
        btn.setTitleColor(UIColor.mainColor, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        btn.addTarget(self, action: #selector(nextBtnClick), for: .touchUpInside)
        footView.addSubview(btn)
        return footView
    }
    func nextBtnClick() -> Void {
       
        self.view.endEditing(true)
        
        //判断必要条件
        if trueNameStr == nil || trueNameStr == "" {
            SVProgressHUD.showInfo(withStatus: "请输入您的姓名")
            return
        }
        if dutyNameStr == nil || dutyNameStr == "" {
            SVProgressHUD.showInfo(withStatus: "请输入您的职务")
            return
        }
        if companyNameStr == nil || companyNameStr == "" {
            SVProgressHUD.showInfo(withStatus: "请输入公司名称")
            return
        }
        if companyBriefStr == nil || companyBriefStr == "" {
            SVProgressHUD.showInfo(withStatus: "请输入公司简介")
            return
        }
        if emailStr == nil || emailStr == "" {
            SVProgressHUD.showInfo(withStatus: "请输入您的邮箱")
            return
        }
        
        print("信息 ==token=\(GetUser(key: "token")) \(headImageStr)+\(sexStr)+\(trueNameStr)+\(dutyNameStr)+\(companyNameStr)+\(companyId)+\(companyBriefStr)+\(emailStr)+\(isOpenVideoInvite)+\(isOpenResumeInvite)")
        
        //判断是否存在公司id
        var requestDic:NSDictionary!
        
        if companyId == nil {
            //不带公司id的dic
            let dic2:NSDictionary = ["token":GetUser(key: "token"),"sex":sexStr,"name":trueNameStr!,"job":dutyNameStr!,"email":emailStr!,"avatar":headImageStr,"companyName":companyNameStr!,"companyShortName":companyBriefStr!,"video":isOpenVideoInvite,"common":isOpenResumeInvite]
            requestDic = dic2
        }else{
            //带公司id的dic
            let dic1:NSDictionary = ["token":GetUser(key: "token"),"sex":sexStr,"name":trueNameStr!,"job":dutyNameStr!,"email":emailStr!,"avatar":headImageStr,"companyName":companyNameStr!,"companyShortName":companyBriefStr!,"video":isOpenVideoInvite,"common":isOpenResumeInvite,"companyId":companyId!]
            requestDic = dic1
        }
        
        completeHRMes(dic: requestDic, actionHandler: { (jsonStr) in
            print("jsonStr=\(jsonStr)")
            if jsonStr["code"] == 0 {
                let vc = UIStoryboard(name: "LoginAndUserStoryboard", bundle: nil).instantiateViewController(withIdentifier: "CompleteCompanyMesVC") as! CompleteCompanyMesVC
                
                let companyid = jsonStr["id"].stringValue
                                
                print("companyid = \(companyid)")
                
                
                vc.companyId = companyid
                
                self.navigationController?.pushViewController(vc, animated: true)
            }
            
        }, fail: {
            
            
        })
        
    }
    //TextField代理
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
        
        if textField.tag == 100 {
            let vc = UIStoryboard(name: "LoginAndUserStoryboard", bundle: nil).instantiateViewController(withIdentifier: "CompanyNameVC") as! CompanyNameVC
            vc.returnClosure = { (companyModel,companyName) in
                print("companyModel.name = \(companyModel?.name),companyModel.id=\(companyModel?.id),companyName = \(companyName)")
                if companyModel != nil {
                    self.companyNameStr = companyModel?.name
                    self.companyId = companyModel?.id
                }else{
                    self.companyNameStr = companyName
                }
                self.tableView.reloadData()
            }
            self.navigationController?.pushViewController(vc, animated: true)
            textField.resignFirstResponder()
        }
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        switch section {
        case 0:
            return 1
        case 1:
            return 2
        case 2:
            return 2
        case 3:
            return 1
        case 4:
            return 2
        default:
            return 0
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CompleteHRMesHeadCell") as! CompleteHRMesHeadCell
            cell.superVC = self
            cell.choseImageColsure = { (choseImageStr) in
                self.headImageStr = choseImageStr
            }
            
            return cell
        }else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TextFieldCell") as! TextFieldCell
          
            if indexPath.row == 0 {
                cell.jvTextField.delegate = cell
                cell.jvTextField.placeholder = "真实姓名"
                cell.textFieldDelegateColsure = { (jvTextField) in
                    print("namejvTextField = \(jvTextField.text)")
                    self.trueNameStr = jvTextField.text
                }
                    }else if indexPath.row == 1 {
                cell.jvTextField.delegate = cell
                cell.jvTextField.placeholder = "您的职务"
                cell.textFieldDelegateColsure = { (jvTextField) in
                    print("dutyjvTextField = \(jvTextField.text)")
                    self.dutyNameStr = jvTextField.text
                }
            }
            return cell
        }else if indexPath.section == 2{
            let cell = tableView.dequeueReusableCell(withIdentifier: "TextFieldCell") as! TextFieldCell
           
           
            if indexPath.row == 0 {
                cell.jvTextField.delegate = self
                cell.jvTextField.placeholder = "公司名称"
                
                cell.jvTextField.tag = 100
                cell.textFieldDelegateColsure = { (jvTextField) in
                    print("companyNameJvTextField = \(jvTextField.text)")
                    self.companyNameStr = jvTextField.text
                }
                cell.jvTextField.text = self.companyNameStr
                
            }else if indexPath.row == 1 {
                
                cell.jvTextField.delegate = cell
                cell.jvTextField.tag = 200
                cell.jvTextField.placeholder = "公司简介"
                cell.textFieldDelegateColsure = { (jvTextField) in
                    print("beiefJvTextField = \(jvTextField.text)")
                    self.companyBriefStr = jvTextField.text
                }
                
            }
            return cell
        }else if indexPath.section == 3 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TextFieldCell") as! TextFieldCell
            
         
            cell.jvTextField.tag = 300
            cell.jvTextField.placeholder = "接收简历的邮箱"
            cell.textFieldDelegateColsure = { (jvTextField) in
                print("emailTextField = \(jvTextField.text)")
                self.emailStr = jvTextField.text
            }
            
            return cell
        }else if indexPath.section == 4 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "OpenChoseCell") as! OpenChoseCell
            if indexPath.row == 0 {
                cell.nameLabel.text = "开通视频招聘"
                cell.switchBtnClickColsure = { (sender) in
                    self.isOpenVideoInvite = sender.isSelected
                }
            }else if indexPath.row == 1 {
                cell.nameLabel.text = "开通简历招聘"
                cell.switchBtnClickColsure = { (sender) in
                    self.isOpenResumeInvite = sender.isSelected
                }
            }
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
            return cell!
        }
        
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard section == 2 else {
            return nil
        }
        let view = Bundle.main.loadNibNamed("GoOnView", owner: self, options: nil)?.last as! GoOnView
        
        return view
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if indexPath.section == 0 {
            return 320
        }else {
            return 70
        }
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        if section == 2 {
            return 160
        }else if section == 3 {
            return 10
        }else if section == 4 {
            return 10
        }else{
            return 0
        }
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat
    {
        return 0
    }
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 5
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        if indexPath.section == 2 {
//            if indexPath.row == 0 {
//                let vc = UIStoryboard(name: "LoginAndUserStoryboard", bundle: nil).instantiateViewController(withIdentifier: "CompanyNameVC") as! CompanyNameVC
//                vc.returnClosure = { (companyModel,companyName) in
//                    print("companyModel = \(companyModel),companyName = \(companyName)")
//                }
//                self.navigationController?.pushViewController(vc, animated: true)
//            }
//        }
    
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
