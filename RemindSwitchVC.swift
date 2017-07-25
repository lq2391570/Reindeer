//
//  RemindSwitchVC.swift
//  Reindeer
//
//  Created by shiliuhua on 2017/6/29.
//  Copyright © 2017年 shiliuhua. All rights reserved.
//

import UIKit
import SwiftyJSON
import SVProgressHUD
class RemindSwitchVC: BaseViewVC,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet var tableView: UITableView!
    //个人信息json
    var userMesJson:JSON?
    //推送开关是否打开
    var isOpenPush = false
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib.init(nibName: "OpenChoseCell", bundle: nil), forCellReuseIdentifier: "OpenChoseCell")
        tableView.rowHeight = 70
        
        getSwitchMes()
        // Do any additional setup after loading the view.
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OpenChoseCell") as! OpenChoseCell
        cell.nameLabel.textColor = UIColor.black
        cell.bgView.backgroundColor = UIColor.white
        cell.switchBtn.isSelected = self.isOpenPush
    cell.nameLabel.text = "消息通知"
        cell.switchBtnClickColsure = { btn in
            if btn.isSelected == false {
//                createAlert(title: "提示", message: "关掉消息通知会收不到推送", viewControll: self, closure: {
                    pushSwitchInterface(dic: ["token":GetUser(key: TOKEN)], actionHander: { (jsonStr) in
                        if jsonStr["code"] == 0 {
                            SVProgressHUD.showSuccess(withStatus: "操作成功")
                            self.getSwitchMes()
                        }else{
                            SVProgressHUD.showInfo(withStatus: jsonStr["msg"].stringValue)
                        }
                        
                    }) {
                        SVProgressHUD.showInfo(withStatus: "请求失败")
                    }

            //    })
            }else{
                pushSwitchInterface(dic: ["token":GetUser(key: TOKEN)], actionHander: { (jsonStr) in
                    if jsonStr["code"] == 0 {
                        SVProgressHUD.showSuccess(withStatus: "操作成功")
                        self.getSwitchMes()
                    }else{
                        SVProgressHUD.showInfo(withStatus: jsonStr["msg"].stringValue)
                    }
                    
                }) {
                    SVProgressHUD.showInfo(withStatus: "请求失败")
                }
                
            }
            
        }
        return cell
    }
    //获取个人信息（设置推送）
    func getSwitchMes() -> Void {
        getUserMes(dic: ["token":GetUser(key: TOKEN)], actionHandler: { (jsonStr) in
            if jsonStr["code"] == 0 {
                print("jsonStr = \(jsonStr)")
                self.userMesJson = jsonStr
                if jsonStr["openPush"] == 0 {
                    self.isOpenPush = true
                }else{
                    self.isOpenPush = false
                }
                
                self.tableView.reloadData()
            }
        }) {
            print("请求失败")
        }

    }
    
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 1
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1
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
