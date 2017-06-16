//
//  HRUserCenterVC.swift
//  Reindeer
//
//  Created by shiliuhua on 2017/5/16.
//  Copyright © 2017年 shiliuhua. All rights reserved.
//

import UIKit

class HRUserCenterVC: BaseViewVC,UITableViewDelegate,UITableViewDataSource {

    
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib.init(nibName: "HRUserCenterFirstCell", bundle: nil), forCellReuseIdentifier: "HRUserCenterFirstCell")
        tableView.register(UINib.init(nibName: "UserCenterCell", bundle: nil), forCellReuseIdentifier: "UserCenterCell")
        tableView.isScrollEnabled = false
        tableView.tableFooterView = UIView()
        tableView.backgroundColor = UIColor.init(red: 245/255.0, green: 245/255.0, blue: 245/255.0, alpha: 1)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if section == 0 {
            return 3
        }else if section == 1 {
            return 2
        }else if section == 2 {
            return 2
        }else if section == 3 {
            return 1
        }else{
            return 1
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "HRUserCenterFirstCell") as! HRUserCenterFirstCell
                cell.selectionStyle = .none
                return cell
            }else if indexPath.row == 1 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "UserCenterCell") as! UserCenterCell
                cell.nameLabel.text = "公司信息"
                cell.leftImageView.image = UIImage.init(named: "me_company_icon.png")
                return cell
            }else{
                let cell = tableView.dequeueReusableCell(withIdentifier: "UserCenterCell") as! UserCenterCell
                cell.nameLabel.text = "职位管理"
                cell.leftImageView.image = UIImage.init(named: "me_jobmanage_icon.png")
                return cell
            }
        }else if indexPath.section == 1{
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "UserCenterCell") as! UserCenterCell
                cell.nameLabel.text = "视频管理"
                cell.leftImageView.image = UIImage.init(named: "me_video_icon.png")
                return cell
            }else{
                let cell = tableView.dequeueReusableCell(withIdentifier: "UserCenterCell") as! UserCenterCell
                cell.nameLabel.text = "账户管理"
                cell.leftImageView.image = UIImage.init(named: "me_account_icon.png")
                return cell
            }
        
        }else if indexPath.section == 2 {
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "UserCenterCell") as! UserCenterCell
                cell.nameLabel.text = "邀请同事"
                cell.leftImageView.image = UIImage.init(named: "me_invitation_icon.png")
                return cell
            }else{
                let cell = tableView.dequeueReusableCell(withIdentifier: "UserCenterCell") as! UserCenterCell
                cell.nameLabel.text = "认证状态"
                cell.leftImageView.image = UIImage.init(named: "me_authentication_icon.png")
                return cell
            }
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "UserCenterCell") as! UserCenterCell
            cell.nameLabel.text = "设置"
            cell.leftImageView.image = UIImage.init(named: "me_setting_icon.png")
            return cell
        }
        
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 3 {
            return 50
        }
        
        return 10
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0
        }
        return 10
    }
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 4
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                return 150
            }
        }
        return 60
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            if indexPath.row == 2 {
                print("点击职位管理")
                let vc = UIStoryboard(name: "UserCenter", bundle: nil).instantiateViewController(withIdentifier: "HRPositionManagerVC") as! HRPositionManagerVC
                self.navigationController?.pushViewController(vc, animated: true)
            }else if indexPath.row == 1 {
                print("点击公司信息")
                let vc = UIStoryboard.init(name: "LoginAndUserStoryboard", bundle: nil).instantiateViewController(withIdentifier: "CompleteCompanyMesVC") as! CompleteCompanyMesVC
                
                vc.enterType = .userCenterEnter
                vc.companyId = GetUser(key: COMPANYID) as! String
                
                self.navigationController?.pushViewController(vc, animated: true)
                
            }
        }else if indexPath.section == 1 {
            if indexPath.row == 0 {
                print("点击了视频管理")
            }else if indexPath.row == 1 {
                print("点击账户管理")
            }
        }else if indexPath.section == 2 {
            if indexPath.row == 0 {
                print("邀请同事")
            }else if indexPath.row == 1 {
                print("认证状态")
            }
            
        }else if indexPath.section == 3 {
            print("设置")
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
