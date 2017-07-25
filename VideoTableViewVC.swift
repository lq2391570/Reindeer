//
//  VideoTableViewVC.swift
//  Reindeer
//
//  Created by shiliuhua on 2017/5/19.
//  Copyright © 2017年 shiliuhua. All rights reserved.
//

import UIKit
import SwiftyJSON
import SVProgressHUD
import NIMSDK
import MJRefresh

class VideoTableViewVC: UIViewController,UITableViewDelegate,UITableViewDataSource {

    /*
    HR端视频面试状态
     3.邀约中
     4.待面试
     6.待处理
     8.未到面试时间
     9.开始面试
     10.结束面试
     12.已完成
     13.未面试
    */
    
    /*
      用户端视频面试状态
     3.申请中
     4.待面试
     5.未到准备时间
     6.可以准备就绪
     7.已准备就绪
     9.待处理
     12.已完成
     13.已评价
     14.未评价
    */
 
    //首页类型（HR或应聘者）
    enum HomepageType:Int {
        case userHomePage = 1 //普通用户
        case HRHomePage   //HR
    }
    
    var homeType:HomepageType = .userHomePage
    //个人信息json
    var userMesJson:JSON?
    //列表分类
    enum TableViewDataType:Int {
        case waittingHandle = 1  //待处理
        case waittingInterFace //待面试
        case alreadyFinish //已结束
        case didNotInterView //未面试
    }
    //HR
    var bassClass:HRVideoInterViewStateBaseClass?
    //user
    var userBassClass:UserVideoInterfaceBaseClass?
    
    var pageNum1 = 1
    var pageNum2 = 1
    var pageNum3 = 1
    var pageNum4 = 1
    var jobId = ""
    var intentId = ""
    
    var dataType:TableViewDataType = .waittingHandle
    
    //顶部刷新
    var header = MJRefreshGifHeader()
    //底部刷新
    let footer = MJRefreshAutoFooter()
    

    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib.init(nibName: "HRVideoWaitToManagerCell", bundle: nil), forCellReuseIdentifier: "HRVideoWaitToManagerCell")
        tableView.register(UINib.init(nibName: "HRVideoWaitUserManagerCell", bundle: nil), forCellReuseIdentifier: "HRVideoWaitUserManagerCell")
        tableView.register(UINib.init(nibName: "HRVideoAlreadyFinishCell", bundle: nil), forCellReuseIdentifier: "HRVideoAlreadyFinishCell")
        tableView.register(UINib.init(nibName: "HRVideoWaitInterViewCell1", bundle: nil), forCellReuseIdentifier: "HRVideoWaitInterViewCell1")
        tableView.register(UINib.init(nibName: "HRVideoWaitInterViewCell2", bundle: nil), forCellReuseIdentifier: "HRVideoWaitInterViewCell2")
        
        tableView.register(UINib.init(nibName: "UserVideoWaitManagerCell", bundle: nil), forCellReuseIdentifier: "UserVideoWaitManagerCell")
        tableView.register(UINib.init(nibName: "UserVideoWaitHRCell", bundle: nil), forCellReuseIdentifier: "UserVideoWaitHRCell")
        
        
        
        
        
        if homeType == .HRHomePage {
            HRGetVideoInterViewList(num: 1, type: self.dataType.rawValue)
            self.tableView.mj_header = setUpMJHeader(refreshingClosure: {
                self.HRGetVideoInterViewList(num: 1, type: self.dataType.rawValue)
            })
        }else{
            
            UserGetVideoInterViewList(num: 1, type: self.dataType.rawValue)
            self.tableView.mj_header = setUpMJHeader(refreshingClosure: { 
                self.UserGetVideoInterViewList(num: 1, type: self.dataType.rawValue)
            })
            
        }
        
        // Do any additional setup after loading the view.
    }
    //获得视频待处理面试列表（HR）
    func HRGetVideoInterViewList(num:Int,type:Int) -> Void {
        var pageNum = 1
        if self.dataType == .waittingHandle {
            //待处理
            pageNum = pageNum1
        }else if self.dataType == .waittingInterFace
        {
            //待面试
            pageNum = pageNum2
        }else if self.dataType == .alreadyFinish
        {
            //已结束
            pageNum = pageNum3
        }else if self.dataType == .didNotInterView
        {
            //未面试
            pageNum = pageNum4
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
        
        HRVideojobmanagerInterface(dic: newDic, actionHander: { (bassClass) in
            self.bassClass = bassClass
            self.tableView.reloadData()
             self.tableView.mj_header.endRefreshing()
        }) { 
            SVProgressHUD.showInfo(withStatus: "请求失败")
        }
    }
    //获得视频面试列表（应聘者）
    func UserGetVideoInterViewList(num:Int,type:Int) -> Void {
        var pageNum = 1
        if self.dataType == .waittingHandle {
            //待处理
            pageNum = pageNum1
        }else if self.dataType == .waittingInterFace
        {
            //待面试
            pageNum = pageNum2
        }else if self.dataType == .alreadyFinish
        {
            //已结束
            pageNum = pageNum3
        }
        let dic:NSDictionary = [
            "token":GetUser(key: TOKEN),
            "no":pageNum,
            "size":100,
            "type":type
        ]
        let jsonStr = JSON(dic)
        let newDic:NSDictionary = jsonStr.dictionaryValue as NSDictionary
        userVideoStateList(dic: newDic, actionHander: { (bassClass) in
            self.userBassClass = bassClass
            self.tableView.reloadData()
             self.tableView.mj_header.endRefreshing()
        }) { 
            SVProgressHUD.showInfo(withStatus: "请求失败")
        }
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if self.homeType == .HRHomePage {
            if self.dataType == .waittingInterFace {
                //待面试
                if self.bassClass == nil {
                    return 0
                }
                return (self.bassClass?.list![section].list?.count)! + 1 //+1是由于一直有第一行
                
            }
        }else if self.homeType == .userHomePage
        {
            //应聘者
            if self.dataType == .waittingHandle {
                //待处理
                if self.userBassClass == nil {
                    return 0
                }
                return 1
            }else if self.dataType == .waittingInterFace {
                //待面试
                if self.userBassClass == nil {
                    return 0
                }
                return 1
            }
            
        }
        
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if self.homeType == .HRHomePage {
            let model:HRVideoInterViewStateList = (self.bassClass?.list![indexPath.section])!
            if self.dataType == .waittingHandle {
                //待处理
                if model.state == 3 {
                    //邀约中
                    let cell = tableView.dequeueReusableCell(withIdentifier: "HRVideoWaitUserManagerCell") as! HRVideoWaitUserManagerCell
                    cell.installCell(jobName: model.jobName, state: "等待求职者处理", time: model.time, timeLong: model.duration, waiterNum: "\(model.num ?? 0)/\(model.nums ?? 0)", headImageStr: model.avatar, name: model.name, money: model.salary, area: model.area, exp: model.exp, edu: model.edu)
                    return cell
                    
                }else if model.state == 6 {
                    //待处理
                    let cell = tableView.dequeueReusableCell(withIdentifier: "HRVideoWaitToManagerCell") as! HRVideoWaitToManagerCell
                    
                    cell.installCell(jobName: model.jobName, state: "待处理", time: model.time, timeLong: model.duration, waiterNum: "\(model.num ?? 0)/\(model.nums ?? 0)", headImageStr: model.avatar, name: model.name, money: model.salary, area: model.area, exp: model.exp, edu: model.edu, refuseBtnClosure: { (btn) in
                        print("拒绝点击")
                        
                        let dic:NSDictionary = [
                            "token":GetUser(key: TOKEN),
                            "jobId":self.jobId,   //职位id
                            "resumeId":self.bassClass?.list?[indexPath.section].resumeId as Any,        //简历id
                             "type":1
                            
                        ]
                        let jsonStr = JSON(dic)
                        let newDic = jsonStr.dictionaryValue
                        
                        HRVideoApprovalAgreeOrRefuse(dic: newDic as NSDictionary, actionHander: { (jsonStr) in
                            if jsonStr["code"] == 0 {
                                SVProgressHUD.showSuccess(withStatus: "操作成功")
                                self.HRGetVideoInterViewList(num: 1, type: self.dataType.rawValue)
                                
                            }else{
                                SVProgressHUD.showInfo(withStatus: jsonStr["msg"].stringValue)
                            }
                        }, fail: { 
                            
                        })
                        
                        
                    }, agreeBtnClosure: { (btn) in
                        print("同意点击")
                        let dic:NSDictionary = [
                            "token":GetUser(key: TOKEN),
                            "jobId":self.jobId,   //职位id
                            "resumeId":self.bassClass?.list?[indexPath.section].resumeId as Any,        //简历id
                            "type":0
                            
                        ]
                        let jsonStr = JSON(dic)
                        let newDic = jsonStr.dictionaryValue
                        
                        HRVideoApprovalAgreeOrRefuse(dic: newDic as NSDictionary, actionHander: { (jsonStr) in
                            if jsonStr["code"] == 0 {
                                SVProgressHUD.showSuccess(withStatus: "操作成功")
                                self.HRGetVideoInterViewList(num: 1, type: self.dataType.rawValue)
                                
                            }else{
                                SVProgressHUD.showInfo(withStatus: jsonStr["msg"].stringValue)
                            }
                        }, fail: {
                            
                        })

                        
                    })
                    return cell
                }
                
            }else if self.dataType == .alreadyFinish {
                let cell = tableView.dequeueReusableCell(withIdentifier: "HRVideoAlreadyFinishCell") as! HRVideoAlreadyFinishCell
                cell.installCell(name: model.name, money: model.salary, area: model.area, year: model.exp, edu: model.edu, evaluateMes: "", evaluateStateType: 1, headImageStr: model.avatar, videoStartBtnClosure: { (btn) in
                    print("视频按钮点击")
                    
                })
                return cell
            }else if self.dataType == .waittingInterFace{
                //待面试
                if indexPath.row == 0 {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "HRVideoWaitInterViewCell1") as! HRVideoWaitInterViewCell1
                    cell.installCell(jobName: model.jobName, time: model.time, timeLong: model.duration, numOfPeople: "\(model.num!)/\(model.nums!)",stateNum:model.state!, startBtnClosure: { (btn) in
                        print("开始面试BtnClick")
                            //开始面试按钮点击
                            let dic:NSDictionary = [
                                "token":GetUser(key: TOKEN),
                                "id":model.id!
                            ]
                            let jsonStr = JSON(dic)
                            let newDic:NSDictionary = jsonStr.dictionaryValue as NSDictionary
                            
                            HRStartInterView(dic: newDic, actionHander: { (jsonStr) in
                                if jsonStr["code"] == 0 {
                                    SVProgressHUD.showSuccess(withStatus: "开始面试成功")
                                      self.HRGetVideoInterViewList(num: 1, type: 2)
                                }else{
                                    SVProgressHUD.showInfo(withStatus: jsonStr["msg"].stringValue)
                                }
                                
                            }, fail: {
                                SVProgressHUD.showInfo(withStatus: "请求失败")
                            })
                
                    })
                    
                    return cell
                }else{
                    
                    let listModel:HRVideoInterState2List = (model.list?[indexPath.row - 1])!
                    let cell = tableView.dequeueReusableCell(withIdentifier: "HRVideoWaitInterViewCell2") as! HRVideoWaitInterViewCell2
                    cell.installCell(headImageUrl: listModel.avatar, name: listModel.name, money: listModel.salary, stateNum: listModel.ready!, videoBtnClosure: { (btn) in
                        print("开始视频")
                        if listModel.ready == 1 {
                    //未就绪(测试视频直接进入视频)
//               createAlertOneBtn(title: "提示", message: "此应聘者暂未就绪", btnStr: "知道了",   viewControll: self, closure: nil)
                       let vc = NTESVideoChatViewController(callee: "lq2391570")
                         //   print("listModel.avatar = \(listModel.avatar)")
                          vc?.headUrl = listModel.avatar
                          vc?.nameStr = listModel.name
                          vc?.ypUserId = listModel.id!
                        //  vc?.stateLabel.text = listModel.
                        self.navigationController?.pushViewController(vc!, animated: true)
                      }
                        
                    })
                    
                    return cell
                }
                
                
            }
            
        }else if self.homeType == .userHomePage {
            //应聘者
            if self.dataType == .waittingHandle {
                //待处理（分为 3等待HR处理 及 9待处理）
                let model:UserVideoInterfaceList = (self.userBassClass?.list![indexPath.section])!
                print("面试id = \(model.id)")
                if model.state == 9 {
                    //待处理
                    let cell = tableView.dequeueReusableCell(withIdentifier: "UserVideoWaitManagerCell") as! UserVideoWaitManagerCell
                    cell.installCell(jobName: "\(model.name!)|\(model.company!)", state: "待处理", time: model.time, during: model.duration, numOfPeople: "\(model.num!)|\(model.nums!)", headImageStr: model.avatar, HRNameAndJob: "\(model.hrName!)|\(model.job!)", score: model.score, refuseClosure: { (btn) in
                        print("拒绝")
                        userVideoApprovalAgreeOrRefuse(dic: ["token":GetUser(key: TOKEN),"id":model.id!,"type":"1"], actionHander: { (jsonStr) in
                            if jsonStr["code"] == 0 {
                                print("成功")
                                SVProgressHUD.showSuccess(withStatus: jsonStr["msg"].stringValue)
                                self.UserGetVideoInterViewList(num: 1, type: self.dataType.rawValue)
                                
                            }else{
                                SVProgressHUD.showInfo(withStatus: jsonStr["msg"].stringValue)
                            }
                        }) { 
                            SVProgressHUD.showInfo(withStatus: "请求失败")
                        }
                    }, agreeClosure: { (btn) in
                        print("同意")
                        userVideoApprovalAgreeOrRefuse(dic: ["token":GetUser(key: TOKEN),"id":model.id!,"type":"0"], actionHander: { (jsonStr) in
                            if jsonStr["code"] == 0 {
                                print("成功")
                                SVProgressHUD.showSuccess(withStatus: jsonStr["msg"].stringValue)
                                self.UserGetVideoInterViewList(num: 1, type: self.dataType.rawValue)
                                
                            }else{
                                SVProgressHUD.showInfo(withStatus: jsonStr["msg"].stringValue)
                            }
                        }) {
                            SVProgressHUD.showInfo(withStatus: "请求失败")
                        }

                        
                    })
                    
                    return cell
                    
                }else if model.state == 3 {
                    //等待HR处理
                    let cell = tableView.dequeueReusableCell(withIdentifier: "UserVideoWaitHRCell") as! UserVideoWaitHRCell
                    
                    cell.installCell(jobName: "\(model.name!)|\(model.company!)", state: "等待HR处理", time: model.time, during: model.duration, numOfPeople: "\(model.num!)|\(model.nums!)", headImageStr: model.avatar, HRNameAndJob: "\(model.hrName!)|\(model.job!)", score: model.score)
                    
                    return cell
                }
                
                
            }else if self.dataType == .waittingInterFace {
                let model:UserVideoInterfaceList = (self.userBassClass?.list![indexPath.section])!
                //待面试
                if model.state == 5 {
                    //未到准备时间
                    let cell = tableView.dequeueReusableCell(withIdentifier: "UserVideoWaitHRCell") as! UserVideoWaitHRCell
                    
                    cell.installCell(jobName: "\(model.name!)|\(model.company!)", state: "", time: model.time, during: model.duration, numOfPeople: "\(model.num!)|\(model.nums!)", headImageStr: model.avatar, HRNameAndJob: "\(model.hrName!)|\(model.job!)", score: model.score)
                    
                    return cell
                }else if model.state == 6 {
                    //可以准备就绪（有一层遮罩）
                    let cell = tableView.dequeueReusableCell(withIdentifier: "UserVideoWaitHRCell") as! UserVideoWaitHRCell
                    
                    cell.installCell(jobName: "\(model.name!)|\(model.company!)", state: "", time: model.time, during: model.duration, numOfPeople: "\(model.num!)|\(model.nums!)", headImageStr: model.avatar, HRNameAndJob: "\(model.hrName!)|\(model.job!)", score: model.score)
                    cell.readyBtnClickClosure = {
                        print("准备就绪")
                        
                    }
                    
                    return cell
                }else if model.state == 7 {
                    //已准备就绪
                    let cell = tableView.dequeueReusableCell(withIdentifier: "UserVideoWaitHRCell") as! UserVideoWaitHRCell
                    
                    cell.installCell(jobName: "\(model.name!)|\(model.company!)", state: "", time: model.time, during: model.duration, numOfPeople: "\(model.num!)|\(model.nums!)", headImageStr: model.avatar, HRNameAndJob: "\(model.hrName!)|\(model.job!)", score: model.score)
                    
                    return cell
                }
                
                

            }else if self.dataType == .alreadyFinish {
                //已结束
                
                
            }
            
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "HRVideoWaitUserManagerCell") as! HRVideoWaitUserManagerCell
        return cell
        
    }
    //由于视频文件中不能调用HttpEngin，先把视频中的请求写在这里
    //1获取jobeeker的个人信息
    func getJobSeekerMes(mianshiId:Int,succeedClosure:((_ jobSeekerBassClass:JobSeekerMesInVideoBaseClass) -> ())?) -> Void {
        let dic:NSDictionary = [
            "token":GetUser(key: TOKEN),
            "id":mianshiId
        ]
        let jsonStr = JSON(dic)
        let newDic = jsonStr.dictionaryValue as NSDictionary
        
        JobSeekerMesInVideo(dic: newDic, actionHander: { (jobSeekerBassClass) in
            succeedClosure!(jobSeekerBassClass)
        }) { 
            
        }
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        if homeType == .HRHomePage {
            if self.bassClass == nil {
                return 0
            }
            return (self.bassClass?.list?.count)!
        }else if homeType == .userHomePage {
            if self.userBassClass == nil {
                return 0
            }
            return (self.userBassClass?.list?.count)!
        }
        return 0
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        if self.dataType == .waittingHandle {
//            //待处理
//            print("待处理")
//
////    let vc = UIStoryboard.init(name: "UserFirstStoryboard", bundle: nil).instantiateViewController(withIdentifier: "EvaluateVC") as! EvaluateVC
////            
////        self.navigationController?.pushViewController(vc, animated: true)
//         //   let model:HRVideoInterViewStateList = (self.bassClass?.list![indexPath.section])!
//          //  let listModel:HRVideoInterState2List = (model.list?[indexPath.row])!
//            
//          //  print("listModel.mianshiId = \(listModel.id)")
//            
//            let vc = NTESVideoChatViewController(callee: "lq2391570")
//            //   print("listModel.avatar = \(listModel.avatar)")
////            vc?.headUrl = listModel.avatar
////            vc?.nameStr = listModel.name
//            vc?.mianshiId = 74
//            vc?.token = GetUser(key: TOKEN) as! String
//            vc?.isHRVideo = true
//            self.navigationController?.pushViewController(vc!, animated: true)
//            
//        }
        
        if self.homeType == .userHomePage {
            //应聘者端
            if self.dataType == .waittingHandle {
                //待处理
                 let model:UserVideoInterfaceList = (self.userBassClass?.list![indexPath.section])!
                let vc = UIStoryboard(name: "UserFirstStoryboard", bundle: nil).instantiateViewController(withIdentifier: "StationDetailVC") as! StationDetailVC
                vc.intentId = self.intentId
                vc.jobId = self.jobId
                vc.userMesJson = self.userMesJson
                vc.stationEnterType = .userVideoInterViewListWaitHandle
                vc.interfaceId = model.id!
                vc.returnClosure = {
                     self.UserGetVideoInterViewList(num: 1, type: self.dataType.rawValue)
                }
                self.navigationController?.pushViewController(vc, animated: true)
                
            }
            
        }
        
        
        
        
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if homeType == .HRHomePage {
            if self.dataType == .waittingHandle {
                let model:HRVideoInterViewStateList = (self.bassClass?.list![indexPath.section])!
                if model.state == 3 {
                    return 150
                }else if model.state == 6 {
                    return 210
                }
            }else if self.dataType == .alreadyFinish {
                //已面试
                return 120
            }else if self.dataType == .waittingInterFace{
                //待面试
                if indexPath.row == 0 {
                    return 65
                }else{
                    return 80
                }
            }
        }else if self.homeType == .userHomePage{
            if self.dataType == .waittingHandle {
                let model:UserVideoInterfaceList = (self.userBassClass?.list![indexPath.section])!
                if model.state == 9 {
                    return 210
                }else if model.state == 3 {
                    return 150
                }
                
            }
        }
       return 150
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
