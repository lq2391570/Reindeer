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
    
    
    @IBOutlet var tableView: UITableView!
    //列表分类
    enum TableViewDataType:Int {
        case waittingHandle = 1  //待处理
        case waittingInterFace //待面试
        case alreadyFinish //已结束
    }
    var bassClass:CommonInterviewStateListBaseClass?
    var pageNum1 = 1
    var pageNum2 = 1
    var pageNum3 = 1
    var jobId = "39"
    var dataType:TableViewDataType = .waittingHandle
    //个人信息json
    var userMesJson:JSON?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib.init(nibName: "CommonInterViewCell1", bundle: nil), forCellReuseIdentifier: "CommonInterViewCell1")
        tableView.register(UINib.init(nibName: "CommonInterViewCell2", bundle: nil), forCellReuseIdentifier: "CommonInterViewCell2")
        // Do any additional setup after loading the view.
        getInterViewtype1(num: 1, type:self.dataType.rawValue)
    }
    
    
    //待处理列表
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
            "token":"eyJhbGciOiJIUzUxMiIsInppcCI6IkdaSVAifQ.H4sIAAAAAAAAAKtWKi5NUrJSMjdVqgUAnBbhRQwAAAA.a5XhX0OYfb7WsOWitKNIk6tokAY1ABg0daNePrNxsOX9vRsqbz9241AJMieEjt7TrB726F_yr4K06ZnGCvuCvQ",
            "no":pageNum,
            "size":10,
            "jobId":"39",
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
    
    //获取待处理列表
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 1
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let model:CommonInterviewStateListList = (self.bassClass?.list![indexPath.section])!
        if model.state == 1 {
            //邀约中
            let cell = tableView.dequeueReusableCell(withIdentifier: "CommonInterViewCell1") as! CommonInterViewCell1
            cell.installCell(jobName: model.jobName, state: "等待求职者处理", headImageStr: model.avatar, name: model.name, money: model.salary, area: model.area, year: model.exp, edu: model.edu, interViewTime: model.time, interViewArea: model.address)
            return cell

        }else if model.state == 5 {
            //收到的申请
            let cell = tableView.dequeueReusableCell(withIdentifier: "CommonInterViewCell2") as! CommonInterViewCell2
            
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
            return cell
        }
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let model:CommonInterviewStateListList = (self.bassClass?.list![indexPath.section])!
        if model.state == 1 {
            //邀约中
            let vc = UIStoryboard.init(name: "UserFirstStoryboard", bundle: nil).instantiateViewController(withIdentifier: "ResumeDetailVC") as! ResumeDetailVC
            
            vc.intentId = NSNumber.init(value: (model.intentId)!).stringValue
            
            vc.jobId = "39"
            
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
            
            vc.jobId = "39"
            
            vc.resumeId = NSNumber.init(value: (model.resumeId)!).stringValue
             print("intentId = \(model.intentId), jobId = \(self.jobId),resumeId = \(model.resumeId)")
            //这个json是存储个人信息的，下个页面取到公司id使用
            vc.userMesJson = self.userMesJson
            vc.resumeDetailType = .applyIng
            self.navigationController?.pushViewController(vc, animated: true)
        
        }
        
        
    }
    func numberOfSections(in tableView: UITableView) -> Int
    {
        if self.bassClass == nil {
            return 0 
        }
        return (self.bassClass?.list?.count)!
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 226
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
