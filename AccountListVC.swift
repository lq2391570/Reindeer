//
//  AccountListVC.swift
//  Reindeer
//
//  Created by shiliuhua on 2017/6/26.
//  Copyright © 2017年 shiliuhua. All rights reserved.
//

import UIKit
import SwiftyJSON
import SVProgressHUD
class AccountListVC: BaseViewVC,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet var tableView: UITableView!
    var accountRecordBassClass:AccountListBaseClass?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib.init(nibName: "AccountRecornListCell", bundle: nil), forCellReuseIdentifier: "AccountRecornListCell")
        getAccountList()
    }
    //获取列表
    func getAccountList() -> Void {
        let dic:NSDictionary = [
            "token":GetUser(key: TOKEN),
            "no":1,
            "size":1000
        ]
        let jsonStr = JSON(dic)
        let newDic = jsonStr.dictionaryValue as NSDictionary
        
        HRAccountRecordInterFace(dic: newDic, actionHander: { (bassClass) in
            self.accountRecordBassClass = bassClass
            self.tableView.reloadData()
            
        }) { 
            
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if self.accountRecordBassClass != nil {
            return (self.accountRecordBassClass?.list?.count)!
        }
        return 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let model:AccountListList = (self.accountRecordBassClass?.list![indexPath.row])!
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "AccountRecornListCell") as! AccountRecornListCell
        if model.type == 0 {
            //0充值 1消费
            cell.numOfMoneyLabel.textColor = UIColor.black
            cell.numOfMoneyLabel.text = "+\(model.money!)"
            cell.typeLabel.text = "充值"
            
        }else if model.type == 1 {
            cell.numOfMoneyLabel.textColor = UIColor.red
            cell.numOfMoneyLabel.text = "-\(model.money!)"
            cell.typeLabel.text = "消费"
        }
        cell.dateLabel.text = model.date
        
        return cell
        
    }
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
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
