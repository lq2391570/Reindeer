//
//  PaiQiListVC.swift
//  Reindeer
//
//  Created by shiliuhua on 2017/5/23.
//  Copyright © 2017年 shiliuhua. All rights reserved.
//

import UIKit
import SwiftyJSON
import SVProgressHUD
class PaiQiListVC: BaseViewVC,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet var tableView: UITableView!
    
    var bassClass:HRPaiQiListBaseClass?
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.title = "排期"
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib.init(nibName: "PaiQiListCell", bundle: nil), forCellReuseIdentifier: "PaiQiListCell")
        let rightBtnItem = UIBarButtonItem.init(barButtonSystemItem: .add, target: self, action: #selector(rightBtnItemClick))
        self.navigationItem.rightBarButtonItem = rightBtnItem
        
        getPaiQiList()
    }
    func rightBtnItemClick() -> Void {
        print("添加排期")
        let vc = UIStoryboard.init(name: "UserFirstStoryboard", bundle: nil).instantiateViewController(withIdentifier: "PaiQiAddVC") as! PaiQiAddVC
        vc.returnClosure = {
           self.getPaiQiList()
        }
        self.navigationController?.pushViewController(vc, animated: true)
        
        
    }
    //获得排期列表
    func getPaiQiList() -> Void {
        let dic:NSDictionary = [
            "token":GetUser(key: TOKEN),
            "no":1,
            "size":100
        ]
        let jsonStr = JSON(dic)
        let newDic:NSDictionary = jsonStr.dictionaryValue as NSDictionary
        
        HRGetPaiQiListInterface(dic: newDic, actionHander: { (bassClass) in
            self.bassClass = bassClass
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
        let model:HRPaiQiListList = (self.bassClass?.list![indexPath.section])!
        let cell = tableView.dequeueReusableCell(withIdentifier: "PaiQiListCell") as! PaiQiListCell
        cell.installCell(name: model.job, stateNum: model.state, time: model.datetime, timeLong: model.duration, peopleNum: model.nums)
        
        return cell
    }
    func numberOfSections(in tableView: UITableView) -> Int
    {
        if self.bassClass == nil {
            return 0
        }
        return (self.bassClass?.list?.count)!
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let model:HRPaiQiListList = (self.bassClass?.list![indexPath.section])!
        let vc = UIStoryboard(name: "UserFirstStoryboard", bundle: nil).instantiateViewController(withIdentifier: "PaiQiDetailVC") as! PaiQiDetailVC
        vc.title = model.job
        vc.paiqiListBassClass = model
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
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
            deletePaiqi(model: (self.bassClass?.list?[indexPath.section])!, succeedClosure: { 
                self.bassClass?.list?.remove(at: indexPath.section)
                tableView.deleteSections(index, with: UITableViewRowAnimation.fade)
            })
        }
        
    }
    
    func deletePaiqi(model:HRPaiQiListList,succeedClosure:(() ->())?) -> Void {
        let dic:NSDictionary = [
            "token":GetUser(key: TOKEN),
            "id":model.id as Any,
            "remark":""
        ]
        let jsonStr = JSON(dic)
        let newDic:NSDictionary = jsonStr.dictionaryValue as NSDictionary
         print("newDic = \(newDic)")
        HRdeletePaiQi(dic: newDic, actionHander: { (jsonStr) in
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
