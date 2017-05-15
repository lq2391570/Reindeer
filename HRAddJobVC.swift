//
//  HRAddJobVC.swift
//  Reindeer
//
//  Created by shiliuhua on 2017/5/2.
//  Copyright © 2017年 shiliuhua. All rights reserved.
//

import UIKit
import SVProgressHUD
import JCAlertView
import SwiftyJSON
class HRAddJobVC: BaseViewVC,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet var tableView: UITableView!
    
    var titleArray1 = ["职位类型","职位名称","技能要求"]
    var titleArray2 = ["薪资范围","经验要求","学历要求"]
    var titleArray3 = ["工作城市","工作地点"]
    
    //公司id
    var companyId = ""
    
    //职位类型model
    var positionModel:PositionList?
    //职位名称
    var positionName = ""
    //技能要求
    var skillArray:[String] = []
    
    //薪资范围数组
    var compensationArray:[PositionList] = []
    //薪资范围model
    var compensationModel:PositionList?
    //工作经验数组
    var jobExpModelArray:[PositionList] = []
    //工作经验model
    var jobExpModel:PositionList?
    //学历范围数组
    var eduExpModelArray:[PositionList] = []
    //学历范围model
    var eduExpModel:PositionList?
    //地区名称
    var areaName = ""
    //地区id
    var areaId = ""
    //职位描述
    var descOfJobStr = ""
    //经度
    var lat:Double = 0
    //纬度
    var lng:Double = 0
    //工作地址
    var address = ""
    //招聘人数
    var recruitingNum = 1
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "新增职位"
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: "cell")
        tableView.rowHeight = 60
        tableView.tableHeaderView = tableViewHeaderView()
        tableView.tableFooterView = createBottomBtn(supView: tableView, title: "完成") { (btn) in
            btn.addTarget(self, action: #selector(completeBtnClick), for: .touchUpInside)
        }
        
        // Do any additional setup after loading the view.
        let rightBarBtnItem = UIBarButtonItem.init(title: "跳过", style: .plain, target: self, action: #selector(rightBarBtnItemClick))
        self.navigationItem.rightBarButtonItem = rightBarBtnItem
        getCompensation {}
        getJobExp()
        getEdu()
    }
    //得到薪资范围
    func getCompensation(closure:@escaping ()->Void) -> Void {
        getCompensationRange(dic: ["":""], actionHander: { (bassClass) in
            print("bassClass = \(bassClass)")
            self.compensationArray = bassClass.list!
              closure()
        }) {
            SVProgressHUD.showInfo(withStatus: "请求失败")
        }
    }
    //获得经验要求
    func getJobExp() -> Void {
          self.jobExpModelArray = (getWorkExpTypePath()?.list)!
    }
    //获得学历要求
    func getEdu() -> Void {
        self.eduExpModelArray = (getEduExpTypePath()?.list)!
    }
    
    
    func completeBtnClick() -> Void {
        print("完成")
        if companyId == "" {
            SVProgressHUD.showInfo(withStatus: "公司不存在")
            return
        }else if positionModel == nil {
            SVProgressHUD.showInfo(withStatus: "请选择职位")
            return
        }else if compensationModel == nil {
            SVProgressHUD.showInfo(withStatus: "请选择薪资范围")
            return
        }else if jobExpModel == nil {
            SVProgressHUD.showInfo(withStatus: "请选择工作经验")
            return
        }else if eduExpModel == nil {
            SVProgressHUD.showInfo(withStatus: "请选择学历范围")
            return
        }else if areaId == "" {
            SVProgressHUD.showInfo(withStatus: "请选择工作地区")
            return
        }else if descOfJobStr == "" {
            SVProgressHUD.showInfo(withStatus: "请描述职位")
            return
        }
    //    print("companyId = \(companyId),positionModel.id=\(positionModel?.id! as Any),positionModel?.name=\(positionModel?.name! as Any),tags =\(skillArray),salary =\(compensationModel?.id as Any),experience = \(jobExpModel?.id as Any),qualification = \(eduExpModel?.id as Any),area = \(areaId),district = \(areaName),address = \(address),note = \(descOfJobStr) ")
        
        
        addJonPosition()
        
        
        
    }
    
    //添加职位
    func addJonPosition() -> Void {
        let dic:NSDictionary = [
            "companyId":companyId,            //公司id
            "kind":positionModel?.id! as Any , //职位类型id
            "name":positionModel?.name! as Any ,//职位名称
            "tags":skillArray,                 //技能要求
            "salary":compensationModel?.id as Any ,    //薪资范围id
            "experience":jobExpModel?.id as Any ,      //工作经验id
            "qualification":eduExpModel?.id as Any ,   //学历范围id
            "area":areaId,                     //工作地区id
            "district":areaName,               //地区名称
            "lat":lat,                         //经度
            "lng":lng,                         //纬度
            "address":address,                 //地址名称
            "note":descOfJobStr,               //职位描述
            "nums":recruitingNum,               //招聘人数
            "token":GetUser(key: TOKEN)
        ]
        
        print("dic = \(dic)")
        
        let jsondic = JSON(dic)
        print ("jsondic = \(jsondic)")
        
        let newDic:NSDictionary = jsondic.dictionary! as NSDictionary
        
        print("newDic = \(newDic)")
        
        HRAddPositionInterface(dic: newDic, actionHander: { (jsonStr) in
            if jsonStr["code"] == 0 {
                SVProgressHUD.showSuccess(withStatus: jsonStr["msg"].stringValue)
                print("添加成功")
                
                let vc = UIStoryboard(name: "UserFirstStoryboard", bundle: nil).instantiateViewController(withIdentifier: "HomePageVC") as! HomePageVC
                let nav = UINavigationController.init(rootViewController: vc)
                vc.homeType = .HRHomePage
                
                self.view.window?.rootViewController = nav
                
            }else{
                SVProgressHUD.showInfo(withStatus: jsonStr["msg"].stringValue)
            }
        }) { 
            SVProgressHUD.showInfo(withStatus: "请求失败")
        }
    }
    
    
    func rightBarBtnItemClick() -> Void {
        //跳过
    }
    func tableViewHeaderView() -> UIView {
        let view = UIView(frame: CGRect.init(x: 0, y: 0, width: self.view.frame.size.width, height: 120))
        view.backgroundColor = UIColor.lightGray
        let btn = UIButton(type: .custom)
        btn.frame = CGRect.init(x: self.view.frame.size.width/2 - 20, y: 30, width: 40, height: 40)
        btn.setBackgroundImage(UIImage.init(named: "1电脑端登录"), for: .normal)
        btn.addTarget(self, action: #selector(scanBtnClick), for: .touchUpInside)
        view.addSubview(btn)
        let label = UILabel.init(frame: CGRect.init(x: self.view.frame.size.width/2 - 100, y: 90, width: 200, height: 20))
        label.textAlignment = .center
        label.text = "扫一扫，去电脑端更方便操作！"
        label.textColor = UIColor.mainColor
        label.font = UIFont.systemFont(ofSize: 14)
        view.addSubview(label)
        return view
    }
    func scanBtnClick() -> Void {
        print("扫一扫")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if section == 0 {
            return 3
        }else if section == 1{
            return 3
        }else if section == 2 {
            return 2
        }else if section == 3 {
            return 1
        }
        return 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        cell = UITableViewCell.init(style: .value1, reuseIdentifier: "cell")
        cell?.textLabel?.font = UIFont.systemFont(ofSize: 14)
        cell?.detailTextLabel?.font = UIFont.systemFont(ofSize: 14)
        cell?.accessoryType = .disclosureIndicator
        if indexPath.section == 0 {
            cell?.textLabel?.text = titleArray1[indexPath.row]
            if indexPath.row == 0 {
                cell?.detailTextLabel?.text = self.positionModel?.name
            }else if indexPath.row == 1 {
                cell?.detailTextLabel?.text = self.positionName
            }else if indexPath.row == 2 {
                cell?.detailTextLabel?.text = "选择了\(self.skillArray.count)个技能"
            }
            
        }else if indexPath.section == 1 {
            cell?.textLabel?.text = titleArray2[indexPath.row]
            if indexPath.row == 0 {
                cell?.detailTextLabel?.text = self.compensationModel?.name
            }else if indexPath.row == 1 {
                cell?.detailTextLabel?.text = self.jobExpModel?.name
            }else if indexPath.row == 2 {
                cell?.detailTextLabel?.text = self.eduExpModel?.name
                
            }
            
        }else if indexPath.section == 2 {
            cell?.textLabel?.text = titleArray3[indexPath.row]
            if indexPath.row == 0 {
                cell?.detailTextLabel?.text = self.areaName
            }
            
            
        }else if indexPath.section == 3 {
            cell?.textLabel?.text = "职位描述"
           cell?.detailTextLabel?.text = self.descOfJobStr
            
        }
        
        return cell!
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                //职位类型
                
                let vc = UIStoryboard(name: "UserCenter", bundle: nil).instantiateViewController(withIdentifier: "ChoseIntensionVC") as! ChoseIntensionVC
                vc.TranslucentModel.returnClosure = { (positionModel:PositionList) in
                    print("positionModel = \(positionModel)")
                    self.positionModel = positionModel
                    self.tableView.reloadData()
                }
                self.navigationController?.pushViewController(vc, animated: true)
                
            }else if indexPath.row == 1 {
                //职位名称
                let vc = TextFieldVC()
                vc.completeClosure = { (str) in
                    print("str = \(str)")
                    self.positionName = str
                    self.tableView.reloadData()
                }
                vc.placeholdStr = "请输入职位名称"
                self.navigationController?.pushViewController(vc, animated: true)
                
                
            }else if indexPath.row == 2 {
                //技能要求
                let vc = UIStoryboard(name: "UserCenter", bundle: nil).instantiateViewController(withIdentifier: "UserTagVC") as! UserTagVC
                vc.completeclosure = { (tagViewArray) in
                    for tagView in tagViewArray {
                        self.skillArray.append(tagView.currentTitle!)
                    }
                    print("self.skillArray = \(self.skillArray)")
                    tableView.reloadData()
                }
                
                self.navigationController?.pushViewController(vc, animated: true)
                
            }
        }else if indexPath.section == 1 {
            if indexPath.row == 0 {
                getCompensation {
                    //薪资范围
                    var stringArray:[String] = []
                    for model in self.compensationArray {
                        stringArray.append(model.name!)
                    }
                    
                    createActionSheet(title: "薪资范围", message: "请选择薪资范围", stringArray: stringArray, viewController: self, closure: { (index) in
                        print("选择了\(self.compensationArray[index].name)")
                        self.compensationModel = self.compensationArray[index]
                        self.tableView.reloadData()
                        
                    })
                }
                
                
                
            }else if indexPath.row == 1 {
                //经验要求
                var jobExpNameArray:[String] = []
                for model in (self.jobExpModelArray) {
                    jobExpNameArray.append(model.name!)
                }

                createActionSheet(title: "经验要求", message: "请选择经验要求", stringArray: jobExpNameArray, viewController: self, closure: { (index) in
                    
                    self.jobExpModel = self.jobExpModelArray[index]
                    print("选择了\(self.jobExpModel?.name)")
                    self.tableView.reloadData()
                })
                
                
            }else if indexPath.row == 2 {
                //学历要求
                var eduNameArray:[String] = []
                for model in self.eduExpModelArray {
                    eduNameArray.append(model.name!)
                }
                createActionSheet(title: "学历要求", message: "请选择学历要求", stringArray: eduNameArray, viewController: self, closure: { (index) in
                    self.eduExpModel = self.eduExpModelArray[index]
                    print("选择了\(self.eduExpModel?.name)")
                    self.tableView.reloadData()
                })
                
            }
        }else if indexPath.section == 2 {
            if indexPath.row == 0 {
                //工作城市
                if let customView = LQPickView.newInstance() {
                    
                    let customAlert = JCAlertView.init(customView: customView, dismissWhenTouchedBackground: false)
                    
                    customAlert?.center = CGPoint.init(x: ScreenWidth/2, y: ScreenHeight - customView.frame.size.height/2-20)
                    customView.cancelbtnClickClosure = { (btn) in
                        customAlert?.dismiss(completion: nil)
                        
                    }
                    customView.sureBtnClickclosure = { (btn) in
                        
                        print("cityName = \(customView.cityNameStr) , cityId = \(customView.cityIDStr)")
                        self.areaName = customView.cityNameStr
                        self.areaId = customView.cityIDStr
                        //  self.cityTextField.text = "\(customView.provinceNameStr)\(customView.cityNameStr)"
                        customAlert?.dismiss(completion: nil)
                        self.tableView.reloadData()
                        //    self.areaId = customView.cityIDStr
                    }
                    
                    customAlert?.show()
                    
                }

                
                
                
            }else if indexPath.row == 1 {
                //工作地点
            }
        }else if indexPath.section == 3 {
            //职位描述
            let vc = TextViewVC()
            vc.textViewTypeEnum = .typeWorkContent
            vc.saveBtnClickClosure = { (str) in
                self.descOfJobStr = str
                self.tableView.reloadData()
            }
            
            self.navigationController?.pushViewController(vc, animated: true)
            

            
        }
    }
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 4
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
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
