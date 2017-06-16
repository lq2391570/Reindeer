//
//  ResumeDetailVC.swift
//  Reindeer
//
//  Created by shiliuhua on 2017/5/9.
//  Copyright © 2017年 shiliuhua. All rights reserved.
//

import UIKit
import SwiftyJSON
import SVProgressHUD
import JCAlertView
class ResumeDetailVC: BaseViewVC,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet var tableView: UITableView!
    
    //简历详情底部按钮及状态显示（是否是申请中及其他）
    enum BottomBtnAndLogicType {
        case custom //普通
        case applyIng //收到申请中（底部按钮为拒绝和同意）
        case pending //邀约中 （底部为等待求职者处理状态）
        case alreadyAgree //求职者已同意面试 （底部为等待求职者面试）
    }
    
    //简历详情类型
    var resumeDetailType:BottomBtnAndLogicType = .custom
    
    
    //简历id
    var resumeId:String?
    //求职意向id
    var intentId:String?
    //职位id
    var jobId:String?
    
    //个人信息json
    var userMesJson:JSON?
    //公司详情model
    var companyDetailModel:CompanyDetail2BaseClass?
    
    
    var resumeDetailBassClass:ResumeHRBaseClass?
    //面试时间(部分)
    var interFaceTime = ""
    //面试时间（全部）
    var interFaceTimeAll = ""
    
    //地址
    var companyArea = ""
    //公司电话
    var phoneNumStr = ""
    //职位详情model
    var jobDetailBassClass:JobDetailBaseClass?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "简历详情"
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib.init(nibName: "ResumeDetailCell", bundle: nil), forCellReuseIdentifier: "ResumeDetailCell")
        tableView.register(UINib.init(nibName: "ResumeDetailCell1", bundle: nil), forCellReuseIdentifier: "ResumeDetailCell1")
        tableView.register(UINib.init(nibName: "WorkExpCell", bundle: nil), forCellReuseIdentifier: "WorkExpCell")
        tableView.register(UINib.init(nibName: "EduExpCell", bundle: nil), forCellReuseIdentifier: "EduExpCell")
        tableView.register(UINib.init(nibName: "ResumeStateCell", bundle: nil), forCellReuseIdentifier: "ResumeStateCell")
        tableView.register(UINib.init(nibName: "ResumeStateCell2", bundle: nil), forCellReuseIdentifier: "ResumeStateCell2")
        if self.resumeDetailType == .custom {
            tableView.tableFooterView = createBottomBtn()
        }else if self.resumeDetailType == .pending {
            tableView.tableFooterView = createBottomViewPending(typeNum: 1)
        }else if self.resumeDetailType == .applyIng {
            tableView.tableFooterView = createAgreeBtnAndFefuseBtn()
        }else if self.resumeDetailType == .alreadyAgree {
            tableView.tableFooterView = createBottomViewPending(typeNum: 2)
        }
        
        // Do any additional setup after loading the view.
        getResumeDetail()
        companyDetail()
        initInterFaceTime()
        getJobDetail()
    }
    //初始化面试时间
    func initInterFaceTime() -> Void {
        let currentDate = NSDate()
        self.interFaceTimeAll = dateTransformUnixStr(date: currentDate as Date)
    }
    //获得视频面试的排期（通过HR发布的职位id）
    func getJobDetail() -> Void {
        jobDetailInterface(dic: ["token":GetUser(key: TOKEN),"jobId":jobId!], actionHander: { (bassClass) in
            self.jobDetailBassClass = bassClass
            self.tableView.reloadData()
        }) {
            SVProgressHUD.showInfo(withStatus: "请求失败")
        }
    }

    //普通邀约
    func commonInvite(succeed:@escaping () ->Void,fail:@escaping (_ failReson:String) ->Void) -> Void {
        if self.interFaceTime != "" {
            let nowDate = NSDate()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy"
            let nowDateStr = dateFormatter.string(from: nowDate as Date)
            let newDateStr = "\(nowDateStr)\(self.interFaceTime)"
            print("newDateStr = \(newDateStr)")
            self.interFaceTimeAll = timeStrTransformUnix(timeStr: newDateStr)
            print("self.interFaceTimeAll = \(self.interFaceTimeAll)")
        }
        
        let dic = [
            "token":GetUser(key: TOKEN),
            "jobId":self.jobId as Any,
            "resumeId":self.resumeId as Any,
            "intentId":self.intentId as Any,
            "datetime":self.interFaceTimeAll,
            "address":self.companyArea,
            "phone":self.phoneNumStr
        ]
        
        let dicJson = JSON(dic)
        let newDic:NSDictionary = dicJson.dictionary! as NSDictionary
        print("newDic = \(newDic)")
        commonInviteInterface(dic: newDic, actionHander: { (jsonStr) in
            if jsonStr["code"] == 0 {
                succeed()
            }else{
                fail(jsonStr["msg"].stringValue)
            }
            
        }) { 
            SVProgressHUD.showInfo(withStatus: "请求失败")
        }
    }
    
    //获取公司信息（邀约时的默认地址和电话）
    func companyDetail() -> Void {
        let companyId = userMesJson?["companyId"].stringValue
        
        getCompanyDetail(dic: ["companyId":companyId as Any], actionHandler: { (bassClass) in
            self.companyDetailModel = bassClass
        }) { 
            SVProgressHUD.showInfo(withStatus: "请求失败")
        }
        
    }
    
    
    //获取简历详情
    func getResumeDetail() -> Void {
        
//        let dic:NSDictionary = [
//            "token":GetUser(key: TOKEN),
//            "resumeId":self.resumeId as Any,   // 简历id
//            "intentId":self.intentId as Any,   //求职意向id
//            "jobId":self.jobId as Any          //职位id
//        ]
                let dic:NSDictionary = [
                    "token":GetUser(key: TOKEN),
                    "resumeId":self.resumeId!,   // 简历id
                    "intentId":self.intentId!,   //求职意向id
                    "jobId":self.jobId!          //职位id
                ]

        let dicJson = JSON(dic)
        
        let NewDic:NSDictionary = dicJson.dictionary! as NSDictionary
        print("NewDic = \(NewDic)")
        
        HRHomepageResumeDetailInterface(dic: NewDic, actionHander: { (bassClass) in
            
            self.resumeDetailBassClass = bassClass
            self.tableView.reloadData()
            
        }) { 
            SVProgressHUD.showInfo(withStatus: "请求失败")
        }
    }
    
    //底部按钮（custom情况）
    func createBottomBtn() -> UIView {
        let view = UIView()
        view.frame = CGRect.init(x: 0, y: 0, width: tableView.frame.size.width, height: 50)
        //创建底部按钮（普通邀约和视频邀约）
        let leftBtn = UIButton(type: .custom)
        leftBtn.backgroundColor = UIColor.init(red: 223/255.0, green: 212/255.0, blue: 203/255.0, alpha: 1)
        leftBtn.addTarget(self, action: #selector(leftBtnClick), for: .touchUpInside)
        leftBtn.setTitle("普通邀约", for: .normal)
        leftBtn.setTitleColor(UIColor.black, for: .normal)
        leftBtn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        view.addSubview(leftBtn)
        let rightBtn = UIButton(type: .custom)
        rightBtn.backgroundColor = UIColor.init(red: 194/255.0, green: 174/255.0, blue: 158/255.0, alpha: 1)
        rightBtn.addTarget(self, action: #selector(rightBtnClick), for: .touchUpInside)
        rightBtn.setTitle("视频邀约", for: .normal)
        rightBtn.setTitleColor(UIColor.black, for: .normal)
        rightBtn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        view.addSubview(rightBtn)
        leftBtn.snp.makeConstraints { (make) in
            make.left.equalTo(view.snp.left).offset(0)
            make.top.equalTo(view.snp.top).offset(0)
            make.width.equalTo(150)
            make.bottom.equalTo(view.snp.bottom).offset(0)
        }
        rightBtn.snp.makeConstraints { (make) in
            make.left.equalTo(leftBtn.snp.right).offset(0)
            make.right.equalTo(view.snp.right).offset(0)
            make.bottom.equalTo(view.snp.bottom).offset(0)
            make.top.equalTo(view.snp.top).offset(0)
        }
        return view
    }
    //底部状态（等待求职者处理）
    func createBottomViewPending(typeNum:Int) -> UIView {
        let view = UIView(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.size.width, height: 50))
        view.backgroundColor = UIColor.init(red: 223/255.0, green: 212/255.0, blue: 203/255.0, alpha: 1)
        let label = UILabel(frame: CGRect.init(x: tableView.frame.size.width/2-100, y: 10, width: 200, height: 30))
        if typeNum == 1 {
            label.text = "等待求职者处理"
        }else if typeNum == 2 {
            label.text = "等待求职者面试"
        }
        
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor.black
        label.textAlignment = .center
        view.addSubview(label)
        return view
    }
    //底部状态（收到申请中，底部为同意或拒绝）
    func createAgreeBtnAndFefuseBtn() -> UIView {
        let view = UIView(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.size.width, height: 50))
        let refuseBtn = UIButton(type: .custom)
        refuseBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        refuseBtn.setTitle("拒绝", for: .normal)
        refuseBtn.backgroundColor = UIColor.init(red: 223/255.0, green: 212/255.0, blue: 203/255.0, alpha: 1)
        refuseBtn.setTitleColor(UIColor.black, for: .normal)
        refuseBtn.addTarget(self, action: #selector(refuseBtnClick), for: .touchUpInside)
        
        view.addSubview(refuseBtn)
        let agreeBtn = UIButton(type: .custom)
        agreeBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        agreeBtn.setTitle("同意", for: .normal)
        agreeBtn.addTarget(self, action: #selector(agreeBtnClick), for: .touchUpInside)
        agreeBtn.backgroundColor = UIColor.init(red: 195/255.0, green: 174/255.0, blue: 158/255.0, alpha: 1)
        agreeBtn.setTitleColor(UIColor.black, for: .normal)
        view.addSubview(agreeBtn)
        refuseBtn.snp.makeConstraints { (make) in
            make.left.equalTo(view.snp.left).offset(0)
            make.top.equalTo(view.snp.top).offset(0)
            make.bottom.equalTo(view.snp.bottom).offset(0)
            make.width.equalTo(150)
        }
        agreeBtn.snp.makeConstraints { (make) in
            make.left.equalTo(refuseBtn.snp.right).offset(0)
            make.top.equalTo(view.snp.top).offset(0)
            make.bottom.equalTo(view.snp.bottom).offset(0)
            make.right.equalTo(view.snp.right).offset(0)
        }
        
        return view
        
    }
    func refuseBtnClick() -> Void {
        print("点击拒绝")
        let dic:NSDictionary = [
            "token":GetUser(key: TOKEN),
            "jobId":self.jobId!,
            "resumeId":self.resumeId!,
            "type":1,   //1拒绝 0 同意
            "datetime":self.interFaceTimeAll, //面试时间
            "phone":self.phoneNumStr,   //联系方式
            "address":self.companyArea
        ]
        let jsonDic = JSON(dic)
        let newDic:NSDictionary = jsonDic.dictionary! as NSDictionary
        
        commonInterViewAgreeOfRefuseInterface(dic: newDic, actionHander: { (jsonStr) in
            if jsonStr["code"] == 0 {
                SVProgressHUD.showSuccess(withStatus: "拒绝成功")
            }else{
                SVProgressHUD.showInfo(withStatus: jsonStr["msg"].stringValue)
            }
            
            
        }) { 
            SVProgressHUD.showInfo(withStatus: "请求失败")
        }
        
    }
    func agreeBtnClick() -> Void {
        //同意后弹框
        print("点击同意")
        
        if let customView = CustomerInterviewView.newInstance() {
            customView.frame = CGRect.init(x: 0, y: 0, width: 260, height: 280)
            let customAlert = JCAlertView.init(customView: customView, dismissWhenTouchedBackground: true)
            customAlert?.show()
            
            customView.viewTypeStyle = .interViewInvite
            customView.interfaceArea = (self.companyDetailModel?.address)!
            customView.phoneNum = (self.companyDetailModel?.tel)!
            customView.timeStr = self.interFaceTime
            customView.pickViewDelegateClosure = { (timeChoseStr) in
                self.interFaceTime = timeChoseStr
            }
            customView.textFieldChangeClosure = { (textfield) in
                self.phoneNumStr = textfield.text!
            }
            customView.cancelBtnClickClosure = { (sender) in
                print("点击了取消")
                customAlert?.dismiss(completion: nil)
            }
            customView.sureBtnClickClosure = { (sender) in
                print("点击了确定")
                
                customAlert?.dismiss(completion: {
                    //出现成功或失败（根据业务逻辑）
                    
                    
                    self.commonInvite(succeed: {
                        let succeedView = Bundle.main.loadNibNamed("SucceedView", owner: self, options: nil)?.last as! SucceedView
                        succeedView.frame = CGRect.init(x: 0, y: 0, width: 260, height: 320)
                        succeedView.mesLabel.text = "邀约成功，请耐心等待回应"
                        let succeedAlert = JCAlertView.init(customView: succeedView, dismissWhenTouchedBackground: true)
                        succeedAlert?.show()
                        succeedView.cancelBtnClickClsure = { (sender) in
                            print("取消")
                            succeedAlert?.dismiss(completion: nil)
                            SVProgressHUD.dismiss()
                        }
                        
                    }, fail: { (failResonStr) in
                        SVProgressHUD.showInfo(withStatus: failResonStr)
                    })
                    
                    
                })
            }
            
        }

        
        
        
        
    }
    
    
    func leftBtnClick() -> Void {
        //普通邀约
        if let customView = CustomerInterviewView.newInstance() {
            customView.frame = CGRect.init(x: 0, y: 0, width: 260, height: 280)
            let customAlert = JCAlertView.init(customView: customView, dismissWhenTouchedBackground: true)
            customAlert?.show()
            
            customView.viewTypeStyle = .interViewInvite
            customView.interfaceArea = (self.companyDetailModel?.address)!
            customView.phoneNum = (self.companyDetailModel?.tel)!
            customView.timeStr = self.interFaceTime
            customView.pickViewDelegateClosure = { (timeChoseStr) in
                self.interFaceTime = timeChoseStr
            }
            customView.textFieldChangeClosure = { (textfield) in
                self.phoneNumStr = textfield.text!
            }
            customView.cancelBtnClickClosure = { (sender) in
                print("点击了取消")
                customAlert?.dismiss(completion: nil)
            }
            customView.sureBtnClickClosure = { (sender) in
                print("点击了确定")
                
                customAlert?.dismiss(completion: {
                    //出现成功或失败（根据业务逻辑）
                    
                    
                    self.commonInvite(succeed: { 
                        let succeedView = Bundle.main.loadNibNamed("SucceedView", owner: self, options: nil)?.last as! SucceedView
                        succeedView.frame = CGRect.init(x: 0, y: 0, width: 260, height: 320)
                        succeedView.mesLabel.text = "邀约成功，请耐心等待回应"
                        let succeedAlert = JCAlertView.init(customView: succeedView, dismissWhenTouchedBackground: true)
                        succeedAlert?.show()
                        succeedView.cancelBtnClickClsure = { (sender) in
                            print("取消")
                            succeedAlert?.dismiss(completion: nil)
                            SVProgressHUD.dismiss()
                        }

                    }, fail: { (failResonStr) in
                        SVProgressHUD.showInfo(withStatus: failResonStr)
                    })
                    
                    
                })
            }
            
        }
        
        
    }
    func rightBtnClick() -> Void {
        //视频邀约
        //判断是否有排期
        guard self.jobDetailBassClass != nil else {
            SVProgressHUD.showInfo(withStatus: "本职位暂无排期")
            return
        }
        
        guard (self.jobDetailBassClass?.interviewTimes)!.count != 0  else {
            SVProgressHUD.showInfo(withStatus: "本职位暂无排期")
            return
        }
        
        
        if let interFaceView = VideoInterfacePopView.newInstance() {
            interFaceView.frame = CGRect.init(x: 0, y: 0, width: 260, height: 280)
            let interFaceAlert = JCAlertView.init(customView: interFaceView, dismissWhenTouchedBackground: true)
            interFaceAlert?.show()
            interFaceView.titleLabel.text = "视频邀约"
            interFaceView.listArray = (self.jobDetailBassClass?.interviewTimes)!
            interFaceView.cancelBtnClickClosure = { (sender) in
                print("点击了取消")
                interFaceAlert?.dismiss(completion: nil)
            }
            interFaceView.sureBtnClickClosure = { (sender,numOfSelectRow) in
                print("点击了确定")
                guard numOfSelectRow != -1 else {
                    interFaceAlert?.dismiss(completion: {
                        SVProgressHUD.showInfo(withStatus: "请选择排期")
                        
                    })
                    
                    return
                }
            }
        }
    
}
    
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        
            switch section {
            case 0:
                return 1
            case 1:
                if self.resumeDetailType == .custom {
                    return 0
                }
                return 1
            case 2:
                return 1
            case 3:
                if self.resumeDetailBassClass == nil || (self.resumeDetailBassClass?.exps?.count)! == 0 {
                    return 1
                }
                return (self.resumeDetailBassClass?.exps?.count)!
            case 4:
                if self.resumeDetailBassClass == nil || (self.resumeDetailBassClass?.edus?.count)! == 0 {
                    return 1
                }
                return (self.resumeDetailBassClass?.edus?.count)!
            default:
                break
            }
            return 0

    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
      
            let model = self.resumeDetailBassClass
            if indexPath.section == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "ResumeDetailCell1") as! ResumeDetailCell1
                
                guard model != nil else {
                    return cell
                }
                cell.installCell(headImageStr: model?.avatar, nameAndJobStr:model?.name , moneyStr: model?.salary, areaStr: model?.area, expYearStr: model?.exp, eduStr: model?.edu)
                cell.tagListView.removeAllTags()
                
                for tagName in (model?.tags)! {
                    if tagName != "" {
                        cell.tagListView.addTag(tagName)
                    }
                    
                }
               
                return cell
            }else if indexPath.section == 1 {
                if self.resumeDetailType == .applyIng {
                    //收到申请中
                    let cell = tableView.dequeueReusableCell(withIdentifier: "ResumeStateCell") as! ResumeStateCell
                    cell.contactWayLabel.text = "联系电话:\(self.phoneNumStr)"
                    
                    return cell
                }else if self.resumeDetailType == .pending{
                    //邀约中
                    let cell = tableView.dequeueReusableCell(withIdentifier: "ResumeStateCell2") as! ResumeStateCell2
                    cell.interViewTimeLabel.text = "面试时间:"
                    cell.interViewAreaLabel.text = "面试地点:\(companyArea)"
                    return cell
                   
                }else{
                    let cell = tableView.dequeueReusableCell(withIdentifier: "ResumeStateCell2") as! ResumeStateCell2
                    return cell
                }
            }else if indexPath.section == 2{
                let cell = tableView.dequeueReusableCell(withIdentifier: "ResumeDetailCell") as! ResumeDetailCell
                cell.neiRongLabel.text = model?.advantage
                
                return cell
            }else if indexPath.section == 3 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "WorkExpCell") as! WorkExpCell
                
                guard model != nil else {
                    return cell
                }
                guard model?.exps?.count != 0 else {
                    return cell
                }
                let expModel = model?.exps?[indexPath.row]
                let dateStr = unixTransformtimeStr(unixStr: NSNumber.init(value: (expModel?.startDate)!), dateStyle: "yyyy.mm")
                var endDateStr = ""
                if expModel?.endDate == nil {
                    endDateStr = "至今"
                }else{
                    endDateStr = unixTransformtimeStr(unixStr: NSNumber.init(value: (expModel?.endDate)!), dateStyle: "yyyy.mm")
                }
                
                cell.installCell(companyNameStr: expModel?.companyName, timeStr: "\(dateStr)-\(endDateStr)", jobDetailStr: expModel?.jobName, workExpStr: expModel?.jobName, workDetailStr: (expModel?.jobContent)!)
                
                return cell
                
            }else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "EduExpCell") as! EduExpCell
                
                guard model != nil else {
                    return cell
                }
                guard model?.edus?.count != 0 else {
                    return cell
                }
                let eduModel = model?.edus?[indexPath.row]
                let dateStr = unixTransformtimeStr(unixStr: NSNumber.init(value: (eduModel?.startDate)!), dateStyle: "yyyy.mm")
                var endDateStr = ""
                if eduModel?.endDate == nil {
                    endDateStr = "至今"
                }else{
                    endDateStr = unixTransformtimeStr(unixStr: NSNumber.init(value: (eduModel?.endDate)!), dateStyle: "yyyy.mm")
                }
                cell.installCell(schoolNameStr: eduModel?.school, timeStr: "\(dateStr)-\(endDateStr)", proStr: "\(eduModel?.profession ?? "")|\(eduModel?.qualificationsNme ?? "")", schoolExpStr: eduModel?.schoolExp)
                
                return cell
                
            }

   }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 250
        }else{
            return 140
        }
    }
    func numberOfSections(in tableView: UITableView) -> Int
    {
            return 5
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
