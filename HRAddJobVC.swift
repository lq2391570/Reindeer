//
//  HRAddJobVC.swift
//  Reindeer
//
//  Created by shiliuhua on 2017/5/2.
//  Copyright © 2017年 shiliuhua. All rights reserved.
//

import UIKit
import SVProgressHUD
class HRAddJobVC: BaseViewVC,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet var tableView: UITableView!
    
    var titleArray1 = ["职位类型","职位名称","技能要求"]
    var titleArray2 = ["薪资范围","经验要求","学历要求"]
    var titleArray3 = ["工作城市","工作地点"]
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
        }else if indexPath.section == 3 {
            cell?.textLabel?.text = "职位描述"
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
            }else if indexPath.row == 1 {
                //工作地点
            }
        }else if indexPath.section == 3 {
            //职位描述
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
