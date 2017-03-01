//
//  ResumeManagerVC.swift
//  Reindeer
//
//  Created by shiliuhua on 17/2/22.
//  Copyright © 2017年 shiliuhua. All rights reserved.
//

import UIKit

class ResumeManagerVC: UIViewController,UITableViewDelegate,UITableViewDataSource {

    
    @IBOutlet var tableView: UITableView!
    //工作经验数组
    var workExperienceArray:NSMutableArray = []
    //教育经历数组
    var eduExperArray:NSMutableArray = []
    
    @IBOutlet var previewBtn: UIButton!
    var nameArray = ["求职意向","我的优势","社交主页"]
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = "简历管理"
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib.init(nibName: "AddImageCell", bundle: nil), forCellReuseIdentifier: "AddImageCell")
        tableView.register(UINib.init(nibName: "UserCenterCell", bundle: nil), forCellReuseIdentifier: "UserCenterCell")
        tableView.register(UINib.init(nibName: "OpenChoseCell", bundle: nil), forCellReuseIdentifier: "OpenChoseCell")
        tableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: "cell")
        tableView.backgroundColor = UIColor(hexColor: "f9f6f4")
       
        previewBtn.setTitleColor(UIColor.mainColor, for: .normal)
        
    }
    @IBAction func previewBtnClick(_ sender: UIButton) {
        print("预览点击")
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                let vc = UIStoryboard(name: "UserCenter", bundle: nil).instantiateViewController(withIdentifier: "JobIntensionVC") as!JobIntensionVC
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if indexPath.section == 0 {
            return 70
        }else if indexPath.section == 1 {
            if indexPath.row == workExperienceArray.count {
                return 60
            }else{
                return 50
            }
        }else if indexPath.section == 2 {
            if indexPath.row == workExperienceArray.count {
                return 60
            }else{
                return 50
            }
        }else{
            return 70
        }
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        if section == 0 {
            return 1
        }else{
            return 10
        }
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat
    {
        return 10
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if section == 0 {
            return 3
        }else if section == 1 {
            return workExperienceArray.count + 1
        }else if section == 2 {
            return eduExperArray.count + 1
        }else{
            return 1
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "UserCenterCell") as! UserCenterCell
            cell.nameLabel.text = nameArray[indexPath.row]
            
            return cell
        }else if indexPath.section == 1 {
            if indexPath.row == workExperienceArray.count {
                let cell = tableView.dequeueReusableCell(withIdentifier: "AddImageCell") as! AddImageCell
                cell.bgView.backgroundColor = UIColor.white
                cell.nameLabel.text = "添加工作经验"
                return cell
            }else{
                let workExpCell = tableView.dequeueReusableCell(withIdentifier: "cell")
                return workExpCell!
            }
        }else if indexPath.section == 2 {
            if indexPath.row == eduExperArray.count {
                let cell = tableView.dequeueReusableCell(withIdentifier: "AddImageCell") as! AddImageCell
                cell.bgView.backgroundColor = UIColor.white
                cell.nameLabel.text = "添加教育经历"
                return cell
            }else{
                let eduExpCell = tableView.dequeueReusableCell(withIdentifier: "cell")
                return eduExpCell!
            }
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "OpenChoseCell") as! OpenChoseCell
            cell.bgView.backgroundColor = UIColor.white
            return cell
        }
        
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        
        return 4
        
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
