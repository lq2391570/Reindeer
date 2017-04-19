//
//  JobIntensionVC.swift
//  Reindeer
//
//  Created by shiliuhua on 17/2/22.
//  Copyright © 2017年 shiliuhua. All rights reserved.
//

import UIKit
import SVProgressHUD
class JobIntensionVC: BaseViewVC,UITableViewDelegate,UITableViewDataSource {

    
    @IBOutlet var tableView: UITableView!
    //职位Array
    var jobArray:NSMutableArray = []
    var resumeBassClass:ResumeBaseClass?
    //选择的求职意向
    var jobIntensionModel:ResumeList?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "求职意向"
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib.init(nibName: "PositionWantCell", bundle: nil), forCellReuseIdentifier: "PositionWantCell")
        tableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: "cell")
       // tableView.separatorStyle = .none
        //右上角+
        let addBtn = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addBtnClick))
        self.navigationItem.rightBarButtonItem = addBtn
        // Do any additional setup after loading the view.
        getJobIntension()
    }
    //获得求职意向列表
    func getJobIntension() -> Void {
        searchUserResume(dic: ["token":GetUser(key: TOKEN)], actionHander: { (bassClass) in
           self.resumeBassClass = bassClass
            print("self.resumeBassClass = \(self.resumeBassClass)")
            
            self.tableView.reloadData()
        }) { 
            SVProgressHUD.showInfo(withStatus: "请求失败")
        }
    }
   //更新求职状态
    func updateJobState() -> Void {
        updateJobIntensionInterface(dic: ["resumeId":self.resumeBassClass?.id! as Any,"jobStateId":self.jobIntensionModel?.id! as Any], actionHander: { (jsonStr) in
            if jsonStr["code"] == 0 {
                SVProgressHUD.showSuccess(withStatus: "更新成功");
                self.tableView.reloadData()
            }
            
        }) { 
            SVProgressHUD.showInfo(withStatus: "请求失败")
        }
        
    }
    
    
    //添加求职意向
    func addBtnClick() -> Void {
        let vc = UIStoryboard(name: "UserCenter", bundle: nil).instantiateViewController(withIdentifier: "AddJobIntensionVC") as! AddJobIntensionVC
        vc.enterState = .resumeEnterState
        vc.returnClosure = {
            self.getJobIntension()
        }
        
        
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if section == 0 {
            return 1
        }else{
            return resumeBassClass?.jobIntentList?.count ?? 0
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if indexPath.section == 0 {
            var cell = tableView.dequeueReusableCell(withIdentifier: "cell")
            cell = UITableViewCell(style: .value1, reuseIdentifier: "cell")
            cell?.textLabel?.text = "求职状态"
            cell?.detailTextLabel?.text = self.jobIntensionModel?.name ?? self.resumeBassClass?.jobState?.name
            cell?.accessoryType = .disclosureIndicator
            cell?.selectionStyle = .none
            return cell!
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "PositionWantCell") as! PositionWantCell
            cell.jobNameLabel.text = self.resumeBassClass?.jobIntentList?[indexPath.row].name
            cell.industryLabel.text = self.resumeBassClass?.jobIntentList?[indexPath.row].industry
            cell.payRangelabel.text = self.resumeBassClass?.jobIntentList?[indexPath.row].salary
            
            return cell
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            
            var stringArray:[String] = []
            for model:ResumeList in (self.resumeBassClass?.jobState?.list)! {
            //    print("model.name = \(model.name)")
                stringArray.append(model.name ?? "")
            }
            createActionSheet(title: "求职状态", message: "", stringArray: stringArray, viewController: self, closure: { (index) in
                print("点击了第\(index)个")
                self.jobIntensionModel = self.resumeBassClass?.jobState?.list?[index]
                print("self.jobIntensionModel = \(self.jobIntensionModel)")
                self.updateJobState()
                
            })
            
        }else{
            
            let vc = UIStoryboard(name: "UserCenter", bundle: nil).instantiateViewController(withIdentifier: "AddJobIntensionVC") as! AddJobIntensionVC
            vc.enterState = .updateEnterState
            vc.returnClosure = {
                self.getJobIntension()
            }
            vc.jobIntensionId = NSNumber.init(value: (self.resumeBassClass?.jobIntentList?[indexPath.row].id)!).stringValue
            self.navigationController?.pushViewController(vc, animated: true)
            
            
            
        }
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if indexPath.section == 0 {
            return 60
        }else{
            return 80
        }
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        if section == 0 {
            return 1
        }else{
            return 5
        }
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat
    {
        return 5
    }
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 2
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
