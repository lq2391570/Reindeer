//
//  AddJobExeVC.swift
//  Reindeer
//
//  Created by shiliuhua on 17/4/13.
//  Copyright © 2017年 shiliuhua. All rights reserved.
//

import UIKit
import SVProgressHUD
class AddJobExeVC: BaseViewVC,UITableViewDelegate,UITableViewDataSource {

    //工作经验更新或添加（是否传id）
    enum updateOrAddType {
        case addWorkExp //添加
        case updateWorkExp //更新
        
    }
    
    //公司名称
    var companyName = ""
    //公司行业model（目前id只能有一个）
    var industryModel:CompanyIndustryListList?
    //公司行业名称
    
    
    
    //开始时间（时间戳）
    var beginTimeUnixStr = ""
    //结束时间(时间戳)
    var endTimeUnixStr = ""
    //职位类型model
    var positionModel:PositionList?
    //职位名称
    var positionName = ""
    //部门名称
    var departmentName = ""
    //工作内容
    var workContentStr = ""
    //是否隐藏简历(非隐藏 0，隐藏 1)
    var isHiddenResume = "0"
    //简历model
    var resumeBassClass:ResumeBaseClass?
    //工作经验是添加还是更新的type
    var typeOfWorkExpAddOrUpdate:updateOrAddType!
    
    //若为更新则需传工作经验的id
    var workExpId = ""
    
    //返回闭包
    var returnClosure:(() -> ())?
    //获取工作经验的model
    var workbassClass:UserWorkExpListUserWorkExpBassClass?
    
    
    @IBOutlet var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.title = "添加工作经验"
        tableView.rowHeight = 50
        tableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: "cell")
        tableView.register(UINib.init(nibName: "SelectTimeCell", bundle: nil), forCellReuseIdentifier: "SelectTimeCell")
        tableView.register(UINib.init(nibName: "OpenChoseCell", bundle: nil), forCellReuseIdentifier: "OpenChoseCell")
        tableView.tableFooterView = createBottomBtn(supView: self.tableView, title: "保存", actionHander: { (btn) in
            btn.addTarget(self, action: #selector(saveBtnClick), for: .touchUpInside)
        })
        if self.typeOfWorkExpAddOrUpdate == .updateWorkExp {
            getWorkExpWithId()
            
        }
        
    }
    //根据工作经验id查到工作经验
    func getWorkExpWithId() -> Void {
//        getWorkExpInterface(dic: ["workExpId":workExpId], actionHander: { (bassClass) in
//            self.workbassClass = bassClass
//            self.workExpId = NSNumber.init(value: (self.workbassClass?.id)!).stringValue
//            self.companyName = (self.workbassClass?.companyName)!
//        //    self.industryModel =
//            
//            
//            self.tableView.reloadData()
//        }) { 
//            SVProgressHUD.showInfo(withStatus: "请求失败")
//        }
        UserSearchWorkExp(dic: ["workExpId":workExpId], actionHander: { (bassClass) in
            self.workbassClass = bassClass
            self.workExpId = "\(self.workbassClass?.id ?? 0)"
            self.companyName = (self.workbassClass?.companyName)!
            self.tableView.reloadData()
            
        }) { 
            SVProgressHUD.showInfo(withStatus: "请求失败")
        }
    }
    
    
    func saveBtnClick() -> Void {
        print("保存点击")
        print("resumeId = \(self.resumeBassClass?.id),companyName = \(companyName),companyIndustry = \(industryModel?.id),startDate =\(beginTimeUnixStr),endDate = \(endTimeUnixStr),jobType = \(positionModel?.id),jobName = \(positionName),dept = \(departmentName),jobContent = \(workContentStr),hideWithCompany = \(isHiddenResume)")
        if companyName == "" {
            SVProgressHUD.showInfo(withStatus: "请填写公司名称")
            return
        }else if industryModel == nil {
            SVProgressHUD.showInfo(withStatus: "请选择公司行业")
            return
        }else if beginTimeUnixStr == ""{
            SVProgressHUD.showInfo(withStatus: "请选择开始时间")
            return
        }else if endTimeUnixStr == "" {
            SVProgressHUD.showInfo(withStatus: "请选择结束时间")
            return
        }else if positionModel == nil {
            SVProgressHUD.showInfo(withStatus: "请选择职位类型")
            return
        }else if positionName == "" {
            SVProgressHUD.showInfo(withStatus: "请填写职位名称")
            return
        }else if departmentName == "" {
            SVProgressHUD.showInfo(withStatus: "请填写所属部门")
            return
        }else if workContentStr == "" {
            SVProgressHUD.showInfo(withStatus: "请填写工作内容")
            return
        }
        if self.typeOfWorkExpAddOrUpdate == .addWorkExp {
         //   添加工作经验
            let dic:NSDictionary = [
                "resumeId":self.resumeBassClass?.id ?? 0,
                "companyName":companyName,
                "companyIndustry":industryModel?.id ?? 0,
                "startDate":beginTimeUnixStr,
                "endDate":endTimeUnixStr,
                "jobType":positionModel?.id ?? 0,
                "jobName":positionName,
                "dept":departmentName,
                "jobContent":workContentStr,
                "hideWithCompany":isHiddenResume
            ]
            addWorkExpInterface(dic: dic, actionHander: { (jsonStr) in
                print("jsonStr.mes = \(jsonStr["msg"])")
                if jsonStr["code"] == 0 {
                    SVProgressHUD.showSuccess(withStatus: jsonStr["msg"].string)
                    if self.returnClosure != nil {
                        self.returnClosure!()
                    }
                    delay(0.5){
                        _ = self.navigationController?.popViewController(animated: true)
                    }
                    
                }
            }, fail: {
                SVProgressHUD.showInfo(withStatus: "请求失败")
                
            })

            
        }else if self.typeOfWorkExpAddOrUpdate == .updateWorkExp {
            //更新工作经验
            let dic:NSDictionary = [
                "resumeId":self.resumeBassClass?.id ?? 0,
                "companyName":companyName,
                "companyIndustry":industryModel?.id ?? 0,
                "startDate":beginTimeUnixStr,
                "endDate":endTimeUnixStr,
                "jobType":positionModel?.id ?? 0,
                "jobName":positionName,
                "dept":departmentName,
                "jobContent":workContentStr,
                "hideWithCompany":isHiddenResume,
                "id":self.workExpId
            ]
            addWorkExpInterface(dic: dic, actionHander: { (jsonStr) in
                print("jsonStr.mes = \(jsonStr["msg"])")
                if jsonStr["code"] == 0 {
                    SVProgressHUD.showSuccess(withStatus: jsonStr["msg"].string)
                    if self.returnClosure != nil {
                        self.returnClosure!()
                    }
                    delay(0.5){
                        _ = self.navigationController?.popViewController(animated: true)
                    }
                }
            }, fail: {
                SVProgressHUD.showInfo(withStatus: "请求失败")
                
            })

        }
        
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 2
        }else if section == 1 {
            return 4
        }else if section == 2 {
            return 1
        }else{
            return 1
        }
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            var cell = tableView.dequeueReusableCell(withIdentifier: "cell")
            cell = UITableViewCell.init(style: .value1, reuseIdentifier: "cell")
            cell?.accessoryType = .disclosureIndicator
            cell?.textLabel?.font = UIFont.systemFont(ofSize: 15)
            cell?.detailTextLabel?.font = UIFont.systemFont(ofSize: 14)
            if indexPath.row == 0 {
                cell?.textLabel?.text = "公司名称"
                cell?.detailTextLabel?.text = companyName
                if self.workbassClass != nil {
                    cell?.detailTextLabel?.text = self.workbassClass?.companyName
                    if companyName != "" {
                         cell?.detailTextLabel?.text = companyName
                    }
                    
                }
                
            }else if indexPath.row == 1 {
                cell?.textLabel?.text = "公司行业"
                cell?.detailTextLabel?.text = self.industryModel?.name
                if self.workbassClass != nil {
                    self.industryModel = CompanyIndustryListList(object: "")
                    self.industryModel?.id = self.workbassClass?.companyIndustryId
                    self.industryModel?.name = self.workbassClass?.companyIndustry
                    cell?.detailTextLabel?.text = self.workbassClass?.companyIndustry
                    
                }
                
            }
            return cell!
            
        }else if indexPath.section == 1 {
            if indexPath.row == 0 {
                let timeCell = tableView.dequeueReusableCell(withIdentifier: "SelectTimeCell") as! SelectTimeCell
                if self.workbassClass != nil {

                    if self.beginTimeUnixStr == "" || self.endTimeUnixStr == "" {
                        timeCell.transitionTimeBefore(beginTimeUnixStr: "\(self.workbassClass?.startDate ?? 0)")
                        timeCell.transitionTimeEnd(endTimeUnixStr: "\(self.workbassClass?.endDate ?? 0)")
                    }
                        self.beginTimeUnixStr = "\(self.workbassClass?.startDate ?? 0)"
                        self.endTimeUnixStr = "\(self.workbassClass?.endDate ?? 0)"
                }
                
                
                timeCell.beforeTimeClosure = { (dateStr,date) in
                   
                    self.beginTimeUnixStr = dateTransformUnixStr(date: date)
                     print("self.beginTimeUnixStr = \(self.beginTimeUnixStr)")
                  //  self.tableView.reloadData()
                }
                timeCell.afterTimeClosure = { (dateStr,date) in
                    
                    self.endTimeUnixStr = dateTransformUnixStr(date: date)
                    print("self.endTimeUnixStr = \(self.endTimeUnixStr)")
                //    self.tableView.reloadData()
                }
                
                return timeCell
                
            }else{
                var cell = tableView.dequeueReusableCell(withIdentifier: "cell1")
                cell = UITableViewCell.init(style: .value1, reuseIdentifier: "cell1")
                cell?.accessoryType = .disclosureIndicator
                cell?.textLabel?.font = UIFont.systemFont(ofSize: 15)
                cell?.detailTextLabel?.font = UIFont.systemFont(ofSize: 14)
                if indexPath.row == 1 {
                    cell?.textLabel?.text = "职位类型"
                    cell?.detailTextLabel?.text = self.positionModel?.name
                    if self.workbassClass != nil {
                        cell?.detailTextLabel?.text = self.workbassClass?.jobType
                        positionModel = PositionList(object: "")
                        positionModel?.name = self.workbassClass?.jobType
                        positionModel?.id = self.workbassClass?.jobTypeId
                    }
                }else if indexPath.row == 2 {
                    cell?.textLabel?.text = "职位名称"
                    cell?.detailTextLabel?.text = positionName
                    if self.workbassClass != nil {
                        cell?.detailTextLabel?.text = self.workbassClass?.jobName
                        positionName = (self.workbassClass?.jobName)!
                    }
                }else if indexPath.row == 3 {
                    cell?.textLabel?.text = "所属部门"
                    cell?.detailTextLabel?.text = departmentName
                    if self.workbassClass != nil {
                        cell?.detailTextLabel?.text = self.workbassClass?.dept
                        departmentName = (self.workbassClass?.dept)!
                    }
                }
                return cell!
            }
            
        }else if indexPath.section == 2 {
            var cell = tableView.dequeueReusableCell(withIdentifier: "cell2")
            cell = UITableViewCell.init(style: .value1, reuseIdentifier: "cell2")
            cell?.accessoryType = .disclosureIndicator
            cell?.textLabel?.font = UIFont.systemFont(ofSize: 15)
            cell?.detailTextLabel?.font = UIFont.systemFont(ofSize: 14)
            cell?.textLabel?.text = "工作内容"
            cell?.detailTextLabel?.text = workContentStr
            if self.workbassClass != nil {
                cell?.detailTextLabel?.text = self.workbassClass?.jobContent
                workContentStr = (self.workbassClass?.jobContent)!
            }
            return cell!
        }else if indexPath.section == 3 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "OpenChoseCell") as! OpenChoseCell
            cell.nameLabel.text = "对这家公司隐藏简历"
            if self.workbassClass != nil {
                self.isHiddenResume = "\(self.workbassClass?.hideWithCompany ?? 0)"
                if self.isHiddenResume == "1" {
                    cell.switchBtn.isSelected = false
                }else{
                    cell.switchBtn.isSelected = true
                }
            }
            cell.switchBtnClickColsure = { (btn) in
                
                print("btn.isSelect = \(btn.isSelected)")
                
                if btn.isSelected == false {
                    self.isHiddenResume = "1"
                }else{
                    self.isHiddenResume = "0"
                }
                
                
            }
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        return cell!
        
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                //公司名称
                let vc = TextFieldVC()
                vc.completeClosure = { (str) in
                    print("str = \(str)")
                   self.companyName = str
                    
                    self.tableView.reloadData()
                }
                vc.placeholdStr = "请输入公司名称"
                self.navigationController?.pushViewController(vc, animated: true)
            }else{
                //行业选择
                let vc = UIStoryboard(name: "LoginAndUserStoryboard", bundle: nil).instantiateViewController(withIdentifier: "IndustryChoseVC") as! IndustryChoseVC
                
                
                
                vc.sureBtnClickClosure = { (listModelArray:[CompanyIndustryListList]) in
                    print("listModelArray = \(listModelArray)")
                    if listModelArray.count > 0 {
                         self.industryModel = listModelArray[0]
                        if self.workbassClass != nil {
                            self.workbassClass?.companyIndustryId = self.industryModel?.id
                            self.workbassClass?.companyIndustry = self.industryModel?.name
                        }
                    }
                  self.tableView.reloadData()
                }
                self.navigationController?.pushViewController(vc, animated: true)
                
                
            }
        }else if indexPath.section == 1 {
            if indexPath.row == 1 {
                //职位类型
                let vc = UIStoryboard(name: "UserCenter", bundle: nil).instantiateViewController(withIdentifier: "ChoseIntensionVC") as! ChoseIntensionVC
                vc.TranslucentModel.returnClosure = { (positionModel:PositionList) in
                    print("positionModel = \(positionModel)")
                    self.positionModel = positionModel
                    
                    if self.workbassClass != nil {
                        self.workbassClass?.jobType = self.positionModel?.name
                        self.workbassClass?.jobTypeId = self.positionModel?.id
                    }
                    
                    self.tableView.reloadData()
                }
                self.navigationController?.pushViewController(vc, animated: true)
                
                
            }else if indexPath.row == 2 {
                //职位名称
                let vc = TextFieldVC()
                vc.completeClosure = { (str) in
                    print("str = \(str)")
                    self.positionName = str
                    if self.workbassClass != nil {
                        self.workbassClass?.jobName = self.positionName
                    }
                    self.tableView.reloadData()
                }
                vc.placeholdStr = "请输入职位名称"
                self.navigationController?.pushViewController(vc, animated: true)
                
            }else if indexPath.row == 3 {
                //所属部门
                let vc = TextFieldVC()
                vc.completeClosure = { (str) in
                    print("str = \(str)")
                    self.departmentName = str
                    if self.workbassClass != nil {
                        self.workbassClass?.dept = self.departmentName
                    }
                    self.tableView.reloadData()
                }
                vc.placeholdStr = "请输入部门名称"
                self.navigationController?.pushViewController(vc, animated: true)
               
            }
            
        }else if indexPath.section == 2 {
            //工作内容
            let vc = TextViewVC()
            vc.textViewTypeEnum = .typeWorkContent
            vc.saveBtnClickClosure = { (str) in
                self.workContentStr = str
                if self.workbassClass != nil {
                    self.workbassClass?.jobContent = self.workContentStr
                }
                self.tableView.reloadData()
            }
            
            self.navigationController?.pushViewController(vc, animated: true)
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
