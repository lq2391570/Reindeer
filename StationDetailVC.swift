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
class StationDetailVC: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet var tableView: UITableView!
    
    @IBOutlet var leftBtn: UIButton!
    
    @IBOutlet var rightBtn: UIButton!
    
    var jobId = ""
    //职位详情model
    var jobDetailBassClass:JobDetailBaseClass?
    //简历
  //  var resumeBassClass:ResumeBaseClass?
    //个人信息json
    var userMesJson:JSON?
    var intentName = ""
    var intentId = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "职位详情"
        // Do any additional setup after loading the view.
        installTableView()
        getJobDetail()
    }
    
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
        tableView.estimatedRowHeight = 80
    }
    //普通面试
    @IBAction func btnClick(_ sender: UIButton) {
        if let customView = CustomerInterviewView.newInstance() {
            customView.frame = CGRect.init(x: 0, y: 0, width: 260, height: 280)
            let customAlert = JCAlertView.init(customView: customView, dismissWhenTouchedBackground: true)
            customAlert?.show()
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
    
    @IBAction func videoInterviewClick(_ sender: UIButton) {
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
            return 69
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
            let cell = tableView.dequeueReusableCell(withIdentifier: "StationFirstCell") as! StationFirstCell
            cell.selectionStyle = .none
            guard self.jobDetailBassClass != nil else {
                return cell
            }
            cell.installCell(jobName: (self.jobDetailBassClass?.jobName)!, companyName: (self.jobDetailBassClass?.companyName)!, payRange: (self.jobDetailBassClass?.salary)!, area: (self.jobDetailBassClass?.area)!, yearRange: (self.jobDetailBassClass?.exp)!, edu: (self.jobDetailBassClass?.qualification)!)
            
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
            cell.companyImageView.sd_setImage(with: NSURL.init(string: (self.jobDetailBassClass?.companyLogo)!)! as URL, placeholderImage: nil)
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
