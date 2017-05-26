//
//  TableViewVC.swift
//  Reindeer
//
//  Created by shiliuhua on 2017/5/12.
//  Copyright © 2017年 shiliuhua. All rights reserved.
//

import UIKit
import SwiftyJSON
import SVProgressHUD
class TableViewVC: UIViewController,UITableViewDelegate,UITableViewDataSource {

    /*普通面试状态（）HR state
     1.邀约中
     2.待面试
     5.待处理
     11.已完成
    */
    /*用户普通面试状态 User state
     1.申请中
     2.待面试
     8.待处理
     11.已完成
    */
    
    @IBOutlet var tableView: UITableView!
    
//    //应聘者或HR
//    enum HROrUserTypeEnum {
//        case HRType
//        case UserType
//    }
    //首页类型（HR或应聘者）
    enum HomepageType:Int {
        case userHomePage = 1 //普通用户
        case HRHomePage   //HR
    }
    
    var homeType:HomepageType = .userHomePage
    
    //列表分类
    enum TableViewDataType:Int {
        case waittingHandle = 1  //待处理
        case waittingInterFace //待面试
        case alreadyFinish //已结束
    }
    //HR
    var bassClass:CommonInterviewStateListBaseClass?
    //User (获取列表的bassClass)
    var userBassClass:UserCommonInterViewStateBaseClass?
    var pageNum1 = 1
    var pageNum2 = 1
    var pageNum3 = 1
    var jobId = ""
    var intentId = ""
    
    var dataType:TableViewDataType = .waittingHandle
    
    
    
    
  //  var roleType:HROrUserTypeEnum = .HRType
    
    //个人信息json
    var userMesJson:JSON?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib.init(nibName: "CommonInterViewCell1", bundle: nil), forCellReuseIdentifier: "CommonInterViewCell1")
        tableView.register(UINib.init(nibName: "CommonInterViewCell2", bundle: nil), forCellReuseIdentifier: "CommonInterViewCell2")
        tableView.register(UINib.init(nibName: "UserManagerInterViewCell", bundle: nil), forCellReuseIdentifier: "UserManagerInterViewCell")
        tableView.register(UINib.init(nibName: "UserApplyToInterViewCommonCell", bundle: nil), forCellReuseIdentifier: "UserApplyToInterViewCommonCell")
        tableView.register(UINib.init(nibName: "UserCommonWaitInterViewCell", bundle: nil), forCellReuseIdentifier: "UserCommonWaitInterViewCell")
        
        
        // Do any additional setup after loading the view.
        if self.homeType == .HRHomePage {
             getInterViewtype1(num: 1, type:self.dataType.rawValue)
        }else{
            UserGetInterViewtype1(num: 1, type: self.dataType.rawValue)
        }
       

    }
    
    
    //待处理列表(HR)
    func getInterViewtype1(num:Int,type:Int) -> Void {
        var pageNum = 1
        if self.dataType == .waittingHandle {
            //待处理
            pageNum = pageNum1
        }else if self.dataType == .waittingInterFace{
            //待面试
            pageNum = pageNum2
        }else if self.dataType == .alreadyFinish{
            //已结束
            pageNum = pageNum3
        }
        let dic:NSDictionary = [
            "token":GetUser(key: TOKEN),
            "no":pageNum,
            "size":100,
            "jobId":self.jobId,
            "type":type
        ]
        let jsonStr = JSON(dic)
        let newDic:NSDictionary = jsonStr.dictionaryValue as NSDictionary
        print("newDic = \(newDic)")
        interViewStateListInterFace(dic: newDic, actionHander: { (bassClass) in
            self.bassClass = bassClass
            self.tableView.reloadData()
        }) { 
            SVProgressHUD.showInfo(withStatus: "请求失败")
        }
    }
    //待处理列表（User）
    func UserGetInterViewtype1(num:Int,type:Int) -> Void {
        var pageNum = 1
        if self.dataType == .waittingHandle {
            //待处理
            pageNum = pageNum1
        }else if self.dataType == .waittingInterFace{
            //待面试
            pageNum = pageNum2
        }else if self.dataType == .alreadyFinish{
            //已结束
            pageNum = pageNum3
        }
        let dic:NSDictionary = [
            "token":GetUser(key: TOKEN),
            "no":pageNum,
            "size":10,
            "type":type
        ]
        let jsonStr = JSON(dic)
        let newDic:NSDictionary = jsonStr.dictionaryValue as NSDictionary
        print("newDic = \(newDic)")
        UserjobmanagerInterface(dic: newDic, actionHander: { (bassClass) in
            self.userBassClass = bassClass
            self.tableView.reloadData()
            
        }) { 
            SVProgressHUD.showInfo(withStatus: "请求失败")
        }
        
    }

    //获取待处理列表
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 1
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if self.homeType == .HRHomePage {
            
            let model:CommonInterviewStateListList = (self.bassClass?.list![indexPath.section])!
            
            if self.dataType == .waittingInterFace {
                let cell = tableView.dequeueReusableCell(withIdentifier: "CommonInterViewCell1") as! CommonInterViewCell1
                cell.selectionStyle = .none
                
                cell.installCell(jobName: model.jobName, state: "", headImageStr: model.avatar, name: model.name, money: model.salary, area: model.area, year: model.exp, edu: model.edu, interViewTime: model.time, interViewArea: model.address, isHiddenBtn: false, phoneClickClosure: { (sender) in
                    print("打电话")
                })
                return cell

            }
            
            
            
            if model.state == 1 {
                //邀约中
                let cell = tableView.dequeueReusableCell(withIdentifier: "CommonInterViewCell1") as! CommonInterViewCell1
                cell.selectionStyle = .none

                cell.installCell(jobName: model.jobName, state: "等待求职者处理", headImageStr: model.avatar, name: model.name, money: model.salary, area: model.area, year: model.exp, edu: model.edu, interViewTime: model.time, interViewArea: model.address, isHiddenBtn: true, phoneClickClosure: nil)
                return cell
                
            }else if model.state == 5 {
                //收到的申请
                let cell = tableView.dequeueReusableCell(withIdentifier: "CommonInterViewCell2") as! CommonInterViewCell2
                cell.selectionStyle = .none
                cell.installCell(jobName: model.jobName, stateName: "待处理", headImageStr: model.avatar, name: model.name, money: model.salary, area: model.area, year: model.exp, edu: model.edu)
                cell.refuseBtnClickClosure = { (btn) in
                    print("拒绝")
                }
                cell.agreeBtnClickClosure = { (btn) in
                    print("同意")
                }
                return cell
            }else{
                let cell = tableView.dequeueReusableCell(withIdentifier: "CommonInterViewCell1") as! CommonInterViewCell1
                cell.selectionStyle = .none
                return cell
            }

        }else{
            let model:UserCommonInterViewStateList = (self.userBassClass?.list![indexPath.section])!
            
            if self.dataType == .waittingInterFace {
                //待面试
                let cell = tableView.dequeueReusableCell(withIdentifier: "UserCommonWaitInterViewCell") as! UserCommonWaitInterViewCell
                
                cell.installCell(jobName: "\(model.name!)|\(model.company!)", state: "", headImageStr: model.avatar, name: "\(model.hrName!)|\(model.job!)", interViewTime: model.time, interViewAdress: model.address, phoneNum: model.phone)
                return cell
            }
            
            
            
            
            if model.state == 1 {
                //等待HR处理
                let cell = tableView.dequeueReusableCell(withIdentifier: "UserApplyToInterViewCommonCell") as! UserApplyToInterViewCommonCell
                
                cell.installCell(jobName: "\(model.name!)|\(model.company!)", stateName: "等待HR处理", headImageStr: model.avatar, name: "\(model.hrName!)|\(model.job!)")
                
                return cell
            }else if model.state == 8 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "UserManagerInterViewCell") as! UserManagerInterViewCell
                
                cell.installCell(jobName: "\(model.name!)|\(model.company!)", state: "待处理", headImageStr: model.avatar, name: "\(model.hrName!)|\(model.job!)", interViewTime: model.time, interViewAdress: model.address, phoneNum: model.phone, refuseClosure: { (btn) in
                    print("拒绝")
                    
                    createAlert(title: "提示", message: "是否要拒绝此面试", viewControll: self, closure: {
                        let dic:NSDictionary = [
                            "token":GetUser(key: TOKEN),
                            "id":model.id!,
                            "type":1
                        ]
                        let jsonStr = JSON(dic)
                        let newDic:NSDictionary = jsonStr.dictionary! as NSDictionary
                        UserInterViewAgreeOrRefuse(dic: newDic, actionHander: { (jsonStr) in
                            if jsonStr["code"] == 0 {
                                SVProgressHUD.showSuccess(withStatus: "拒绝成功")
                                self.UserGetInterViewtype1(num: 1, type: self.dataType.rawValue)
                            }else{
                                SVProgressHUD.showInfo(withStatus: jsonStr["msg"].stringValue)
                            }
                        }, fail: { 
                            SVProgressHUD.showInfo(withStatus: "请求失败")
                        })
                    })
                    
                }, agreseClosure: { (btn) in
                    print("同意")
                    
                    createAlert(title: "提示", message: "是否同意此面试邀请", viewControll: self, closure: { 
                        let dic:NSDictionary = [
                            "token":GetUser(key: TOKEN),
                            "id":model.id!,
                            "type":0
                        ]
                        let jsonStr = JSON(dic)
                        let newDic:NSDictionary = jsonStr.dictionary! as NSDictionary
                        UserInterViewAgreeOrRefuse(dic: newDic, actionHander: { (jsonStr) in
                            if jsonStr["code"] == 0 {
                                SVProgressHUD.showSuccess(withStatus: "同意此面试成功")
                                self.UserGetInterViewtype1(num: 1, type: self.dataType.rawValue)
                            }else{
                                SVProgressHUD.showInfo(withStatus: jsonStr["msg"].stringValue)
                            }
                        }, fail: {
                            SVProgressHUD.showInfo(withStatus: "请求失败")
                        })

                    })
                    
                })
                return cell
            }else{
                let cell = tableView.dequeueReusableCell(withIdentifier: "UserManagerInterViewCell") as! UserManagerInterViewCell
                return cell
            }
            
            
        }
        
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if homeType == .HRHomePage {
            let model:CommonInterviewStateListList = (self.bassClass?.list![indexPath.section])!
            if self.dataType == .waittingInterFace {
                
                let vc = UIStoryboard.init(name: "UserFirstStoryboard", bundle: nil).instantiateViewController(withIdentifier: "ResumeDetailVC") as! ResumeDetailVC
                
                vc.intentId = NSNumber.init(value: (model.intentId)!).stringValue
                
                vc.jobId = self.jobId
                
                vc.resumeId = NSNumber.init(value: (model.resumeId)!).stringValue
                
                print("intentId = \(model.intentId), jobId = \(self.jobId),resumeId = \(model.resumeId)")
                //这个json是存储个人信息的，下个页面取到公司id使用
                vc.userMesJson = self.userMesJson
                vc.resumeDetailType = .alreadyAgree
                
                self.navigationController?.pushViewController(vc, animated: true)
            }
            
            if model.state == 1 {
                //邀约中
                let vc = UIStoryboard.init(name: "UserFirstStoryboard", bundle: nil).instantiateViewController(withIdentifier: "ResumeDetailVC") as! ResumeDetailVC
                
                vc.intentId = NSNumber.init(value: (model.intentId)!).stringValue
                
                vc.jobId = self.jobId
                
                vc.resumeId = NSNumber.init(value: (model.resumeId)!).stringValue
                
                print("intentId = \(model.intentId), jobId = \(self.jobId),resumeId = \(model.resumeId)")
                //这个json是存储个人信息的，下个页面取到公司id使用
                vc.userMesJson = self.userMesJson
                vc.resumeDetailType = .pending
                self.navigationController?.pushViewController(vc, animated: true)
                
            }else if model.state == 5 {
                //收到的申请
                let vc = UIStoryboard.init(name: "UserFirstStoryboard", bundle: nil).instantiateViewController(withIdentifier: "ResumeDetailVC") as! ResumeDetailVC
                
                vc.intentId = NSNumber.init(value: (model.intentId)!).stringValue
                
                vc.jobId = self.jobId
                
                vc.resumeId = NSNumber.init(value: (model.resumeId)!).stringValue
                print("intentId = \(model.intentId), jobId = \(self.jobId),resumeId = \(model.resumeId)")
                //这个json是存储个人信息的，下个页面取到公司id使用
                vc.userMesJson = self.userMesJson
                vc.resumeDetailType = .applyIng
                self.navigationController?.pushViewController(vc, animated: true)
                
            }

        }else{
            //用户端
            let model:UserCommonInterViewStateList = (self.userBassClass?.list![indexPath.section])!
            let vc = UIStoryboard(name: "UserFirstStoryboard", bundle: nil).instantiateViewController(withIdentifier: "StationDetailVC") as! StationDetailVC
            vc.userMesJson = self.userMesJson
            
            vc.intentName = model.name!
            //求职意向id
            vc.intentId = self.intentId
            //职位id
            
            vc.jobId = NSNumber.init(value: model.jobId!).stringValue
            
            if model.state == 1 {
                vc.stationEnterType = .userCommonInterViewListApplyType
            }else if model.state == 8 {
                vc.stationEnterType = .userCommonInterViewListType
            }
            if self.dataType == .waittingInterFace {
                vc.stationEnterType = .userCommonInterViewListWaitType
            }
            
            self.navigationController?.pushViewController(vc, animated: true)
            
        }
        
    }
    func numberOfSections(in tableView: UITableView) -> Int
    {
        if homeType == .HRHomePage {
            if self.bassClass == nil {
                return 0
            }
            return (self.bassClass?.list?.count)!
        }else{
            if self.userBassClass == nil {
                return 0
            }
            return (self.userBassClass?.list?.count)!
        }
       
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if homeType == .HRHomePage {
            return 226
        }else{
             let model:UserCommonInterViewStateList = (self.userBassClass?.list![indexPath.section])!
            
            if self.dataType == .waittingInterFace {
                return 205
            }
            if model.state == 1 {
                return 120
            }else if model.state == 8 {
                return 250
            }
           return 120
        }
      
        
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
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
