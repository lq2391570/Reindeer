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
    
    @IBOutlet var returnImage: UIImageView!
    
    var resumeBassClass:ResumeBaseClass?
    
    var titleArray = ["简历管理","上传简历附件","积分任务","成就","设置"]
    
    var imageNameArray = ["1简历管理user","2上传简历附件user","3积分任务user","4成就user","5设置user","6求职意向","7我的优势","8社交主页"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        self.title  = "个人中心"
        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib.init(nibName: "UserCenterCell", bundle: nil), forCellReuseIdentifier: "UserCenterCell")
        tableView.tableFooterView = UIView()
      // tableView.separatorStyle = .none
        
        headImageView.layer.cornerRadius = 35
        headImageView.layer.masksToBounds = true
      //  headImageView.sizeToFit()
        let addtap = UITapGestureRecognizer(target: self, action: #selector(headImageClick))
        headImageView.addGestureRecognizer(addtap)
      //  overturnReturnImage()
        getUserMesAndImage()
        getJobIntension()
    }
    //获取个人资料
    func getUserMesAndImage() -> Void {
        userMesInfoInterface(dic: ["token":GetUser(key: TOKEN)], actionHander: { (jsonStr) in
            if jsonStr["code"] == 0 {
                print("jsonStr = \(jsonStr)")
                self.nameLabel.text = jsonStr["name"].stringValue
                self.sexLabel.text = jsonStr["sex"].stringValue
                self.headImageView.sd_setImage(with: URL.init(string: jsonStr["avatar"].stringValue), placeholderImage: UIImage.init(named: "默认头像_男.png"))
                self.successProLabel.text = "接通率：\(jsonStr["callRate"].stringValue)"
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
            //  self.tableView.reloadData()
        }) {
            //  SVProgressHUD.showInfo(withStatus: "请求失败")
        }
    }
    //翻转returnImage
    func overturnReturnImage() -> Void {
        returnImage.layer.transform = CATransform3DMakeRotation(self.radians(degress: 180), 0, 0, 1);
    }
    func radians(degress:CGFloat) -> CGFloat {
        return (degress * 3.14159265) / 180.0;
    }
    
    func headImageClick() -> Void {
        print("dianji touxiang")
        let vc = UIStoryboard(name: "LoginAndUserStoryboard", bundle: nil).instantiateViewController(withIdentifier: "CompleteUserMesVC") as! CompleteUserMesVC
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    @IBAction func returnBtnClick(_ sender: UIButton) {
        _ = self.navigationController?.popViewController(animated: true)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
         self.navigationController?.isNavigationBarHidden = true
    }
    override func viewWillDisappear(_ animated: Bool) {
         self.navigationController?.isNavigationBarHidden = false
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
            vc.resumeBassClass = self.resumeBassClass
            self.navigationController?.pushViewController(vc, animated: true)
        }else if indexPath.section == 2 {
            let vc = UIStoryboard(name: "UserCenter", bundle: nil).instantiateViewController(withIdentifier: "SettingVC") as! SettingVC
            vc.title = "设置"
            self.navigationController?.pushViewController(vc, animated: true)
            
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat
    {
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
            cell.leftImageView.image = UIImage(named: imageNameArray[indexPath.row])
        }else if indexPath.section == 1 {
            cell.nameLabel.text = titleArray[indexPath.row+2]
            cell.leftImageView.image = UIImage(named: imageNameArray[indexPath.row+2])
        }else{
            cell.nameLabel.text = titleArray[4]
            cell.leftImageView.image = UIImage(named: imageNameArray[4])
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
