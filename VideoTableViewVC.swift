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
    var pageNum1 = 1
    var pageNum2 = 1
    var pageNum3 = 1
    var pageNum4 = 1
    var jobId = ""
    var intentId = ""
    
    var dataType:TableViewDataType = .waittingHandle


    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib.init(nibName: "HRVideoWaitToManagerCell", bundle: nil), forCellReuseIdentifier: "HRVideoWaitToManagerCell")
        tableView.register(UINib.init(nibName: "HRVideoWaitUserManagerCell", bundle: nil), forCellReuseIdentifier: "HRVideoWaitUserManagerCell")
        tableView.register(UINib.init(nibName: "HRVideoAlreadyFinishCell", bundle: nil), forCellReuseIdentifier: "HRVideoAlreadyFinishCell")
        if homeType == .HRHomePage {
            HRGetVideoInterViewList(num: 1, type: self.dataType.rawValue)
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
        
        HRVideojobmanagerInterface(dic: newDic, actionHander: { (bassClass) in
            self.bassClass = bassClass
            self.tableView.reloadData()
        }) { 
            SVProgressHUD.showInfo(withStatus: "请求失败")
        }
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
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
                    }, agreeBtnClosure: { (btn) in
                        print("同意点击")
                    })
                    return cell
                }
                
            }else if self.dataType == .alreadyFinish {
                let cell = tableView.dequeueReusableCell(withIdentifier: "HRVideoAlreadyFinishCell") as! HRVideoAlreadyFinishCell
                cell.installCell(name: model.name, money: model.salary, area: model.area, year: model.exp, edu: model.edu, evaluateMes: "", evaluateStateType: 1, headImageStr: model.avatar, videoStartBtnClosure: { (btn) in
                    print("视频按钮点击")
                    
                })
                return cell
            }
            
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "HRVideoWaitUserManagerCell") as! HRVideoWaitUserManagerCell
        return cell
        
    }
    func numberOfSections(in tableView: UITableView) -> Int
    {
        if homeType == .HRHomePage {
            if self.bassClass == nil {
                return 0
            }
            return (self.bassClass?.list?.count)!
        }
        return 0
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.dataType == .waittingHandle {
            //待处理
            print("待处理")
        let vc = NTESVideoChatViewController(callee: "lq2388691")
            
        self.navigationController?.pushViewController(vc!, animated: true)
    
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
                return 120
            }
           
        }else{
             return 150
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
