//
//  PaiQiAddVC.swift
//  Reindeer
//
//  Created by shiliuhua on 2017/5/23.
//  Copyright © 2017年 shiliuhua. All rights reserved.
//

import UIKit
import JCAlertView
import SVProgressHUD
import SwiftyJSON
class PaiQiAddVC: BaseViewVC,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet var tableView: UITableView!
    //首页HR发布的职位model
    var HRPostjobBassClass:HRPostJobBaseClass?
    //选择的职位model
    var selectjobModel:HRPostJobList?
    //面试时间Str
    var interViewStr:String = ""
    //面试开始时间
    var interViewStartTimeStr = ""
    //面试结束时间
    var interViewEndTimeStr = ""
    
    //重复数组
    var repeatAttay:[Int] = []
    //重复数组（显示）
    var repeatNameDisplayArray:[String] = []
    
    //重复数组（周几）
    var repeatNameArray = [
        1:"周一",2:"周二",3:"周三",4:"周四",5:"周五",6:"周六",7:"周日"
    ]
    //重复字符串（需要上传的格式）1,2
    var repeatPostStr = ""
    
    //面试提醒
    var interViewRemindStr = ""
    //面试提醒postValue
    var interViewPostRemindStr = ""
    
    //面试时长
    var interViewTimeLongStr = ""
    //面试时长postValue
    var interViewTimeLongPostStr = ""
    
    //面试人数
    var numOfPeopleStr = ""
    //全局JCAlertView
    var jcAlertView:JCAlertView!
    //开启定时面试（0定时，1不定时）
    var openTimeIng = 0
    //视频储存（0存，1不存）
    var openVideoStrorage = 0
    
    var returnClosure:(()->())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "新增排期"
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: "cell")
        tableView.register(UINib.init(nibName: "OpenChoseCell", bundle: nil), forCellReuseIdentifier: "OpenChoseCell")
        tableView.tableFooterView = createBottomBtn(supView: tableView, title: "保存", actionHander: { (btn) in
            btn.addTarget(self, action: #selector(saveBtnClick), for: .touchUpInside)
        })
        // Do any additional setup after loading the view.
    }
    func saveBtnClick() -> Void {
        print("保存")
        if self.selectjobModel == nil {
            SVProgressHUD.showInfo(withStatus: "请选择职位")
            return
        }
        if self.interViewStartTimeStr == "" || self.interViewEndTimeStr == "" {
            SVProgressHUD.showInfo(withStatus: "请选择面试时间")
            return
        }
        if numOfPeopleStr == "" {
            SVProgressHUD.showInfo(withStatus: "请选择面试人数")
            return
        }
        if interViewTimeLongPostStr == "" {
            SVProgressHUD.showInfo(withStatus: "请选择面试时长")
            return
        }
        
        
        let dic:NSDictionary = [
            "token":GetUser(key: TOKEN),
            "jobId":self.selectjobModel?.jobId! as Any,
            "startTime":self.interViewStartTimeStr,
            "endTime":self.interViewEndTimeStr,
            "repetition":self.repeatPostStr,    //周几重复
            "remind":self.interViewPostRemindStr, //面试提醒
            "timing":self.openTimeIng,           //开启定时面试 0 定时 1 不定时
            "duration":interViewTimeLongPostStr,  //面试时长
            "nums":numOfPeopleStr,               //面试人数
            "storage":openVideoStrorage           //视频存储 0存 1不存
        ]
        let jsonStr = JSON(dic)
        let newDic:NSDictionary = jsonStr.dictionaryValue as NSDictionary
        print("newDic = \(newDic)")
        SVProgressHUD.show()
        HRAddPaiQiInterface(dic: newDic, actionHander: { (jsonStr) in
            if jsonStr["code"] == 0{
                SVProgressHUD.showSuccess(withStatus: "请求成功")
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if section == 0 {
            return 4
        }else if section == 1 {
            return 3
        }else if section == 2 {
            return 1
        }
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell")
       
            cell = UITableViewCell.init(style: .value1, reuseIdentifier: "cell")
            cell?.selectionStyle = .none
            cell?.detailTextLabel?.textColor = UIColor.mainColor
        cell?.textLabel?.font = UIFont.systemFont(ofSize: 14)
        
        if indexPath.section == 0 {
            cell?.accessoryType = .disclosureIndicator
            if indexPath.row == 0 {
                cell?.textLabel?.text = "面试职位"
                cell?.detailTextLabel?.text = self.selectjobModel?.name
            }else if indexPath.row == 1 {
                cell?.textLabel?.text = "面试时间"
                cell?.detailTextLabel?.text = self.interViewStr
            }else if indexPath.row == 2 {
                cell?.textLabel?.text = "重复"
                let repeatStr = self.repeatNameDisplayArray.joined(separator: ",")
                cell?.detailTextLabel?.text = repeatStr
            }else if indexPath.row == 3 {
                cell?.textLabel?.text = "面试提醒"
                cell?.detailTextLabel?.text = self.interViewRemindStr
            }
           
        }else if indexPath.section == 1 {
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "OpenChoseCell") as! OpenChoseCell
                cell.selectionStyle = .none
                cell.nameLabel.text = "开启定时面试"
                cell.bgView.backgroundColor = UIColor.white
                cell.nameLabel.textColor = UIColor.black
                cell.nameLabel.font = UIFont.systemFont(ofSize: 14)
                cell.switchBtnClickColsure = { (btn) in
                    print("btn.isSelect = \(btn.isSelected)")
                    if btn.isSelected == true {
                        self.openTimeIng = 0
                    }else{
                        self.openTimeIng = 1
                    }
                    
                }
                return cell
            }else if indexPath.row == 1 {
                cell?.textLabel?.text = "面试时长"
                cell?.detailTextLabel?.text = self.interViewTimeLongStr
                cell?.accessoryType = .disclosureIndicator
            }else if indexPath.row == 2 {
                cell?.textLabel?.text = "面试人数"
                cell?.detailTextLabel?.text = self.numOfPeopleStr
                cell?.accessoryType = .disclosureIndicator
            }
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "OpenChoseCell") as! OpenChoseCell
            cell.selectionStyle = .none
            cell.nameLabel.text = "视频储存"
            cell.bgView.backgroundColor = UIColor.white
            cell.nameLabel.textColor = UIColor.black
            cell.nameLabel.font = UIFont.systemFont(ofSize: 14)
            cell.switchBtnClickColsure = { (btn) in
                if btn.isSelected == true {
                    self.openVideoStrorage = 0
                }else{
                    self.openVideoStrorage = 1
                }
            }
            return cell
            
        }
        
        return cell!
    }
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 3
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                //面试职位
                //从UserDefault取出发布的职位
                let user = UserDefaults.standard
                let data:NSData = user.object(forKey: HRPOSITION) as! NSData
                self.HRPostjobBassClass = NSKeyedUnarchiver.unarchiveObject(with: data as Data) as? HRPostJobBaseClass
                
                    if let customView = LQPickCustomView.newInstance() {
                        customView.dataArray1.removeAll()
                        let customAlert = JCAlertView.init(customView: customView, dismissWhenTouchedBackground: false)
                        for model in (self.HRPostjobBassClass?.list)! {
                            customView.dataArray1.append(model.name!)
                            customView.dataModelArray1?.append(model)
                        }
                        customAlert?.center = CGPoint.init(x: ScreenWidth/2, y: ScreenHeight - customView.frame.size.height/2-20)
                        customView.titleLabel.text = "面试职位"
                        customView.cancelbtnClickClosure = { (btn) in
                            customAlert?.dismiss(completion: nil)
                        }
                        customView.sureBtnClickclosure = { (btn,selectNum1,selectNum2) in
                            self.selectjobModel = self.HRPostjobBassClass?.list?[selectNum1!]
                            print("self.selectjobModel.name = \(self.selectjobModel?.name)")
                            self.tableView.reloadData()
                            customAlert?.dismiss(completion: nil)
                        }
                        customAlert?.show()
                    }

            }else if indexPath.row == 1 {
                //面试时间
                
                if let customView = LQPickCustomView.newInstance() {
                    customView.dataArray1.removeAll()
                    let customAlert = JCAlertView.init(customView: customView, dismissWhenTouchedBackground: false)
                    customView.dataArray1 = ["6:00","6:30","7:00","7:30","8:00","8:30","9:00","9:30","10:00","10:30","11:00","11:30","12:00","12:30","13:00","13:30","14:00","14:30","15:00","15:30","16:00","16:30","17:00","17:30","18:00","18:30","19:00","19:30","20:00","20:30","21:00","21:30","22:00","22:30","23:00"]
                    customView.dataArray2 = ["6:00","6:30","7:00","7:30","8:00","8:30","9:00","9:30","10:00","10:30","11:00","11:30","12:00","12:30","13:00","13:30","14:00","14:30","15:00","15:30","16:00","16:30","17:00","17:30","18:00","18:30","19:00","19:30","20:00","20:30","21:00","21:30","22:00","22:30","23:00"]
                    customView.numOfComponents = 2
                    customAlert?.center = CGPoint.init(x: ScreenWidth/2, y: ScreenHeight - customView.frame.size.height/2-20)
                    customView.titleLabel.text = "面试时间"
                    customView.cancelbtnClickClosure = { (btn) in
                        customAlert?.dismiss(completion: nil)
                    }
                    customView.sureBtnClickclosure = { (btn,selectNum1,selectNum2) in
                        guard selectNum2! > selectNum1! else {
                            SVProgressHUD.showInfo(withStatus: "开始时间不能大于结束时间")
                            customAlert?.dismiss(completion: nil)
                            return
                        }
                        self.interViewStr = "\(customView.dataArray1[selectNum1!])-\(customView.dataArray2[selectNum2!])"
                        self.interViewStartTimeStr = customView.dataArray1[selectNum1!]
                        self.interViewEndTimeStr = customView.dataArray2[selectNum2!]
                        
                        self.tableView.reloadData()
                        
                        customAlert?.dismiss(completion: nil)
                    }
                    customAlert?.show()
                }

            }else if indexPath.row == 2 {
                //是否重复
                let vc = UIStoryboard.init(name: "UserFirstStoryboard", bundle: nil).instantiateViewController(withIdentifier: "PaiQiRepeatVC") as! PaiQiRepeatVC
                vc.returnClosure = { (array) in
                    self.repeatAttay = array
                    
                    let stringS = array.map{ (number) -> String in
                        var outPut = ""
                        outPut = self.repeatNameArray[number]!
                        return outPut
                    }
                    self.repeatNameDisplayArray = stringS
//                    var numArray:[String] = []
//                    for index in array {
//                        let num = NSNumber.init(value: index)
//                        numArray.append(num.stringValue)
//                    }
                    let numArray:[String] = array.map{
                         NSNumber.init(value: $0).stringValue
                    }
                    self.repeatPostStr = numArray.joined(separator: ",")
                    print("stringS = \(stringS)")
                    self.tableView.reloadData()
                }
                self.navigationController?.pushViewController(vc, animated: true)
            }else if indexPath.row == 3 {
                //面试提醒
                if let customView = LQPickCustomView.newInstance() {
                    customView.dataArray1.removeAll()
                    let customAlert = JCAlertView.init(customView: customView, dismissWhenTouchedBackground: false)
                    customView.dataArray1 = ["10分钟","20分钟","30分钟","40分钟","50分钟","60分钟"]
                    customView.numOfComponents = 1
                    customAlert?.center = CGPoint.init(x: ScreenWidth/2, y: ScreenHeight - customView.frame.size.height/2-20)
                    customView.titleLabel.text = "面试提醒"
                    customView.cancelbtnClickClosure = { (btn) in
                        customAlert?.dismiss(completion: nil)
                    }
                    customView.sureBtnClickclosure = { (btn,selectNum1,selectNum2) in
                   
                        self.interViewRemindStr = "\(customView.dataArray1[selectNum1!])"
                        let timePostArray = ["10","20","30","40","50","60"]
                        self.interViewPostRemindStr = timePostArray[selectNum1!]
                        self.tableView.reloadData()
                        
                        customAlert?.dismiss(completion: nil)
                    }
                    customAlert?.show()
                }

                
            }
        }else if indexPath.section == 1 {
            if indexPath.row == 1 {
                //面试时长
                let array = ["10分钟","20分钟","30分钟","40分钟","50分钟","60分钟"]
                
               self.jcAlertView = createLQPickView(dataArray1:array , dataArray2: nil, numOfComponents: 1, title: "面试时长", sureBtnClickClosure: { (btn, selectNum1, selectNum2) in
                print("确定")
                    self.jcAlertView.dismiss(completion: nil)
                    self.interViewTimeLongStr = array[selectNum1!]
                let timePostArray = ["10","20","30","40","50","60"]
                 self.interViewTimeLongPostStr = timePostArray[selectNum1!]
                    self.tableView.reloadData()
               }, cancelBtnClickClosure: { (btn) in
                print("取消")
                self.jcAlertView.dismiss(completion: nil)
               })
            }else if indexPath.row == 2 {
                var numOfPeopleArray:[String] = []
                //面试人数
                for index in 1...50 {
                    let numStr = NSNumber.init(value: index)
                    numOfPeopleArray.append(numStr.stringValue)
                }
                 self.jcAlertView = createLQPickView(dataArray1: numOfPeopleArray, dataArray2: nil, numOfComponents: 1, title: "面试人数", sureBtnClickClosure: { (btn, selectNum1, selectNum2) in
                    print("确定")
                    self.jcAlertView.dismiss(completion: nil)
                    self.numOfPeopleStr = numOfPeopleArray[selectNum1!]
                    self.tableView.reloadData()
                }, cancelBtnClickClosure: { (btn) in
                    print("取消")
                    self.jcAlertView.dismiss(completion: nil)
                })
            }
        }
    }
    //获得HR发布的职位列表（HR端）
    func getHRPostJobs() -> Void {
        HRPostJobsInterface(dic: ["token":GetUser(key: TOKEN)], actionHander: { (bassClass) in
            self.HRPostjobBassClass = bassClass
            
        }) {
            SVProgressHUD.showInfo(withStatus: "请求失败")
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
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
