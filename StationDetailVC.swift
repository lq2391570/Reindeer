//
//  StationDetailVC.swift
//  Reindeer
//
//  Created by shiliuhua on 17/1/9.
//  Copyright © 2017年 shiliuhua. All rights reserved.
//

import UIKit
import JCAlertView
import SVProgressHUD
import SwiftyJSON
class StationDetailVC: BaseViewVC,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet var tableView: UITableView!
    
   //职位详情枚举（职位列表还是职位申请进入）
    enum StationEnterTypeNum {
        case stationListType //首页职位列表进入
        case userCommonInterViewListType //普通面试列表进入(待处理状态)
        case userCommonInterViewListApplyType  //普通面试列表进入（申请状态）
        case userCommonInterViewListWaitType  //普通面试等待中 （等待普通面试状态）
        case userVideoInterViewListWaitHandle //user视频面试待处理
        
        
    }
    var stationEnterType:StationEnterTypeNum = .stationListType
    
    var jobId = ""
    //职位详情model
    var jobDetailBassClass:JobDetailBaseClass?
    //简历
  //  var resumeBassClass:ResumeBaseClass?
    //个人信息json
    var userMesJson:JSON?
    var intentName = ""
    var intentId = ""
    //面试id
    var interfaceId = 0
    
    var returnClosure:(() -> ())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "职位详情"
        // Do any additional setup after loading the view.
        installTableView()
        getJobDetail()
        
//        //长按复制
//        let gestureRecognizer = UILongPressGestureRecognizer.init(target: self, action: #selector(pasteBoard(_:)))
//        
//        self.view.addGestureRecognizer(gestureRecognizer)

    }
//    func pasteBoard(_ longPress:UILongPressGestureRecognizer) -> Void {
//        if longPress.state == UIGestureRecognizerState.began {
//            let pasteboard = UIPasteboard.general
//            pasteboard.string = "需要复制的文本"
//        }
//    }
    //根据职位id获取职位详情
    
    func getJobDetail() -> Void {
        jobDetailInterface(dic: ["token":GetUser(key: TOKEN),"jobId":jobId], actionHander: { (bassClass) in
            self.jobDetailBassClass = bassClass
            self.tableView.reloadData()
        }) { 
            SVProgressHUD.showInfo(withStatus: "请求失败")
        }
    }
    
    //tableView设置
    func installTableView() -> Void {
        tableView.register(UINib.init(nibName: "StationFirstCell", bundle: nil), forCellReuseIdentifier: "StationFirstCell")
        tableView.register(UINib.init(nibName: "ScheduleCell", bundle: nil), forCellReuseIdentifier: "ScheduleCell")
        tableView.register(UINib.init(nibName: "StationDescripeCell", bundle: nil), forCellReuseIdentifier: "StationDescripeCell")
        tableView.register(UINib.init(nibName: "PublisherCell", bundle: nil), forCellReuseIdentifier: "PublisherCell")
        tableView.register(UINib.init(nibName: "CompanyCell", bundle: nil), forCellReuseIdentifier: "CompanyCell")
        tableView.register(UINib.init(nibName: "StationFirstCellNew", bundle: nil), forCellReuseIdentifier: "StationFirstCellNew")
        tableView.estimatedRowHeight = 80
        if self.stationEnterType == .stationListType {
            tableView.tableFooterView = bottomBtnForInterView()
        }else if self.stationEnterType == .userCommonInterViewListType {
            tableView.tableFooterView = bottomBtnForAgreeAndRefuse()
        }else if self.stationEnterType == .userCommonInterViewListApplyType {
            tableView.tableFooterView = bottomViewForApply(typeNum: 1)
        }else if self.stationEnterType == .userCommonInterViewListWaitType
        {
            tableView.tableFooterView = bottomViewForApply(typeNum: 2)
        }else if self.stationEnterType == .userVideoInterViewListWaitHandle {
            tableView.tableFooterView = bottomBtnForAgreeAndRefuse()
        }
    }
    
    //底部按钮（普通面试，视频面试）
    func bottomBtnForInterView() -> UIView {
        let view = UIView()
        view.frame = CGRect.init(x: 0, y: 0, width: tableView.frame.size.width, height: 50)
        //创建底部按钮（普通面试和视频面试）
        let leftBtn = UIButton(type: .custom)
        leftBtn.backgroundColor = UIColor.init(red: 223/255.0, green: 212/255.0, blue: 203/255.0, alpha: 1)
        leftBtn.addTarget(self, action: #selector(btnClick(_:)), for: .touchUpInside)
        leftBtn.setTitle("普通申请", for: .normal)
        leftBtn.setTitleColor(UIColor.black, for: .normal)
        leftBtn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        view.addSubview(leftBtn)
        let rightBtn = UIButton(type: .custom)
        rightBtn.backgroundColor = UIColor.black
        rightBtn.addTarget(self, action: #selector(videoInterviewClick(_:)), for: .touchUpInside)
        rightBtn.setTitle("视频申请", for: .normal)
        rightBtn.setTitleColor(UIColor.mainColor, for: .normal)
        rightBtn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        view.addSubview(rightBtn)
        leftBtn.snp.makeConstraints { (make) in
            make.left.equalTo(view.snp.left).offset(0)
            make.top.equalTo(view.snp.top).offset(0)
            make.width.equalTo(view.frame.width/2)
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
    //底部按钮（同意拒绝）
    func bottomBtnForAgreeAndRefuse() -> UIView {
        let view = UIView()
        view.frame = CGRect.init(x: 0, y: 0, width: tableView.frame.size.width, height: 50)
        //创建底部按钮（普通面试和视频面试）
        let leftBtn = UIButton(type: .custom)
        leftBtn.backgroundColor = UIColor.init(red: 223/255.0, green: 212/255.0, blue: 203/255.0, alpha: 1)
        leftBtn.addTarget(self, action: #selector(refuseBtnClick), for: .touchUpInside)
        leftBtn.setTitle("拒绝", for: .normal)
        leftBtn.setTitleColor(UIColor.black, for: .normal)
        leftBtn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        view.addSubview(leftBtn)
        let rightBtn = UIButton(type: .custom)
        rightBtn.backgroundColor = UIColor.black
        rightBtn.addTarget(self, action: #selector(agreeBtnClick), for: .touchUpInside)
        rightBtn.setTitle("同意", for: .normal)
        rightBtn.setTitleColor(UIColor.mainColor, for: .normal)
        rightBtn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        view.addSubview(rightBtn)
        leftBtn.snp.makeConstraints { (make) in
            make.left.equalTo(view.snp.left).offset(0)
            make.top.equalTo(view.snp.top).offset(0)
            make.width.equalTo(rightBtn.snp.width)
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
    //申请中
    func bottomViewForApply(typeNum:Int) -> UIView {
        let view = UIView()
        view.frame = CGRect.init(x: 0, y: 0, width: tableView.frame.size.width, height: 50)
        view.backgroundColor = UIColor.black
        let label = UILabel(frame: CGRect.init(x: 0, y: 0, width: 0, height: 0))
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor.lightGray
        if typeNum == 1 {
            label.text = "等待面试申请中"
        }else if typeNum == 2 {
            label.text = "等待普通面试中"
        }
        
        label.textAlignment = .center
        view.addSubview(label)
        
        label.snp.makeConstraints { (make) in
            make.left.equalTo(view.snp.left).offset(50)
            make.right.equalTo(view.snp.right).offset(-50)
            make.top.equalTo(view.snp.top).offset(10)
            make.bottom.equalTo(view.snp.bottom).offset(-10)
        }
        
        return view
    }
    
    func agreeBtnClick() -> Void {
         print("同意")
        userVideoApprovalAgreeOrRefuse(dic: ["token":GetUser(key: TOKEN),"id":self.interfaceId,"type":"0"], actionHander: { (jsonStr) in
            if jsonStr["code"] == 0 {
                print("成功")
                SVProgressHUD.showSuccess(withStatus: jsonStr["msg"].stringValue)
                if self.returnClosure != nil {
                    self.returnClosure!()
                }
                _ = self.navigationController?.popViewController(animated: true)
            }else{
                SVProgressHUD.showInfo(withStatus: jsonStr["msg"].stringValue)
            }
        }) { 
            SVProgressHUD.showInfo(withStatus: "请求失败")
        }
    }
    func refuseBtnClick() -> Void {
         print("拒绝")
        userVideoApprovalAgreeOrRefuse(dic: ["token":GetUser(key: TOKEN),"id":self.interfaceId,"type":"1"], actionHander: { (jsonStr) in
            if jsonStr["code"] == 0 {
                print("成功")
                SVProgressHUD.showSuccess(withStatus: jsonStr["msg"].stringValue)
                if self.returnClosure != nil {
                    self.returnClosure!()
                }
                
                _ = self.navigationController?.popViewController(animated: true)
            }else{
                SVProgressHUD.showInfo(withStatus: jsonStr["msg"].stringValue)
            }
        }) {
            SVProgressHUD.showInfo(withStatus: "请求失败")
        }

    }

    //普通面试
    func btnClick(_ sender: UIButton) {
        if let customView = CustomerInterviewView.newInstance() {
            customView.frame = CGRect.init(x: 0, y: 0, width: 260, height: 280)
            let customAlert = JCAlertView.init(customView: customView, dismissWhenTouchedBackground: true)
            customAlert?.show()
//            let userJsonDataArray:NSArray = GetUser(key: USERMES) as! NSArray
//         //   let userJson = NSKeyedUnarchiver.unarchiveObject(with: userJsonData as! Data) as! NSDictionary
//            let userJson:JSON = NSKeyedUnarchiver.unarchiveObject(with: userJsonDataArray.object(at: 0) as! Data) as! JSON
//            self.userMesJson = userJson
        
            customView.name = (self.userMesJson?["name"].stringValue)!
            customView.sex = (self.userMesJson?["sex"].stringValue)!
            customView.eduExp = (self.userMesJson?["edu"].stringValue)!
            customView.jobName = self.intentName
            customView.phoneNum = (self.userMesJson?["phone"].stringValue)!
            customView.cancelBtnClickClosure = { (sender) in
                print("点击了取消")
                customAlert?.dismiss(completion: nil)
            }
            customView.sureBtnClickClosure = { (sender) in
                print("点击了确定")
                print("name = \(customView.name),sex = \(customView.sex),eduExp = \(customView.eduExp),jobname = \(customView.jobName),phoneNum = \(customView.phoneNum),isOpenEmail=\(customView.isOpenEmail)")
                //是否开启email（0:开启，1不开启）
                var emailOpenLong = 0
                if customView.isOpenEmail == false {
                    emailOpenLong = 1
                }
                
                commonApplyInterface(dic: ["token":GetUser(key: TOKEN),"jobId":self.jobId,"intentId":self.intentId,"phone":customView.phoneNum,"email":emailOpenLong], actionHander: { (jsonStr) in
                    if jsonStr["code"] == 0 {
                        
                        customAlert?.dismiss(completion: {
                            //出现成功或失败（根据业务逻辑）
                            let succeedView = Bundle.main.loadNibNamed("SucceedView", owner: self, options: nil)?.last as! SucceedView
                            succeedView.frame = CGRect.init(x: 0, y: 0, width: 260, height: 320)
                            let succeedAlert = JCAlertView.init(customView: succeedView, dismissWhenTouchedBackground: true)
                            succeedAlert?.show()
                            succeedView.cancelBtnClickClsure = { (sender) in
                                print("取消")
                                succeedAlert?.dismiss(completion: nil)
                                SVProgressHUD.dismiss()
                            }
                            
                        })

                    }else{
                        customAlert?.dismiss(completion: {
                            SVProgressHUD.showInfo(withStatus: jsonStr["msg"].stringValue)
                        })
                        
                    }
                }, fail: { 
                    SVProgressHUD.showInfo(withStatus: "请求失败")
                })
                
                
            }
            
        }
    }
    //视频面试
    
     func videoInterviewClick(_ sender: UIButton) {
        print("视频面试")
        if let interFaceView = VideoInterfacePopView.newInstance() {
            interFaceView.frame = CGRect.init(x: 0, y: 0, width: 260, height: 280)
            let interFaceAlert = JCAlertView.init(customView: interFaceView, dismissWhenTouchedBackground: true)
            interFaceAlert?.show()
            interFaceView.listArray = (self.jobDetailBassClass?.interviewTimes)!
            interFaceView.cancelBtnClickClosure = { (sender) in
                print("点击了取消")
                interFaceAlert?.dismiss(completion: nil)
            }
            interFaceView.sureBtnClickClosure = { (sender,numOfSelectRow) in
                print("点击了确定")
                SVProgressHUD.show()
                
                guard numOfSelectRow != -1 else {
                    interFaceAlert?.dismiss(completion: {
                        SVProgressHUD.showInfo(withStatus: "请选择排期")
                        
                    })
                    
                    return
                }

                print("jobId = \(self.jobId),intentId = \(self.intentId),scheduleId = \(self.jobDetailBassClass?.interviewTimes?[numOfSelectRow].id ?? 0)")
                
                
                let scheduleId = self.jobDetailBassClass?.interviewTimes?[numOfSelectRow].id
                
                videoApplyInterface(dic: ["token":GetUser(key: TOKEN),"jobId":self.jobId,"intentId":self.intentId,"scheduleId":scheduleId!], actionHander: { (jsonStr) in
                    if jsonStr["code"] == 0 {
                        
                        interFaceAlert?.dismiss(completion: {
                            //出现成功或失败（根据业务逻辑）
                            let succeedView = Bundle.main.loadNibNamed("SucceedView", owner: self, options: nil)?.last as! SucceedView
                            succeedView.frame = CGRect.init(x: 0, y: 0, width: 260, height: 320)
                            let succeedAlert = JCAlertView.init(customView: succeedView, dismissWhenTouchedBackground: true)
                            succeedAlert?.show()
                            succeedView.cancelBtnClickClsure = { (sender) in
                                print("取消")
                                succeedAlert?.dismiss(completion: nil)
                                SVProgressHUD.dismiss()
                            }
                            
                        })

                    }else{
                        
                        interFaceAlert?.dismiss(completion: {
                            SVProgressHUD.showInfo(withStatus: jsonStr["msg"].stringValue)
                            
                        })
                        
                    }
                    
                }, fail: { 
                    SVProgressHUD.showInfo(withStatus: "请求失败")
                })
                
            }
            
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 300
        }else if indexPath.section == 1 {
            return 169
        }else if indexPath.section == 2{
            return UITableViewAutomaticDimension
        }else if indexPath.section == 3 {
            return 96
        }else if indexPath.section == 4 {
            return 148
        }
        return 0
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 5
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 5
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "StationFirstCellNew") as! StationFirstCellNew
            cell.selectionStyle = .none
            guard self.jobDetailBassClass != nil else {
                return cell
            }
            cell.installCell(jobName: self.jobDetailBassClass?.jobName, companyName: self.jobDetailBassClass?.companyName, money: self.jobDetailBassClass?.salary, area: self.jobDetailBassClass?.area, year: self.jobDetailBassClass?.exp, edu: self.jobDetailBassClass?.qualification, headImageName: self.jobDetailBassClass?.hrAvatar, HRName: self.jobDetailBassClass?.hrName,HRJobName:self.jobDetailBassClass?.hrJob, starNum: (self.jobDetailBassClass?.hrScore)!)
            cell.tagListView.removeAllTags()
            if self.jobDetailBassClass?.tags != nil {
                for tagStr in (self.jobDetailBassClass?.tags)! {
                    cell.tagListView.addTag(tagStr)
                }
            }
           
            //长按复制
//            let gestureRecognizer = UILongPressGestureRecognizer.init(target: self, action: #selector(pasteBoard(_:)))
//            
//            cell.jobNameLabel.addGestureRecognizer(gestureRecognizer)
            
            
                return cell
        }else if indexPath.section == 1{
            let cell = tableView.dequeueReusableCell(withIdentifier: "ScheduleCell") as! ScheduleCell
            cell.selectionStyle = .none
            guard self.jobDetailBassClass != nil else {
                return cell
            }
            cell.listArray = (self.jobDetailBassClass?.interviewTimes)!
            cell.interViewListTableView.reloadData()
            return cell
        }else if indexPath.section == 2{
            let cell = tableView.dequeueReusableCell(withIdentifier: "StationDescripeCell") as! StationDescripeCell
            guard self.jobDetailBassClass != nil else {
                return cell
            }
            cell.selectionStyle = .none
            cell.contentLabel.text = self.jobDetailBassClass?.desc
            cell.jiantouClickclosure = { btn in
                let index = IndexSet(integer: 2)
                self.tableView.reloadSections(index, with: .automatic)
            }
            
            return cell
        }else if indexPath.section == 3{
            let cell = tableView.dequeueReusableCell(withIdentifier: "PublisherCell") as! PublisherCell
            guard self.jobDetailBassClass != nil else {
                return cell
            }
            cell.selectionStyle = .none
            cell.hrNameLabel.text = "\(self.jobDetailBassClass?.hrName ?? "")|\(self.jobDetailBassClass?.hrJob ?? "")"
            cell.hrHeadImageView.sd_setImage(with: NSURL.init(string: (self.jobDetailBassClass?.hrAvatar)!)! as URL, placeholderImage: UIImage.init(named: "默认头像_男.png"))
            
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "CompanyCell") as! CompanyCell
            
            cell.selectionStyle = .none
            guard self.jobDetailBassClass != nil else {
                return cell
            }
            if self.jobDetailBassClass?.companyLogo != nil {
                 cell.companyImageView.sd_setImage(with: NSURL.init(string: (self.jobDetailBassClass?.companyLogo)!)! as URL, placeholderImage: nil)
            }
            cell.installCell(publishJobNum: NSNumber.init(value: (self.jobDetailBassClass?.jobsCount)!).stringValue, companyName: (self.jobDetailBassClass?.companyName)!, companyMes: "\(self.jobDetailBassClass?.companyIndustry ?? "") | \(self.jobDetailBassClass?.companyScale ?? "")", companyArea: (self.jobDetailBassClass?.address)!)
            
            return cell
        }
    }
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 5
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 4 {
            let vc = UIStoryboard.init(name: "UserFirstStoryboard", bundle: nil).instantiateViewController(withIdentifier: "CompanyDetailVC") as! CompanyDetailVC
            
            vc.inittCompanyMesWithId(intentId1: self.intentId, intentName1: self.intentName, userMesJson1: self.userMesJson!)
            //翻牌子动画
//            UIView.beginAnimations("View Flip", context: nil)
//            UIView.setAnimationDuration(0.8)
//            UIView.setAnimationCurve(.easeInOut)
//            UIView.setAnimationTransition(.flipFromRight, for: (self.navigationController?.view)!, cache: false)
            self.navigationController?.pushViewController(vc, animated: true)
         //   UIView.commitAnimations()
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
