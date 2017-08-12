//
//  AddEduExpVC.swift
//  Reindeer
//
//  Created by shiliuhua on 2017/4/18.
//  Copyright © 2017年 shiliuhua. All rights reserved.
//

import UIKit
import SVProgressHUD
class AddEduExpVC: BaseViewVC,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet var tableView: UITableView!
    
    var resumeBassClass:ResumeBaseClass?
    //教育经历更新或添加（是否传id）
    enum updateOrAddType {
        case addEduExp //添加
        case updateEduExp //更新
    }
   //学校名称
    var schoolNameStr = ""
    //专业名称
    var majorNameStr = ""
    //学历model
    var positionModel:PositionList?
    //开始时间（时间戳）
    var beginTimeUnixStr = ""
    //结束时间(时间戳)
    var endTimeUnixStr = ""
    //在校经历
    var schoolExpStr = ""
    //教育经历是添加还是更新
    var typeOfEduExpAddOrUpdate:updateOrAddType!
    //若为更新则需传教育经历的id
    var eduExpId = ""
    //返回闭包
     var returnClosure:(() -> ())?
    
    //学历model
    var positionBaseClass:PositionBaseClass?
    
    //教育经历model
    var eduBassClass:UserWorkEduListUserWorkEduBassClass?
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = "教育经历"
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: "cell")
        tableView.register(UINib.init(nibName: "SelectTimeCell", bundle: nil), forCellReuseIdentifier: "SelectTimeCell")
        tableView.rowHeight = 60
        tableView.tableFooterView = createBottomBtn(supView: tableView, title: "保存", actionHander: { (btn) in
            btn.addTarget(self, action: #selector(saveBtnClick), for: .touchUpInside)
        })
        getEducationList()
        if self.typeOfEduExpAddOrUpdate == .updateEduExp {
            self.searchUserEdu(eduId: self.eduExpId)
        }
        
    }
    //根据eduId查询教育经历
    func searchUserEdu(eduId:String) -> Void {
       UserSearchEdu(dic: ["eduExpId":self.eduExpId], actionHander: { (bassClass) in
        self.eduBassClass = bassClass
        self.tableView.reloadData()
        
       }) { () -> Void in
        
     }
   }
    
    func saveBtnClick() -> Void {
        print("保存")
        
        if self.schoolNameStr == "" {
            SVProgressHUD.showInfo(withStatus: "请输入学校名称")
            return
        }else if self.majorNameStr == "" {
            SVProgressHUD.showInfo(withStatus: "请输入专业名称")
            return
        }else if self.positionModel == nil {
            SVProgressHUD.showInfo(withStatus: "请选择学历")
            return
        }else if beginTimeUnixStr == "" {
            SVProgressHUD.showInfo(withStatus: "请选择开始时间")
            return
        }else if endTimeUnixStr == "" {
            SVProgressHUD.showInfo(withStatus: "请选择结束时间")
            return
        }else if schoolExpStr == "" {
            SVProgressHUD.showInfo(withStatus: "请填写在校经历")
            return
        }
        var dic:NSDictionary = [:]
        if self.typeOfEduExpAddOrUpdate == updateOrAddType.addEduExp {
            //添加
             dic = [
                "resumeId":self.resumeBassClass?.id ?? 0,
                "school":schoolNameStr,
                "profession":majorNameStr,
                "qualificationsId":positionModel?.id ?? 0,
                "startDate":beginTimeUnixStr,
                "endDate":endTimeUnixStr,
                "schoolExp":schoolExpStr
            ]
            
        }else{
            dic = [
                "id":self.eduExpId,
                "resumeId":self.resumeBassClass?.id ?? 0,
                "school":schoolNameStr,
                "profession":majorNameStr,
                "qualificationsId":positionModel?.id ?? 0,
                "startDate":beginTimeUnixStr,
                "endDate":endTimeUnixStr,
                "schoolExp":schoolExpStr
            ]
            
        }
            addEduExpInterface(dic: dic, actionHander: { (jsonStr) in
                if jsonStr["code"] == 0 {
                    SVProgressHUD.showSuccess(withStatus: jsonStr["msg"].stringValue)
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
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if section == 0 {
            return 4
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

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        if indexPath.section == 0{
            if indexPath.row == 3 {
                let timeCell = tableView.dequeueReusableCell(withIdentifier: "SelectTimeCell") as! SelectTimeCell
                if self.eduBassClass != nil {
                    if self.beginTimeUnixStr == "" || self.endTimeUnixStr == "" {
                        timeCell.transitionTimeBefore(beginTimeUnixStr: "\(self.eduBassClass?.startDate ?? 0)")
                        timeCell.transitionTimeEnd(endTimeUnixStr: "\(self.eduBassClass?.endDate ?? 0)")
                    }
                    self.beginTimeUnixStr = "\(self.eduBassClass?.startDate ?? 0)"
                    self.endTimeUnixStr = "\(self.eduBassClass?.endDate ?? 0)"
                }
                
                
                
                timeCell.beforeTimeClosure = { (dateStr,date) in
                 self.beginTimeUnixStr = dateTransformUnixStr(date: date)
                  //  self.tableView.reloadData()
                    
                }
                timeCell.afterTimeClosure = { (dateStr,date) in
                    self.endTimeUnixStr = dateTransformUnixStr(date: date)
                  //  self.tableView.reloadData()
                }
                
                return timeCell
            }else{
                var cell = tableView.dequeueReusableCell(withIdentifier: "cell")
                cell = UITableViewCell.init(style: .value1, reuseIdentifier: "cell")
                cell?.accessoryType = .disclosureIndicator
                cell?.textLabel?.font = UIFont.systemFont(ofSize: 15)
                cell?.detailTextLabel?.font = UIFont.systemFont(ofSize: 14)
                if indexPath.row == 0 {
                    cell?.textLabel?.text = "学校"
                    cell?.detailTextLabel?.text = schoolNameStr
                    if self.eduBassClass != nil {
                        schoolNameStr = (self.eduBassClass?.school)!
                        cell?.detailTextLabel?.text = self.eduBassClass?.school
                    }
                    
                }else if indexPath.row == 1 {
                    cell?.textLabel?.text = "专业"
                    cell?.detailTextLabel?.text = majorNameStr
                    if self.eduBassClass != nil {
                        majorNameStr = (self.eduBassClass?.profession)!
                        cell?.detailTextLabel?.text = self.eduBassClass?.profession
                    }
                }else if indexPath.row == 2 {
                    cell?.textLabel?.text = "学历"
                    cell?.detailTextLabel?.text = positionModel?.name
                    if self.eduBassClass != nil {
                        positionModel = PositionList(object: "")
                        positionModel?.name = self.eduBassClass?.qualificationsNme
                        positionModel?.id = self.eduBassClass?.qualificationsId
                        cell?.detailTextLabel?.text = self.eduBassClass?.qualificationsNme
                    }
                }
                return cell!
            }
        }else{
            var cell = tableView.dequeueReusableCell(withIdentifier: "cell")
            cell = UITableViewCell.init(style: .value1, reuseIdentifier: "cell")
            cell = UITableViewCell.init(style: .value1, reuseIdentifier: "cell")
            cell?.accessoryType = .disclosureIndicator
            cell?.textLabel?.font = UIFont.systemFont(ofSize: 15)
            cell?.detailTextLabel?.font = UIFont.systemFont(ofSize: 14)
            cell?.textLabel?.text = "在校经历"
            cell?.detailTextLabel?.numberOfLines = 0
            cell?.detailTextLabel?.text = schoolExpStr
            if self.eduBassClass != nil {
                schoolExpStr = (self.eduBassClass?.schoolExp)!
                cell?.detailTextLabel?.text = self.eduBassClass?.schoolExp
            }
            return cell!
        }
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                //学校名称
                let vc = TextFieldVC()
                vc.completeClosure = { (str) in
                    print("str = \(str)")
                    self.schoolNameStr = str
                    if self.eduBassClass != nil {
                        self.eduBassClass?.school = self.schoolNameStr
                    }
                    self.tableView.reloadData()
                }
                vc.placeholdStr = "请输入学校名称"
                self.navigationController?.pushViewController(vc, animated: true)
            }else if indexPath.row == 1 {
                //专业
                let vc = TextFieldVC()
                vc.completeClosure = { (str) in
                    self.majorNameStr = str
                    if self.eduBassClass != nil {
                        self.eduBassClass?.profession = self.majorNameStr
                    }
                    
                    self.tableView.reloadData()
                }
                vc.placeholdStr = "请输入专业名称"
                self.navigationController?.pushViewController(vc, animated: true)
                
            }else if indexPath.row == 2 {
                var stringArray:[String] = []
                if self.positionBaseClass != nil {
                    for educationList in (self.positionBaseClass?.list)! {
                        let model:PositionList = educationList
                        stringArray.append(model.name!)
                    }
                    
                    createActionSheet(title: "学历", message: "选择学历", stringArray: stringArray, viewController: self, closure: { (index) in
                        self.positionModel = self.positionBaseClass?.list?[index]
                        if self.eduBassClass != nil{
                            self.eduBassClass?.qualificationsNme = self.positionModel?.name
                            self.eduBassClass?.qualificationsId = self.positionModel?.id
                            
                        }
                        
                        self.tableView.reloadData()
                    })

                }
                
                
            }
            
            
        }else{
            let vc = TextViewVC()
            vc.textViewTypeEnum = .typeSchoolExp
            vc.saveBtnClickClosure = { (str) in
                
                self.schoolExpStr = str
                if self.eduBassClass != nil {
                    self.eduBassClass?.schoolExp = self.schoolExpStr
                }
                
                self.tableView.reloadData()
            }
            self.navigationController?.pushViewController(vc, animated: true)
            
        }
        
        
    }
    //获得学历列表
    func getEducationList() -> Void {
        getEducationRange(dic: [:], actionHander: { (bassClass) in
            self.positionBaseClass = bassClass
            
        }) { 
            SVProgressHUD.showInfo(withStatus: "请求失败")
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 2
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
