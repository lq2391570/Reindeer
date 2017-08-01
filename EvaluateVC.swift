//
//  EvaluateVC.swift
//  Reindeer
//
//  Created by shiliuhua on 2017/6/1.
//  Copyright © 2017年 shiliuhua. All rights reserved.
//

import UIKit
import SwiftyJSON
import SVProgressHUD
class EvaluateVC: BaseViewVC,UITableViewDelegate,UITableViewDataSource {

    
    @IBOutlet var tableView: UITableView!
    
    @IBOutlet var bottomView: UIView!
    
    @IBOutlet var yueLabel: UILabel!
    
    var interViewId:Int!
    
    var avatar:String = ""
    
    var name:String = ""
    
    var job:String = ""
    
    var company:String = ""
    
    
    //面试时长
    var timeStr:String = ""
    //满意度
    var satis:Int = 1
    //评论内容
    var content:String = ""
    //是否存储视频
    var storeVideo:Int = 0
    //账户余额
    var balance = "0"
    //dissmiss回调处理
    var dissmissClosure:(() -> ())?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "评价"
        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib.init(nibName: "EvaluateCell2", bundle: nil), forCellReuseIdentifier: "EvaluateCell2")
        tableView.register(UINib.init(nibName: "EvaluateCell1", bundle: nil), forCellReuseIdentifier: "EvaluateCell1")
        tableView.register(UINib.init(nibName: "OpenChoseCell", bundle: nil), forCellReuseIdentifier: "OpenChoseCell")
        self.getUserMes(interviewId: self.interViewId)
        getAccountBalance()
    }
    @IBAction func commitClick(_ sender: UIButton) {
        print("时长：\(timeStr),满意度：\(satis),评论内容：\(content),是否存储视频：\(storeVideo)")
        SVProgressHUD.show()
        let dic = [
            "token":GetUser(key: TOKEN),
            "id":interViewId,  // 面试id
            "duration":30, // 面试时长
            "satis":satis,    //满意度
            "content":content, //评论内容
            "storeVideo":storeVideo
        ]
        let jsonStr = JSON(dic)
        let newDic:NSDictionary = jsonStr.dictionaryValue as NSDictionary
        
        interViewEvaluate(dic: newDic, actionHander: { (jsonStr) in
            if jsonStr["code"] == 0 {
                
                SVProgressHUD.showSuccess(withStatus: "评论成功")
                if self.dissmissClosure != nil {
                    self.dissmissClosure!()
                }
                self.dismiss(animated: true, completion: nil)
                
            }else{
                
                SVProgressHUD.showSuccess(withStatus: jsonStr["msg"].stringValue)
            }
            
        }) { 
            
        }
        
        
        
    }
    //获得视频通话个人信息
    func getUserMes(interviewId:Int) -> Void {
        getVideoInfoMes(dic: ["token":GetUser(key: TOKEN),"id":interviewId], actionHander: { (jsonStr) in
            if jsonStr["code"] == 0 {
                self.avatar = jsonStr["avatar"].stringValue
                self.name = jsonStr["name"].stringValue
                self.job = jsonStr["job"].stringValue
                self.company = jsonStr["company"].stringValue
            }
            
        }) { 
            
        }
        
    }
    //获得账户余额
    func getAccountBalance() -> Void {
        getAccountBalanceInterface(dic: ["token":GetUser(key: TOKEN)], actionHander: { (jsonStr) in
            if jsonStr["code"] == 0 {
                self.balance = jsonStr["balance"].stringValue
                
            }
        }) { 
            
        }
        
    }
    
    override func leftReturnBtnClick() -> Void {
        createAlert(title: "提示", message: "是否放弃评论", viewControll: self) { 
            print("返回")
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "EvaluateCell1") as! EvaluateCell1
            cell.installCell(time: self.timeStr, headImageStr: self.avatar, nameAndJob: "\(self.name)|\(self.job)")
            return cell
        }else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "EvaluateCell2") as! EvaluateCell2
            cell.choseBtnClosure = { sender in
                self.satis = sender.tag
            }
            cell.textfieldTextClosure = { textField in
                self.content = textField.text!
            }
            return cell
        }else if indexPath.section == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "OpenChoseCell") as! OpenChoseCell
            cell.switchBtnClickColsure = { sender in
                if sender.isSelected == true {
                    self.storeVideo = 0
                }else{
                    self.storeVideo = 1
                }
                
            }
            return cell
            
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "OpenChoseCell") as! OpenChoseCell
            cell.switchBtnClickColsure = { sender in
                if sender.isSelected == true {
                    self.storeVideo = 0
                }else{
                    self.storeVideo = 1
                }
                
            }
            
            return cell
            
        }
    }
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 3
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 210
        }else if indexPath.section == 1 {
            return 210
        }else if indexPath.section == 2 {
            return 60
        }
        return 0
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0
        }
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
