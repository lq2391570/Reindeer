//
//  HRUserCenterNewVC.swift
//  Reindeer
//
//  Created by shiliuhua on 2017/8/14.
//  Copyright © 2017年 shiliuhua. All rights reserved.
//

import UIKit
import SwiftyJSON
class HRUserCenterNewVC: BaseViewVC,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet var tableView: UITableView!
    
    var jsonStr:JSON?
    var resumeBassClass:ResumeBaseClass?
    var hrMesBassClass:HRUserMesBaseClass?
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib.init(nibName: "UserCenterNewCell1", bundle: nil), forCellReuseIdentifier: "UserCenterNewCell1")
        tableView.register(UINib.init(nibName: "UserCenterNewCell2", bundle: nil), forCellReuseIdentifier: "UserCenterNewCell2")
        tableView.register(UINib.init(nibName: "UserCenterCell", bundle: nil), forCellReuseIdentifier: "UserCenterCell")
        HRGetUserMes()
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
        // UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent;
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
        //  UIApplication.shared.statusBarStyle = UIStatusBarStyle.default
    }

    //获取HR个人信息
    func HRGetUserMes() -> Void {
        HRUserMesInterface(dic: ["token":GetUser(key: TOKEN)], actionHander: { (bassClass) in
            self.hrMesBassClass = bassClass
            self.tableView.reloadData()
        }) {
            print("请求失败")
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 1
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "UserCenterNewCell1") as! UserCenterNewCell1
            cell.installCell(headImage: self.hrMesBassClass?.avatar, name: self.hrMesBassClass?.name, sex: self.hrMesBassClass?.sex, zhunDianLv: "准点率:\(self.hrMesBassClass?.callRate ?? "")", numOfInterface: "0", numOfInterfaceAll: "0", duringOfInterface: "0")
            cell.settingImageView.isHidden = false
            cell.titleLabel1.text = "总面试(人数)"
            cell.titleLabel2.text = "总面试时长(小时)"
            cell.titleLabel3.text = "推荐(人数)"
            cell.renzhengImage.isHidden = false
            if self.hrMesBassClass?.authentic == 1 {
                cell.renzhengImage.image = UIImage.init(named: "认证.png")
            }
            cell.returnBtnClickClosure = {
                _ = self.navigationController?.popViewController(animated: true)
            }
            cell.settingClosure = {
                //设置
                print("设置")
                let vc = UIStoryboard(name: "UserCenter", bundle: nil).instantiateViewController(withIdentifier: "SettingVC") as! SettingVC
                vc.title = "设置"
                self.navigationController?.pushViewController(vc, animated: true)
                
            }
            
            return cell
        }else if indexPath.section == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "UserCenterNewCell2") as! UserCenterNewCell2
            cell.interfaceManagerCell()
            cell.zhiweiguanliClosure = {
                //职位管理
                let vc = UIStoryboard(name: "UserCenter", bundle: nil).instantiateViewController(withIdentifier: "HRPositionManagerVC") as! HRPositionManagerVC
                self.navigationController?.pushViewController(vc, animated: true)
            }
            cell.wodetongshiClosure = {
                //我的同事
                let vc = UIStoryboard(name: "UserCenter", bundle: nil).instantiateViewController(withIdentifier: "MyColleagueVC") as! MyColleagueVC
                self.navigationController?.pushViewController(vc, animated: true)
                
            }
            cell.shipinguanliClosure = {
                //视频管理
            }
            cell.zhanghuguanliClosure = {
                //账户管理
                let vc = UIStoryboard(name: "UserCenter", bundle: nil).instantiateViewController(withIdentifier: "AccountVC") as! AccountVC
                vc.title = "账户管理"
                self.navigationController?.pushViewController(vc, animated: true)
            }
            return cell
        }else if indexPath.section == 3 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "UserCenterNewCell2") as! UserCenterNewCell2
            cell.inviteCell()
            
            cell.rencaituijianClosure = {
                //人才推荐
                let vc = TalentRecommendList()
                vc.title = "人才推荐"
                self.navigationController?.pushViewController(vc, animated: true)
            }
            cell.wodeyaoqingClosure = {
                //我的邀请
                print("我的邀请")
                let vc = UIStoryboard(name: "UserCenter", bundle: nil).instantiateViewController(withIdentifier: "MyInviteVC") as! MyInviteVC
                self.navigationController?.pushViewController(vc, animated: true)
            }
            cell.renzhengzhuangtaiClosure = {
                //认证状态
            }
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "UserCenterCell") as! UserCenterCell
            cell.leftImageView.image = UIImage.init(named: "me_company_icon")
            cell.nameLabel.text = self.hrMesBassClass?.company
            return cell
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 210
        }else if indexPath.section == 1 {
            return 70
        }else{
            return 100
        }
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 0 {
            return 1
        }else if section == 1 {
            return 10
        }else{
            return 5
        }
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 1
        }else if section == 1 {
            return 1
        }else {
            return 5
        }
        
    }
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 4
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //完善个人信息
        if indexPath.section == 0 {
            print("点击完善个人信息")
            let vc = UIStoryboard(name: "LoginAndUserStoryboard", bundle: nil).instantiateViewController(withIdentifier: "CompleteHRMesVC") as! CompleteHRMesVC
            
            vc.enterTypeEnum = .userCenterEnter
            vc.hrMesBassClass = self.hrMesBassClass
            vc.saveSucceedClosure = {
                self.HRGetUserMes()
            }
            self.navigationController?.pushViewController(vc, animated: true)

        }else if indexPath.section == 1 {
            //点击公司
            let vc = UIStoryboard.init(name: "LoginAndUserStoryboard", bundle: nil).instantiateViewController(withIdentifier: "CompleteCompanyMesVC") as! CompleteCompanyMesVC
            vc.enterType = .userCenterEnter
            vc.companyId = GetUser(key: COMPANYID) as! String
            vc.returnClosure = {
                self.HRGetUserMes()
            }
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
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
