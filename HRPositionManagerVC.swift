//
//  HRPositionManagerVC.swift
//  Reindeer
//
//  Created by shiliuhua on 2017/5/16.
//  Copyright © 2017年 shiliuhua. All rights reserved.
//

import UIKit
import SwiftyJSON
import SVProgressHUD
class HRPositionManagerVC: BaseViewVC,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet var tableView: UITableView!
    
    var positionManagerBassClass:HRPositionManagerBaseClass?
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.title = "职位管理"
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib.init(nibName: "HRPositionManagerCell", bundle: nil), forCellReuseIdentifier: "HRPositionManagerCell")
        let rightBarBtnItem = UIBarButtonItem.init(barButtonSystemItem: .add, target: self, action: #selector(addBtnClick))
        self.navigationItem.rightBarButtonItem = rightBarBtnItem
        getHRJobPositionManagerList()
        
    }
    func addBtnClick() -> Void {
        print("添加职位")
        let vc = UIStoryboard(name: "UserCenter", bundle: nil).instantiateViewController(withIdentifier: "HRAddJobVC") as! HRAddJobVC
        vc.companyId = GetUser(key: COMPANYID) as! String
        vc.positionAddEnum = .positionManagerToAddPosition
        vc.returnClosure = {
            self.getHRJobPositionManagerList()
            //成功同时发出通知，改变首页的职位横划列表
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ADDPOSITION"), object: nil)
        }
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    //获取职位列表
    func getHRJobPositionManagerList() -> Void {
        let dic:NSDictionary = [
            "token":GetUser(key: TOKEN),
            "no":1,
            "size":100
        ]
        let jsonStr = JSON(dic)
        let newDic:NSDictionary = jsonStr.dictionary! as NSDictionary
        HRjobmanagerInterface(dic: newDic, actionHander: { (bassClass) in
            self.positionManagerBassClass = bassClass
            self.tableView.reloadData()
        }) { 
            SVProgressHUD.showInfo(withStatus: "请求失败")
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        let model = self.positionManagerBassClass?.list?[indexPath.section]
        let cell = tableView.dequeueReusableCell(withIdentifier: "HRPositionManagerCell") as! HRPositionManagerCell
    
        cell.installCell(jobName: model?.jobName, money: model?.salary, area: model?.area, exp: model?.experience, edu: model?.qualification, deadLine: model?.date)
        
        return cell
        
    }
    func numberOfSections(in tableView: UITableView) -> Int
    {
        if self.positionManagerBassClass != nil {
             return (self.positionManagerBassClass?.list?.count)!
        }
       return 0
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return .delete
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
        
            let index = IndexSet.init(integer: indexPath.section)
            
           deleteJob(model: (self.positionManagerBassClass?.list?[indexPath.section])!, succeedClosure: { 
            self.positionManagerBassClass?.list?.remove(at: indexPath.section)
            tableView.deleteSections(index, with: UITableViewRowAnimation.fade)
           })
        
        }
    }
    func deleteJob(model:HRPositionManagerList,succeedClosure:(() -> ())?) -> Void {
        let dic:NSDictionary = [
            "token":GetUser(key: TOKEN),
            "id":model.id as Any,
            "reason":""
        ]
        let jsonStr = JSON(dic)
        let newDic:NSDictionary = jsonStr.dictionaryValue as NSDictionary
        print("newDic = \(newDic)")
        HRDeleteJobInterface(dic: newDic, actionHander: { (jsonStr) in
            if jsonStr["code"] == 0 {
                print("删除成功")
                succeedClosure!()
            }
        }) {
            
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
