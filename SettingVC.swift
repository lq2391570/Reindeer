//
//  SettingVC.swift
//  Reindeer
//
//  Created by shiliuhua on 2017/4/28.
//  Copyright © 2017年 shiliuhua. All rights reserved.
//

import UIKit
import SVProgressHUD
class SettingVC: BaseViewVC,UITableViewDelegate,UITableViewDataSource {

    
    @IBOutlet var tableView: UITableView!
    
    var section1NameArray = ["设置提醒","修改手机号","修改密码"]
    var section1ImageNameArray = ["remind_setting_icon.png","modification_phone_icon.png","modification_password_icon.png"]
    
    var section2NameArray = ["帮助与反馈","关于我们"]
    var section2ImageNameArray = ["help_back_icon.png","about_icon.png"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib.init(nibName: "SettingCell", bundle: nil), forCellReuseIdentifier: "SettingCell")
        tableView.rowHeight = 70
        tableView.tableFooterView = createBottomBtn(supView: tableView, title: "退出登录", actionHander: { (btn) in
            btn.addTarget(self, action: #selector(exitBtnClick), for: .touchUpInside)
            
        })
        
    }
    func exitBtnClick() -> Void {
        print("退出登录")
        
        
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if section == 0 {
            return 3
        }else if section == 1 {
            return 2
        }else{
            return 1
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingCell") as! SettingCell
        if indexPath.section == 0 {
            cell.nameLabel.text = section1NameArray[indexPath.row]
            cell.leftImageView.image = UIImage.init(named: section1ImageNameArray[indexPath.row])
        }else if indexPath.section == 1 {
            cell.nameLabel.text = section2NameArray[indexPath.row]
            cell.leftImageView.image = UIImage.init(named: section2ImageNameArray[indexPath.row])
        }else{
            cell.nameLabel.text = "切换身份"
            cell.leftImageView.image = UIImage.init(named: "switch_roles_icon.png")
        }
        return cell
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                //设置提醒
                let vc = RemindSwitchVC()
                vc.title = "设置提醒"
                self.navigationController?.pushViewController(vc, animated: true)
            }else if indexPath.row == 1 {
                //修改手机号
                let vc = ChangePhoneNumVC()
                vc.title = "修改手机号"
                self.navigationController?.pushViewController(vc, animated: true)
            }else if indexPath.row == 2 {
                //修改密码
                let vc = ChangeMiMaVC()
                vc.title = "修改密码"
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }else if indexPath.section == 1 {
            if indexPath.row == 0 {
                //帮助与反馈
                
            }else if indexPath.row == 1 {
                //关于我们
    
            }
            
        }
        
        if indexPath.section == 2 {
            createActionSheet(title: "提示", message: "切换身份", stringArray: ["应聘者","HR"], viewController: self, closure: { (index) in
                print("点击了第\(index)个")
                if index == 0 {
                    //应聘者
                    switchIdentity(jobFanderOrHR: 1, actionHander: { (jsonStr) in
                        if jsonStr["code"] == 0 {
                            SVProgressHUD.showSuccess(withStatus: "切换成功")
                        }else{
                            SVProgressHUD.showInfo(withStatus: jsonStr["msg"].stringValue)
                        }
                    }, fail: { 
                        SVProgressHUD.showInfo(withStatus: "请求失败")
                    })
                }else if index == 1 {
                    //HR
                    switchIdentity(jobFanderOrHR: 2, actionHander: { (jsonStr) in
                        if jsonStr["code"] == 0 {
                            SVProgressHUD.showSuccess(withStatus: "切换成功")
                        }else{
                            SVProgressHUD.showInfo(withStatus: jsonStr["msg"].stringValue)
                        }
                    }, fail: {
                        SVProgressHUD.showInfo(withStatus: "请求失败")
                    })
                }
                
            })
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 3
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
