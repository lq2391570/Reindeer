//
//  UserCenterFirstVC.swift
//  Reindeer
//
//  Created by shiliuhua on 17/2/22.
//  Copyright © 2017年 shiliuhua. All rights reserved.
//

import UIKit

class UserCenterFirstVC: BaseViewVC,UITableViewDelegate,UITableViewDataSource {

   
    @IBOutlet var headImageView: UIImageView!
    
    @IBOutlet var nameLabel: UILabel!
    
    @IBOutlet var sexLabel: UILabel!
    
    @IBOutlet var successProLabel: UILabel!
    
    @IBOutlet var tableView: UITableView!
    
     var titleArray = ["简历管理","上传简历附件","积分任务","成就","设置"]
    override func viewDidLoad() {
        super.viewDidLoad()
       
        self.title  = "个人中心"
        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib.init(nibName: "UserCenterCell", bundle: nil), forCellReuseIdentifier: "UserCenterCell")
        
        headImageView.layer.cornerRadius = 50
        headImageView.layer.masksToBounds = true
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if section == 0 {
            return 2
        }else if section == 1 {
            return 2
        }else{
            return 1
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            let vc = UIStoryboard(name: "UserCenter", bundle: nil).instantiateViewController(withIdentifier: "ResumeManagerVC") as! ResumeManagerVC
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        if section == 0 {
            return 1
        }else{
            return 10
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserCenterCell") as! UserCenterCell
        if indexPath.section == 0 {
            cell.nameLabel.text = titleArray[indexPath.row]
        }else if indexPath.section == 1 {
            cell.nameLabel.text = titleArray[indexPath.row+2]
        }else{
            cell.nameLabel.text = titleArray[4]
        }
        
        return cell
        
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
