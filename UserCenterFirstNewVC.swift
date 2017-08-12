//
//  UserCenterFirstNewVC.swift
//  Reindeer
//
//  Created by shiliuhua on 2017/8/11.
//  Copyright © 2017年 shiliuhua. All rights reserved.
//

import UIKit
import SwiftyJSON
class UserCenterFirstNewVC: BaseViewVC,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet var tableView: UITableView!
    
    var jsonStr:JSON?
     var resumeBassClass:ResumeBaseClass?
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib.init(nibName: "UserCenterNewCell1", bundle: nil), forCellReuseIdentifier: "UserCenterNewCell1")
        tableView.register(UINib.init(nibName: "UserCenterNewCell2", bundle: nil), forCellReuseIdentifier: "UserCenterNewCell2")
        tableView.tableFooterView = UIView()
        getUserMesAndImage()
        getJobIntension()
    }
    //获取个人资料
    func getUserMesAndImage() -> Void {
        userMesInfoInterface(dic: ["token":GetUser(key: TOKEN)], actionHander: { (jsonStr) in
            if jsonStr["code"] == 0 {
                print("jsonStr = \(jsonStr)")
                self.jsonStr = jsonStr
                self.tableView.reloadData()
//                self.nameLabel.text = jsonStr["name"].stringValue
//                self.sexLabel.text = jsonStr["sex"].stringValue
//                self.headImageView.sd_setImage(with: URL.init(string: jsonStr["avatar"].stringValue), placeholderImage: UIImage.init(named: "默认头像_男.png"))
//                self.successProLabel.text = "接通率：\(jsonStr["callRate"].stringValue)"
            }
            
        }) {
            print("请求失败")
        }
    }
    //（首次）获取简历id
    func getJobIntension() -> Void {
        searchUserResume(dic: ["token":GetUser(key: TOKEN)], actionHander: { (bassClass) in
            self.resumeBassClass = bassClass
            print("self.resumeBassClass = \(self.resumeBassClass)")
              self.tableView.reloadData()
        }) {
            //  SVProgressHUD.showInfo(withStatus: "请求失败")
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
       // UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent;
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
      //  UIApplication.shared.statusBarStyle = UIStatusBarStyle.default
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 1
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 1
        }else if section == 1{
            return 1
        }else{
            return 5
        }
        
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 0 {
            return 1
        }else{
            return 5
        }
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "UserCenterNewCell1") as! UserCenterNewCell1
            
            cell.installCell(headImage: self.jsonStr?["avatar"].stringValue, name: self.jsonStr?["name"].stringValue, sex: self.jsonStr?["sex"].stringValue, zhunDianLv: self.jsonStr?["callRate"].stringValue, numOfInterface: "0", numOfInterfaceAll: "0", duringOfInterface: "0")
            cell.returnBtnClickClosure = {
                _ = self.navigationController?.popViewController(animated: true)
            }
            return cell
        }else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "UserCenterNewCell2") as! UserCenterNewCell2
            cell.resumeManagerCell()
            cell.jianliguanliClosure = {
            //简历管理
                let vc = UIStoryboard(name: "UserCenter", bundle: nil).instantiateViewController(withIdentifier: "ResumeManagerVC") as! ResumeManagerVC
                vc.resumeBassClass = self.resumeBassClass
                self.navigationController?.pushViewController(vc, animated: true)
                
            }
            cell.shangchuanfujianClosure = {
                //上传附件
            }
            cell.shuaxinjianliClosure = {
                //刷新简历
            }
            cell.diannaodengluClosure = {
                //电脑登录
                //扫码登陆
                let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "QRCodeVC")
                vc.title = "扫码登录"
                self.navigationController?.pushViewController(vc, animated: true)
                
            }
        
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "UserCenterNewCell2") as! UserCenterNewCell2
            cell.accountManagerCell()
            cell.wodezhanghuClosure = {
                //我的账户
                
            }
            cell.jifenrenwuClosure = {
                //积分任务
            }
            cell.chengjiuClosure = {
                //成就
            }
            cell.shezhiClosure = {
                //设置
                let vc = UIStoryboard(name: "UserCenter", bundle: nil).instantiateViewController(withIdentifier: "SettingVC") as! SettingVC
                vc.title = "设置"
                self.navigationController?.pushViewController(vc, animated: true)
            }
            
            return cell
        }
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            //修改个人资料
            print("dianji touxiang")
            let vc = UIStoryboard(name: "LoginAndUserStoryboard", bundle: nil).instantiateViewController(withIdentifier: "CompleteUserMesVC") as! CompleteUserMesVC
            vc.enterType = .userCenterEnter
            vc.returnClosure = {
                self.getUserMesAndImage()
            }
            self.navigationController?.pushViewController(vc, animated: true)
            
        }
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.section == 0 {
            return 210
        }else{
            return 100
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
