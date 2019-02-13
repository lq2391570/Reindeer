//
//  HRInviteTableViewVC.swift
//  Reindeer
//
//  Created by shiliuhua on 2017/8/25.
//  Copyright © 2017年 shiliuhua. All rights reserved.
//

import UIKit
import SwiftyJSON
import SVProgressHUD
import DZNEmptyDataSet
import MJRefresh
import JCAlertView
class HRInviteTableViewVC: UIViewController,UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate {

    @IBOutlet var tableView: UITableView!
    
    var typeEnum:InviteTableViewDataType = .waittingHandle
    
    //个人信息json
    var userMesJson:JSON?
    var inviteInterviewBassClass:HRInviteListHRInviteList?
    //UserBassClass
    var userInviteBassClass:UserInterviewUserInterviewBassClass?
    
    //顶部刷新
    var header = MJRefreshGifHeader()
    //底部刷新
    let footer = MJRefreshAutoFooter()
    
    var homeType:HomepageType = .HRHomePage
    
       var dataLong:String = ""
    //首页类型（HR或应聘者）
    enum HomepageType:Int {
        case userHomePage = 1 //普通用户
        case HRHomePage   //HR
    }
    //列表分类
    enum InviteTableViewDataType:Int {
        case waittingHandle = 1  //待处理
        case waittingInterFace //待面试
        case alreadyFinish //已结束
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.emptyDataSetSource = self
        tableView.emptyDataSetDelegate = self
        tableView.register(UINib.init(nibName: "HRInviteFinishCell1", bundle: nil), forCellReuseIdentifier: "HRInviteFinishCell1")
        tableView.register(UINib.init(nibName: "HRInterviewFinishCell2", bundle: nil), forCellReuseIdentifier: "HRInterviewFinishCell2")
        tableView.register(UINib.init(nibName: "HRInviteWaitHandleCell1", bundle: nil), forCellReuseIdentifier: "HRInviteWaitHandleCell1")
        tableView.register(UINib.init(nibName: "HRInviteWaitHandleCell2", bundle: nil), forCellReuseIdentifier: "HRInviteWaitHandleCell2")
        tableView.register(UINib.init(nibName: "HRInviteWaitInterviewCell", bundle: nil), forCellReuseIdentifier: "HRInviteWaitInterviewCell")
        tableView.register(UINib.init(nibName: "HRVideoAlreadyFinishCell", bundle: nil), forCellReuseIdentifier: "HRVideoAlreadyFinishCell")
        // Do any additional setup after loading the view.
        if self.homeType == .HRHomePage {
            getInviteInterViewList()
            self.tableView.mj_header = setUpMJHeader(refreshingClosure: {
                self.getInviteInterViewList()
            })
        }else{
            getUserInviteInterViewList()
            self.tableView.mj_header = setUpMJHeader(refreshingClosure: {
                 self.getUserInviteInterViewList()
            })
        }
        
     }
    //获得用户邀请面试列表
    func getUserInviteInterViewList() -> Void {
        let dic:NSDictionary = [
            "token":GetUser(key: TOKEN),
            "no":1,
            "size":100,
            "type":self.typeEnum.rawValue
        ]
        let jsonStr = JSON(dic)
        let newDic:NSDictionary = jsonStr.dictionaryValue as NSDictionary
        print("newDic3 = \(newDic)")
        UserInviteInterviewListInterface(dic: newDic, actionHander: { (bassClass) in
            self.userInviteBassClass = bassClass
            self.tableView.reloadData()
            self.tableView.mj_header.endRefreshing()
        }) { 
            
        }
    }
    
    
    //获得邀请面试列表
    func getInviteInterViewList() -> Void {
        let dic:NSDictionary = [
            "token":GetUser(key: TOKEN),
            "no":1,
            "size":100,
            "type":self.typeEnum.rawValue
        ]
        let jsonStr = JSON(dic)
        let newDic:NSDictionary = jsonStr.dictionaryValue as NSDictionary
        print("newDic2 = \(newDic)")
        
        HRInviteInterviewInterface(dic: newDic, actionHander: { (bassClass) in
            self.inviteInterviewBassClass = bassClass
            self.tableView.reloadData()
             self.tableView.mj_header.endRefreshing()
        }) { 
            
        }
    }
    //自定义弹出框
    func invitePopView(sureClosure:(() -> ())?) -> Void {
        if let customView = LQDatePickView.newInstance() {
            
            let customAlert = JCAlertView.init(customView: customView, dismissWhenTouchedBackground: false)
            
            customAlert?.center = CGPoint.init(x: ScreenWidth/2, y: ScreenHeight - customView.frame.size.height/2-20)
            // customView.datePicker.datePickerMode = .time
            customView.cancelbtnClickClosure = { (btn) in
                customAlert?.dismiss(completion: nil)
                
            }
            customView.sureBtnClickclosure = { (btn) in
                
                print("datePick.date = \(customView.datePicker.date)")
                customAlert?.dismiss(completion: nil)
                self.dataLong = dateTransformUnixStr(date: customView.datePicker.date)
                sureClosure!()
                
            }
            customView.datePickChangeClosure = { sender in
                
            }
            customAlert?.show()
            
        }
        
    }
    //邀请面试
    func inviteInterviewWithUser(resumeId:Int) -> Void {
        let dic:NSDictionary = [
            "token":GetUser(key: TOKEN),
            "id":resumeId,
            "date":dataLong
        ]
        let jsonStr = JSON(dic)
        let newDic:NSDictionary = jsonStr.dictionaryValue as NSDictionary
        
        HRInviteInterviewWithUser(dic: newDic, actionHander: { (jsonStr) in
            if jsonStr["code"] == 0 {
                SVProgressHUD.showSuccess(withStatus: "邀请成功")
            }else{
                SVProgressHUD.showInfo(withStatus: jsonStr["msg"].stringValue)
            }
        }) {
            
        }
    }

    func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
        return UIImage(named: "null_icon.png")
    }
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let text = "点击刷新"
        let attributes = [NSFontAttributeName:UIFont.boldSystemFont(ofSize: 18),NSForegroundColorAttributeName:UIColor.gray]
        return NSAttributedString.init(string: text, attributes: attributes)
        
    }
    func emptyDataSet(_ scrollView: UIScrollView!, didTap view: UIView!) {
        print("点击kongbai")
        if homeType == .HRHomePage {
            self.tableView.mj_header.beginRefreshing {
               // print("self.dataType.rawValue = \(self.dataType.rawValue)")
                self.getInviteInterViewList()
            }
        }else{
         //   getUserInviteInterViewList()
            
            self.tableView.mj_header.beginRefreshing {
                // print("self.dataType.rawValue = \(self.dataType.rawValue)")
                self.getUserInviteInterViewList()
            }
            
        }
        
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if self.homeType == .HRHomePage {
            //HR端
            if self.typeEnum == .alreadyFinish {
                //已结束
                let listModel:HRInviteListList = (self.inviteInterviewBassClass?.list![indexPath.section])!
                if listModel.state == 6 {
                    //已完成
                    let cell = tableView.dequeueReusableCell(withIdentifier: "HRVideoAlreadyFinishCell") as! HRVideoAlreadyFinishCell
                    cell.installCell(name: listModel.name, money: "", area: listModel.area, year: listModel.exp, edu: listModel.edu, evaluateMes: "", evaluateStateType: 1, headImageStr: listModel.avatar, videoStartBtnClosure: { (btn) in
                        print("点击了视频")
                        print("点击的链接为 \(listModel.url ?? "")")
                        if listModel.url == nil {
                            SVProgressHUD.showInfo(withStatus: "此面试未储存")
                        }
                        
                    }, recommendClosure: { (btn) in
                        print("点击了推荐")
                        let vc = UIStoryboard(name: "UserFirstStoryboard", bundle: nil).instantiateViewController(withIdentifier: "RecommendTalentVC") as! RecommendTalentVC
                        
                        vc.resumeId = listModel.resumeId!
                        //  vc.intendId = self.intentId  //求职意向id？
                        self.navigationController?.pushViewController(vc, animated: true)
                    })
                    return cell
                }else if listModel.state == 7 {
                    //已评价
                    let cell = tableView.dequeueReusableCell(withIdentifier: "HRVideoAlreadyFinishCell") as! HRVideoAlreadyFinishCell
                    cell.installCell(name: listModel.name, money: "", area: listModel.area, year: listModel.exp, edu: listModel.edu, evaluateMes: "", evaluateStateType: 1, headImageStr: listModel.avatar, videoStartBtnClosure: { (btn) in
                        print("点击了视频")
                        print("点击的链接为 \(listModel.url ?? "")")
                        if listModel.url == nil {
                            SVProgressHUD.showInfo(withStatus: "此面试未储存")
                        }
                        
                    }, recommendClosure: { (btn) in
                        print("点击了推荐")
                        let vc = UIStoryboard(name: "UserFirstStoryboard", bundle: nil).instantiateViewController(withIdentifier: "RecommendTalentVC") as! RecommendTalentVC
                        
                        vc.resumeId = listModel.resumeId!
                        //  vc.intendId = self.intentId  //求职意向id？
                        
                        
                        self.navigationController?.pushViewController(vc, animated: true)
                    })
                    return cell
                }else if listModel.state == 8 {
                    //未评价
                    let cell = tableView.dequeueReusableCell(withIdentifier: "HRVideoAlreadyFinishCell") as! HRVideoAlreadyFinishCell
                    cell.installCell(name: listModel.name, money: "", area: listModel.area, year: listModel.exp, edu: listModel.edu, evaluateMes: "", evaluateStateType: 1, headImageStr: listModel.avatar, videoStartBtnClosure: { (btn) in
                        print("点击了视频")
                        print("点击的链接为 \(listModel.url ?? "")")
                        if listModel.url == nil {
                            SVProgressHUD.showInfo(withStatus: "此面试未储存")
                        }
                        
                    }, recommendClosure: { (btn) in
                        print("点击了推荐")
                        let vc = UIStoryboard(name: "UserFirstStoryboard", bundle: nil).instantiateViewController(withIdentifier: "RecommendTalentVC") as! RecommendTalentVC
                        vc.resumeId = listModel.resumeId!
                        //  vc.intendId = self.intentId  //求职意向id？
                        self.navigationController?.pushViewController(vc, animated: true)
                    })
                    return cell
                }else if listModel.state == 9 {
                    //已拒绝
                    let cell = tableView.dequeueReusableCell(withIdentifier: "HRInterviewFinishCell2") as! HRInterviewFinishCell2
                    cell.installCell(time: "", headImageStr: listModel.avatar, name: listModel.name, area: listModel.area, year: listModel.exp, edu: listModel.edu)
                    return cell
                    
                }else if listModel.state == 10 {
                    //未面试
                    let cell = tableView.dequeueReusableCell(withIdentifier: "HRInviteFinishCell1") as! HRInviteFinishCell1
                    cell.installCell(time: "", headImageStr: listModel.avatar, name: listModel.name, area: listModel.area, year: listModel.exp, edu: listModel.edu, inviteClosure: { (btn) in
                        print("发起邀请")
                        self.invitePopView(sureClosure: {
                            self.inviteInterviewWithUser(resumeId: listModel.resumeId!)
                        })
                        
                    })
                    return cell
                }else if listModel.state == 2 {
                    //未处理
                    let cell = tableView.dequeueReusableCell(withIdentifier: "HRInviteFinishCell1") as! HRInviteFinishCell1
                    cell.installCell(time: "", headImageStr: listModel.avatar, name: listModel.name, area: listModel.area, year: listModel.exp, edu: listModel.edu, inviteClosure: { (btn) in
                        print("发起邀请")
                        self.invitePopView(sureClosure: {
                            self.inviteInterviewWithUser(resumeId: listModel.resumeId!)
                        })
                    })
                    cell.stateLabel.text = "未处理"
                    return cell
                    
                }
                
            }else if self.typeEnum == .waittingHandle {
                //待处理
                let listModel:HRInviteListList = (self.inviteInterviewBassClass?.list![indexPath.section])!
                if listModel.state == 0 {
                    //邀约中
                    let cell = tableView.dequeueReusableCell(withIdentifier: "HRInviteWaitHandleCell1") as! HRInviteWaitHandleCell1
                    cell.installCell(time: listModel.dateStr, headImageStr: listModel.avatar, name: listModel.name, area: listModel.area, year: listModel.exp, edu: listModel.edu)
                    return cell
                    
                }else if listModel.state == 1 {
                    //待处理
                    let cell = tableView.dequeueReusableCell(withIdentifier: "HRInviteWaitHandleCell2") as! HRInviteWaitHandleCell2
                    cell.installCell(time: listModel.dateStr, headImageStr: listModel.avatar, name: listModel.name, area: listModel.area, year: listModel.exp, edu: listModel.edu, refuseClosure: { (btn) in
                        print("点击拒绝")
                    }, agreeClosure: { (btn) in
                        print("点击同意")
                        
                    })
                    
                    return cell
                }
                
            }else if self.typeEnum == .waittingInterFace {
                //待面试
                let listModel:HRInviteListList = (self.inviteInterviewBassClass?.list![indexPath.section])!
                if listModel.state == 3 {
                    //就绪
                    let cell = tableView.dequeueReusableCell(withIdentifier: "HRInviteWaitInterviewCell") as! HRInviteWaitInterviewCell
                    cell.installCell(time: listModel.dateStr, headImageStr: listModel.avatar, name: listModel.name, area: listModel.area, year: listModel.exp, edu: listModel.edu, videoClickClosure: { (btn) in
                        print("开始视频")
                        print("点击的链接为 \(listModel.url ?? "")")
                        if listModel.url == nil {
                            SVProgressHUD.showInfo(withStatus: "此面试未储存")
                        }
                        
                    })
                    return cell
                }else if listModel.state == 4 {
                    //未就绪
                    let cell = tableView.dequeueReusableCell(withIdentifier: "HRInviteWaitInterviewCell") as! HRInviteWaitInterviewCell
                    cell.installCell(time: listModel.dateStr, headImageStr: listModel.avatar, name: listModel.name, area: listModel.area, year: listModel.exp, edu: listModel.edu, videoClickClosure: { (btn) in
                        print("开始视频")
                        print("点击的链接为 \(listModel.url ?? "")")
                        if listModel.url == nil {
                            SVProgressHUD.showInfo(withStatus: "此面试未储存")
                        }
                        
                    })
                    return cell
                }else if listModel.state == 5 {
                    //面试中
                    let cell = tableView.dequeueReusableCell(withIdentifier: "HRInviteWaitInterviewCell") as! HRInviteWaitInterviewCell
                    cell.installCell(time: listModel.dateStr, headImageStr: listModel.avatar, name: listModel.name, area: listModel.area, year: listModel.exp, edu: listModel.edu, videoClickClosure: { (btn) in
                        print("开始视频")
                        print("点击的链接为 \(listModel.url ?? "")")
                        if listModel.url == nil {
                            SVProgressHUD.showInfo(withStatus: "此面试未储存")
                        }
                        
                    })
                    return cell
                }else if listModel.state == 6 {
                    //完成
                    let cell = tableView.dequeueReusableCell(withIdentifier: "HRInviteWaitInterviewCell") as! HRInviteWaitInterviewCell
                    cell.installCell(time: listModel.dateStr, headImageStr: listModel.avatar, name: listModel.name, area: listModel.area, year: listModel.exp, edu: listModel.edu, videoClickClosure: { (btn) in
                        print("开始视频")
                        print("点击的链接为 \(listModel.url ?? "")")
                        if listModel.url == nil {
                            SVProgressHUD.showInfo(withStatus: "此面试未储存")
                        }
                        
                    })
                    return cell
                }
                
            }
            let cell = tableView.dequeueReusableCell(withIdentifier: "HRInviteWaitHandleCell1") as! HRInviteWaitHandleCell1
            
            return cell

        }else{
            //用户端
            if self.typeEnum == .waittingHandle {
                //待处理
                let listModel:UserInterviewList = (self.userInviteBassClass?.list![indexPath.section])!
                if listModel.state == 1 {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "HRInviteWaitHandleCell2") as! HRInviteWaitHandleCell2
                    cell.HRNameView.isHidden = false
                    cell.installCell(time: listModel.dateStr, headImageStr: listModel.avatar, name: listModel.company, area: "", year: "", edu: "", refuseClosure: { (btn) in
                        print("点击拒绝")
                        SVProgressHUD.show()
                        UserHandleInvitesInterface(dic: ["token":GetUser(key: TOKEN),"id":listModel.id!,"type":1], actionHander: { (jsonStr) in
                            if jsonStr["code"] == 0 {
                                SVProgressHUD.showSuccess(withStatus: jsonStr["msg"].stringValue)
                                self.getUserInviteInterViewList()
                            }else{
                                SVProgressHUD.showInfo(withStatus: jsonStr["msg"].stringValue)
                            }
                        }, fail: {
                            
                        })

                        
                    }, agreeClosure: { (btn) in
                        print("点击同意")
                        SVProgressHUD.show()
                        UserHandleInvitesInterface(dic: ["token":GetUser(key: TOKEN),"id":listModel.id!,"type":0], actionHander: { (jsonStr) in
                            if jsonStr["code"] == 0 {
                                SVProgressHUD.showSuccess(withStatus: jsonStr["msg"].stringValue)
                                self.getUserInviteInterViewList()
                            }else{
                                SVProgressHUD.showInfo(withStatus: jsonStr["msg"].stringValue)
                            }
                        }, fail: {
                            
                        })


                    })
                    cell.HRNameLAbel.text = "\(listModel.name ?? "")|\(listModel.job ?? "")"
                   
                    return cell
                    
                }
                
                
            }else if self.typeEnum == .waittingInterFace {
                //待面试
                let listModel:UserInterviewList = (self.userInviteBassClass?.list![indexPath.section])!
                if listModel.state == 3 {
                    //待面试
                    let cell = tableView.dequeueReusableCell(withIdentifier: "HRInviteWaitInterviewCell") as! HRInviteWaitInterviewCell
                    cell.pingjiaLabel.isHidden = false
                    cell.HRNameView.isHidden = false
                    cell.installCell(time: listModel.dateStr, headImageStr: listModel.avatar, name: listModel.company, area: "", year: "", edu: "", videoClickClosure: { (btn) in
                        print("点击视频")
                    })
                    cell.startVideoBtn.isHidden = true
                    cell.pingjiaLabel.text = "已到面试时间"
                    cell.pingjiaLabel.textColor = UIColor.gray
                    return cell
                    
                }
                
                
            }else if self.typeEnum == .alreadyFinish {
                //已结束
                 let listModel:UserInterviewList = (self.userInviteBassClass?.list![indexPath.section])!
                if listModel.state == 2 {
                    //未处理
                    let cell = tableView.dequeueReusableCell(withIdentifier: "HRInviteWaitInterviewCell") as! HRInviteWaitInterviewCell
                    cell.HRNameView.isHidden = false
                      cell.pingjiaLabel.isHidden = false
                    cell.installCell(time: listModel.dateStr, headImageStr: listModel.avatar, name: listModel.company, area: "", year: "", edu: "", videoClickClosure: { (btn) in
                        print("点击视频")
                    })
                    cell.HRNameLAbel.text = "\(listModel.name ?? "")|\(listModel.job ?? "")"
                    cell.pingjiaLabel.textColor = UIColor.gray
                    cell.pingjiaLabel.text = "未评价"
                    return cell
                }else if listModel.state == 6 {
                    //已完成
                    let cell = tableView.dequeueReusableCell(withIdentifier: "HRInviteWaitInterviewCell") as! HRInviteWaitInterviewCell
                    cell.HRNameView.isHidden = false
                    cell.pingjiaLabel.isHidden = false
                    cell.installCell(time: listModel.dateStr, headImageStr: listModel.avatar, name: listModel.company, area: "", year: "", edu: "", videoClickClosure: { (btn) in
                        print("点击视频")
                    })
                    cell.HRNameLAbel.text = "\(listModel.name ?? "")|\(listModel.job ?? "")"
                    cell.pingjiaLabel.text = "已评价"
                    
                    return cell
                    
                }
                
            }
            let cell = tableView.dequeueReusableCell(withIdentifier: "HRInviteWaitInterviewCell") as! HRInviteWaitInterviewCell
            
            return cell
            
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if self.homeType == .HRHomePage {
            if self.typeEnum == .waittingHandle {
                let listModel:HRInviteListList = (self.inviteInterviewBassClass?.list![indexPath.section])!
                if listModel.state == 0 {
                    //邀约中
                    return 115
                }else if listModel.state == 1 {
                    //待处理
                    return 160
                }else if listModel.state == 2 {
                    //未处理
                    return 115
                }
            }else if self.typeEnum == .waittingInterFace {
                let listModel:HRInviteListList = (self.inviteInterviewBassClass?.list![indexPath.section])!
                if listModel.state == 3 {
                    //就绪
                    return 115
                }else if listModel.state == 4 {
                    //未就绪
                    return 115
                }else if listModel.state == 5 {
                    //面试中
                    return 115
                }else if listModel.state == 6 {
                    //完成
                    return 115
                }
                
            }else if self.typeEnum == .alreadyFinish {
                let listModel:HRInviteListList = (self.inviteInterviewBassClass?.list![indexPath.section])!
                if listModel.state == 6 {
                    //完成
                    return 120
                }else if listModel.state == 7 {
                    //已评价
                    return 120
                }else if listModel.state == 8 {
                    //未评价
                    return 120
                }else if listModel.state == 9 {
                    //已拒绝
                    return 70
                }else if listModel.state == 10 {
                    //未面试
                    return 120
                }else if listModel.state == 2 {
                    //未处理
                    return 120
                }
            }

        }else{
            if self.typeEnum == .waittingHandle {
                //待处理
        let listModel:UserInterviewList = (self.userInviteBassClass?.list![indexPath.section])!
                if listModel.state == 1 {
                    return 160
                }
                
                
            }else if self.typeEnum == .waittingInterFace {
                //待面试
                let listModel:UserInterviewList = (self.userInviteBassClass?.list![indexPath.section])!
                if listModel.state == 3 {
                    return 115
                }
                
            }else if self.typeEnum == .alreadyFinish {
                //已完成
              //  let listModel:UserInterviewList = (self.userInviteBassClass?.list![indexPath.section])!
                return 115
            }
            
        }
        
                return 0
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.homeType == .HRHomePage {
            //HR
        }else{
            //User
            if self.typeEnum == .waittingHandle {
                let listModel:UserInterviewList = (self.userInviteBassClass?.list![indexPath.section])!
                //待处理
                let vc = HRDetailHomeVC()
                vc.interviewId = listModel.id!
                vc.hrId = listModel.hrId!
                vc.hrName = listModel.name!
                vc.returnClosure = {
                     self.getUserInviteInterViewList()
                }
                
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    func numberOfSections(in tableView: UITableView) -> Int
    {
        if self.homeType == .HRHomePage {
            if self.inviteInterviewBassClass != nil {
                return (self.inviteInterviewBassClass?.list?.count)!
            }
            return 0
        }else{
            if self.userInviteBassClass != nil {
                return (self.userInviteBassClass?.list?.count)!
            }
            return 0
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
