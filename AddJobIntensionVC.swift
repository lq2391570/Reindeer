//
//  AddJobIntensionVC.swift
//  Reindeer
//
//  Created by shiliuhua on 17/2/23.
//  Copyright © 2017年 shiliuhua. All rights reserved.
//

import UIKit
import Spring
import JCAlertView
import SVProgressHUD
class AddJobIntensionVC: BaseViewVC,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet var tableView: UITableView!
    
    //状态 loginEnterState:注册登陆进入的 resumeEnterState:求职意向添加的 updateEnterState 更新进来的
    enum enterStateEnum {
        case loginEnterState
        case resumeEnterState
        case updateEnterState
        
    }
    var returnClosure:(() -> ())?
    
    var enterState:enterStateEnum = .loginEnterState
    
    var nameArray = ["期望岗位","期望行业","期望工作城市","个人技能","薪资范围"]
    //岗位model
    var positionModel:PositionList?
    //简历model
    var resumeModel:ResumeBaseClass?
    //行业list
    var industryList:[CompanyIndustryListList] = []
    //地区名称
    var areaName = ""
    //地区id
    var areaId = ""
    //地区model
    var areaModel:AreaBaseClass?
    
    //薪资范围数组
    var compensationArray:[PositionList] = []
    //薪资范围model
    var compensationModel:PositionList?
    //个人技能
    var skillsStr = ""
    //求职意向的id
    var jobIntensionId = ""
    //传递的dic
    var saveOrUpdateDic:NSDictionary!
    
    //若为更新进来的则传入model
    var jobIntensionModel:JobIntentSearchBaseClass?
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = "求职意向"
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: "cell1")
        tableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: "cell2")
        tableView.tableFooterView = createBottomBtn()
        getCompensation()
        getUserResume()
        if self.enterState == .updateEnterState {
            updateGetjobIntententModel()
            
        }
        
        
    }
    //更新时获得求职意向的model
    func updateGetjobIntententModel() -> Void {
        searchJobIntentInterface(dic: ["jobIntentId":jobIntensionId], actionHander: { (bassClass) in
            
            self.jobIntensionModel = bassClass
            self.positionModel = PositionList(object: [])
            self.positionModel?.id = bassClass.jobId
            self.positionModel?.name = bassClass.name
            
            self.areaModel = AreaBaseClass(object: [])
            self.areaModel?.name = bassClass.area
            self.areaModel?.id = bassClass.cityId
            self.skillsStr = ""
            
            let industryModel = CompanyIndustryListList(object: [])
            industryModel.id = bassClass.industryId
            industryModel.name = bassClass.industry
           self.industryList.append(industryModel)
            
            
            self.compensationModel = PositionList(object: [])
            self.compensationModel?.id = bassClass.salaryId
            self.compensationModel?.name = bassClass.salary
            
           // self.jobIntensionId = bassClass.jobId
            self.tableView.reloadData()
            
        }) { 
            
        }
        
    }
    
    //创建底部Btn(保存按钮)
    func createBottomBtn() -> UIView {
        let view = UIView(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.size.width, height: 60))
        view.backgroundColor = UIColor.clear
        let btn = UIButton(type: .custom)
        btn.frame = CGRect.init(x: 0, y: 0, width: tableView.frame.size.width - 40, height: 40)
        btn.backgroundColor = UIColor.black
        btn.setTitle("保存", for: .normal)
        btn.addTarget(self, action: #selector(saveBtnClick), for: .touchUpInside)
        btn.setTitleColor(UIColor.mainColor, for: .normal)
        view.addSubview(btn)
        btn.snp.makeConstraints { (make) in
            make.left.equalTo(view.snp.left).offset(20)
            make.right.equalTo(view.snp.right).offset(-20)
            make.top.equalTo(view.snp.top).offset(10)
        }
        
        return view
    }
    func saveBtnClick() -> Void {
        print("点击了保存")
        
        addJobIntension()
    }
    //添加求职意向
    func addJobIntension() ->Void
    {
        if self.positionModel?.id == nil {
            SVProgressHUD.showInfo(withStatus: "请选择期望岗位")
            return
        }else if industryList.count == 0 {
            SVProgressHUD.showInfo(withStatus: "请选择行业")
            return
        }else if areaModel == nil
        {
            SVProgressHUD.showInfo(withStatus: "请选择地区")
            return
        }else if compensationModel?.id == nil
        {
            SVProgressHUD.showInfo(withStatus: "请选择薪资范围")
            return
        }
        
       print("resumeId = \(self.resumeModel?.id),jobId = \(positionModel?.id) industryId =\(industryList[0].id),cityId = \(areaModel?.id),skills = \(skillsStr),salaryId = \(compensationModel?.id)")
       //如果是添加则不传id,如果是更新则传id
        let noIdDic = ["resumeId":self.resumeModel?.id ?? 0,"jobId":positionModel?.id ?? 0,"industryId":industryList[0].id ?? 0,"cityId":areaModel?.id as Any,"skills":"","salaryId":compensationModel?.id ?? 0 ] as NSDictionary
        let idDic = ["resumeId":self.resumeModel?.id ?? 0,"jobId":positionModel?.id ?? 0,"industryId":industryList[0].id ?? 0,"cityId":areaModel?.id as Any,"skills":"","salaryId":compensationModel?.id ?? 0,"id":self.jobIntensionId] as NSDictionary
        if self.enterState == .resumeEnterState || self.enterState == .loginEnterState  {
            saveOrUpdateDic = noIdDic
        }else if self.enterState == .updateEnterState
        {
            saveOrUpdateDic = idDic
        }
        print("saveOrUpdateDic = \(saveOrUpdateDic)")
        
        saveOrUpdateJobIntent(dic: saveOrUpdateDic, actionHander: { (jsonStr) in
            if jsonStr["code"] == 0{
              print("保存成功")
                //保存成功后发送通知首页横向滑动列表
                let noti = NSNotification.Name(rawValue: "ADDJobIntensionNoti")
                NotificationCenter.default.post(name: noti, object: nil)
                
                //判断添加是从哪里进入的添加求职意向（enterState）,若是简历中则传一个闭包
                if self.enterState == .resumeEnterState
                {
                    
                    if self.returnClosure != nil
                    {
                        self.returnClosure!()
                    }
                _ = self.navigationController?.popViewController(animated: true)
                    
                    
                }else if self.enterState == .loginEnterState{
                    //首次保存求职意向成功后进入首页
                    let vc = UIStoryboard(name: "UserFirstStoryboard", bundle: nil).instantiateViewController(withIdentifier: "HomePageVC") as! HomePageVC
                    let nav = UINavigationController.init(rootViewController: vc)
                    self.view.window?.rootViewController = nav
                }else if self.enterState == .updateEnterState {
                    if self.returnClosure != nil
                    {
                        self.returnClosure!()
                    }
                    _ = self.navigationController?.popViewController(animated: true)

                }
                
                
            }else{
              print("保存失败  \(jsonStr["msg"])")
              SVProgressHUD.showInfo(withStatus: jsonStr["msg"].stringValue)
                
            }
            
            
        }) { 
            SVProgressHUD.showInfo(withStatus: "请求失败")
        }
        
    }
    //获取简历
    func getUserResume() -> Void {
        searchUserResume(dic: ["token":GetUser(key: TOKEN)], actionHander: { (bassClass) in
           self.resumeModel = bassClass
            
        }) { 
            SVProgressHUD.showInfo(withStatus: "请求失败")
        }
    }
    
    //得到薪资范围
    func getCompensation() -> Void {
        getCompensationRange(dic: ["":""], actionHander: { (bassClass) in
            print("bassClass = \(bassClass)")
            self.compensationArray = bassClass.list!
            
        }) { 
            SVProgressHUD.showInfo(withStatus: "请求失败")
        }
    }
    //创建搜索框
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if section == 0 {
            return 3
        }else{
            return 2
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if indexPath.section == 0 {
            var cell = tableView.dequeueReusableCell(withIdentifier: "cell1")
            cell = UITableViewCell.init(style: .value1, reuseIdentifier: "cell1")
            cell?.textLabel?.font = UIFont.systemFont(ofSize: 14)
            cell?.detailTextLabel?.font = UIFont.systemFont(ofSize: 14)
            cell?.textLabel?.text = nameArray[indexPath.row]
            cell?.accessoryType = .disclosureIndicator
            if indexPath.row == 0 {
                cell?.detailTextLabel?.text = positionModel?.name
            }else if indexPath.row == 1 {
                cell?.detailTextLabel?.text = "选择了\(industryList.count)个标签"
            }else if indexPath.row == 2 {
                cell?.detailTextLabel?.text = areaModel?.name
            }
            return cell!
        }else{
            var cell = tableView.dequeueReusableCell(withIdentifier: "cell2")
            cell = UITableViewCell.init(style: .value1, reuseIdentifier: "cell2")
            cell?.textLabel?.font = UIFont.systemFont(ofSize: 14)
            cell?.detailTextLabel?.font = UIFont.systemFont(ofSize: 14)
            cell?.textLabel?.text = nameArray[indexPath.row+3]
            cell?.accessoryType = .disclosureIndicator
            if indexPath.row == 1 {
                cell?.detailTextLabel?.text = compensationModel?.name
            }
            return cell!
        }
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            if indexPath.row == 0 {
                let vc = UIStoryboard(name: "UserCenter", bundle: nil).instantiateViewController(withIdentifier: "UserTagVC") as! UserTagVC
                self.navigationController?.pushViewController(vc, animated: true)
            }else if indexPath.row == 1 {
                getCompensation()
                let actionSheet = UIAlertController(title: "薪资范围", message: "请选择薪资范围", preferredStyle: .actionSheet)
                for model in compensationArray {
                    let action = UIAlertAction.init(title: model.name, style: .default, handler: { (action) in
                        
                        self.compensationModel = model
                        self.tableView.reloadData()
                    })
                    actionSheet.addAction(action)
                    
                }
                let cancleAction = UIAlertAction(title: "取消", style: .cancel, handler: { (action) in
                    
                })
                actionSheet.addAction(cancleAction)
                
                self.present(actionSheet, animated: true, completion: nil)
                
            }
            
        }else if indexPath.section == 0 {
            if indexPath.row == 0 {

                let vc = UIStoryboard(name: "UserCenter", bundle: nil).instantiateViewController(withIdentifier: "ChoseIntensionVC") as! ChoseIntensionVC
                vc.TranslucentModel.returnClosure = { (model) in
                    print("model = \(model.name)")
                    self.positionModel = model
                    self.tableView.reloadData()
                }
                self.navigationController?.pushViewController(vc, animated: true)
            }else if indexPath.row == 1 {
                print("期望行业")
                let vc = UIStoryboard.init(name: "LoginAndUserStoryboard", bundle: nil).instantiateViewController(withIdentifier: "IndustryChoseVC") as! IndustryChoseVC
                vc.sureBtnClickClosure = { (listModelArray) in
                    print("选择了\(listModelArray)")
                    self.industryList = listModelArray
                    self.tableView.reloadData()
                }
                self.navigationController?.pushViewController(vc, animated: true)
            }else if indexPath.row == 2{
                if let customView = LQAreaPickView.newInstance() {
                    
                    let customAlert = JCAlertView.init(customView: customView, dismissWhenTouchedBackground: false)
                    
                    customAlert?.center = CGPoint.init(x: ScreenWidth/2, y: ScreenHeight - customView.frame.size.height/2-20)
                    customView.cancelbtnClickClosure = { (btn) in
                        customAlert?.dismiss(completion: nil)
                        
                    }
                    customView.sureBtnClickclosure = { (btn) in
                       
                        print("www")
//                        print("cityName = \(customView.cityNameStr) , cityId = \(customView.cityIDStr)")
//                        self.areaName = customView.cityNameStr
//                        self.areaId = customView.cityIDStr
                      //  self.cityTextField.text = "\(customView.provinceNameStr)\(customView.cityNameStr)"
                        self.areaModel = customView.selevtCityModel
                    
                        customAlert?.dismiss(completion: nil)
                        self.tableView.reloadData()
                    //    self.areaId = customView.cityIDStr
                    }
                    
                    customAlert?.show()
                    
                }

            }
            
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
