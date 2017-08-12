//
//  ResumeManagerVC.swift
//  Reindeer
//
//  Created by shiliuhua on 17/2/22.
//  Copyright © 2017年 shiliuhua. All rights reserved.
//

import UIKit
import SVProgressHUD
class ResumeManagerVC: BaseViewVC,UITableViewDelegate,UITableViewDataSource {

    
    @IBOutlet var tableView: UITableView!
    //工作经验数组
    var workExperienceArray:NSMutableArray = []
    //教育经历数组
    var eduExperArray:NSMutableArray = []
    
    @IBOutlet var previewBtn: UIButton!
    var nameArray = ["求职意向","我的优势","社交主页"]
    var imageNameArray = ["6求职意向","7我的优势","8社交主页"]
    
    var resumeBassClass:ResumeBaseClass?
    
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
        getJobIntension()
    }
    @IBAction func previewBtnClick(_ sender: UIButton) {
        print("预览点击")
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                let vc = UIStoryboard(name: "UserCenter", bundle: nil).instantiateViewController(withIdentifier: "JobIntensionVC") as!JobIntensionVC
                self.navigationController?.pushViewController(vc, animated: true)
            }else if indexPath.row == 1 {
                //我的优势（textViewVC）
                let vc = TextViewVC()
                vc.placeholdText = "输入你的优势，让HR更好的了解你..."
                vc.textViewTypeEnum = .typeAdvantage
                vc.navTitle = "我的优势"
                vc.resumeBassClass = self.resumeBassClass
                vc.saveBtnClickClosure = { (text) in
                    self.getJobIntension()
                 delay(0.5){
                        SVProgressHUD.showSuccess(withStatus: "更新成功")
                 }
                    
                }
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }else if indexPath.section == 1 {
            if indexPath.row == self.resumeBassClass?.workExpList?.count {
                //添加
                let vc = UIStoryboard.init(name: "UserCenter", bundle: nil).instantiateViewController(withIdentifier: "AddJobExeVC") as! AddJobExeVC
                vc.resumeBassClass = self.resumeBassClass
                vc.typeOfWorkExpAddOrUpdate = .addWorkExp
                vc.returnClosure = {
                    self.getJobIntension()
                }
                self.navigationController?.pushViewController(vc, animated: true)
            }else{
                //更新
                let vc = UIStoryboard.init(name: "UserCenter", bundle: nil).instantiateViewController(withIdentifier: "AddJobExeVC") as! AddJobExeVC
                vc.resumeBassClass = self.resumeBassClass
                vc.typeOfWorkExpAddOrUpdate = .updateWorkExp
                vc.workExpId = NSNumber.init(value: (self.resumeBassClass?.workExpList?[indexPath.row].id)!).stringValue
                vc.returnClosure = {
                    self.getJobIntension()
                }
                self.navigationController?.pushViewController(vc, animated: true)
                
            }
                
        }else if indexPath.section == 2 {
            //添加教育经历
            if indexPath.row == self.resumeBassClass?.eduExpList?.count {
                //添加
                let vc = UIStoryboard.init(name: "UserCenter", bundle: nil).instantiateViewController(withIdentifier: "AddEduExpVC") as! AddEduExpVC
                vc.resumeBassClass = self.resumeBassClass
                vc.typeOfEduExpAddOrUpdate = .addEduExp
                vc.returnClosure = {
                     self.getJobIntension()
                }
                self.navigationController?.pushViewController(vc, animated: true)
                
                
            }else{
                //更新
                let vc = UIStoryboard(name: "UserCenter", bundle: nil).instantiateViewController(withIdentifier: "AddEduExpVC") as! AddEduExpVC
                vc.resumeBassClass = self.resumeBassClass
                vc.typeOfEduExpAddOrUpdate = .updateEduExp
                vc.eduExpId = NSNumber.init(value: (self.resumeBassClass?.eduExpList?[indexPath.row].id)!).stringValue
                vc.returnClosure = {
                    self.getJobIntension()
                }
                self.navigationController?.pushViewController(vc, animated: true)
                
            }
            
        }
        
    }
    //获取简历id
    func getJobIntension() -> Void {
        searchUserResume(dic: ["token":GetUser(key: TOKEN)], actionHander: { (bassClass) in
            self.resumeBassClass = bassClass
            print("self.resumeBassClass = \(self.resumeBassClass)")
            
              self.tableView.reloadData()
        }) {
          //  SVProgressHUD.showInfo(withStatus: "请求失败")
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
            return (self.resumeBassClass?.workExpList?.count)! + 1
        }else if section == 2 {
            return (self.resumeBassClass?.eduExpList?.count)! + 1
        }else{
            return 1
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "UserCenterCell") as! UserCenterCell
            cell.nameLabel.text = nameArray[indexPath.row]
            cell.leftImageView.image = UIImage(named: imageNameArray[indexPath.row])
            return cell
        }else if indexPath.section == 1 {
            if indexPath.row == self.resumeBassClass?.workExpList?.count {
                let cell = tableView.dequeueReusableCell(withIdentifier: "AddImageCell") as! AddImageCell
                cell.bgView.backgroundColor = UIColor.white
                cell.nameLabel.text = "添加工作经验"
                return cell
            }else{
                var workExpCell = tableView.dequeueReusableCell(withIdentifier: "cell")
                workExpCell = UITableViewCell.init(style: .value1, reuseIdentifier: "cell")
                let workExpModel:ResumeWorkExpList = (self.resumeBassClass?.workExpList![indexPath.row])!
                workExpCell?.textLabel?.text = workExpModel.company
                workExpCell?.detailTextLabel?.text = workExpModel.times
                return workExpCell!
            }
        }else if indexPath.section == 2 {
            if indexPath.row == self.resumeBassClass?.eduExpList?.count {
                let cell = tableView.dequeueReusableCell(withIdentifier: "AddImageCell") as! AddImageCell
                cell.bgView.backgroundColor = UIColor.white
                cell.nameLabel.text = "添加教育经历"
                return cell
            }else{
                var eduExpCell = tableView.dequeueReusableCell(withIdentifier: "cell")
                eduExpCell = UITableViewCell.init(style: .value1, reuseIdentifier: "cell")
                let eduExpModel:ResumeEduExpList = (self.resumeBassClass?.eduExpList![indexPath.row])!
                
                eduExpCell?.textLabel?.text = eduExpModel.school
                eduExpCell?.detailTextLabel?.text = eduExpModel.times
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
