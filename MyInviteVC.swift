//
//  MyInviteVC.swift
//  Reindeer
//
//  Created by shiliuhua on 2017/8/21.
//  Copyright © 2017年 shiliuhua. All rights reserved.
//

import UIKit

class MyInviteVC: BaseViewVC,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet var tableView: UITableView!
    
    var bassClass:MyInviteMyInviteBassClass?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "我的邀请"
        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib.init(nibName: "HRMyInviteCell1", bundle: nil), forCellReuseIdentifier: "HRMyInviteCell1")
        tableView.register(UINib.init(nibName: "HRMyInviteCell2", bundle: nil), forCellReuseIdentifier: "HRMyInviteCell2")
        tableView.register(UINib.init(nibName: "InvitePeopleCell", bundle: nil), forCellReuseIdentifier: "InvitePeopleCell")
        MyInvitelist()
    }
    //获取我的邀请列表
    func MyInvitelist() -> Void {
       HRMyInviterList(dic: ["token":GetUser(key: TOKEN),"no":1,"size":100], actionHander: { (bassClass) in
        self.bassClass = bassClass
        self.tableView.reloadData()
        
       }) { 
        
    }
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if self.bassClass != nil {
            if indexPath.section == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "InvitePeopleCell") as! InvitePeopleCell
                cell.nameLabel.text = "我要邀请"
                return cell
            }else{
                let model:MyInviteList = (self.bassClass?.list![indexPath.section - 1])!
                if model.accept == 0 {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "HRMyInviteCell2") as! HRMyInviteCell2
                    cell.installCell(headImageStr: model.avatar, name: model.name, area: model.area, year: model.exp, edu: model.edu, remark: model.remark, inviteClickClosure: { (btn) in
                        print("邀请视频点击")
                        
                    })
                    return cell
                }else{
                    let cell = tableView.dequeueReusableCell(withIdentifier: "HRMyInviteCell1") as! HRMyInviteCell1
                    cell.installCell(headImageStr: model.avatar, name: model.name, phoneNum: model.phone, remark: model.remark)
                    return cell
                    
                }
//                let cell = tableView.dequeueReusableCell(withIdentifier: "HRMyInviteCell1") as! HRMyInviteCell1
//                cell.installCell(headImageStr: model.avatar, name: model.name, phoneNum: model.phone, remark: model.remark)
//                return cell
                
            }

        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "InvitePeopleCell") as! InvitePeopleCell
            cell.nameLabel.text = "我要邀请"
            return cell
        }
        
        
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            let vc = UIStoryboard(name: "UserCenter", bundle: nil).instantiateViewController(withIdentifier: "GotoInviteVC") as! GotoInviteVC
            vc.returnClosure = {
                self.MyInvitelist()
            }
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    func numberOfSections(in tableView: UITableView) -> Int
    {
        if self.bassClass != nil {
            return (self.bassClass?.list?.count)! + 1
        }
        return 1
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if self.bassClass != nil {
            
            if indexPath.section == 0 {
                return 60
            }else{
                let model:MyInviteList = (self.bassClass?.list![indexPath.section - 1])!
                if model.accept == 0 {
                    return 130
                }else{
                    return 80
                }
            }
        }
        return 44
        
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 1
        }else{
            return 10
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
