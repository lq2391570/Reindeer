//
//  PaiQiDetailVC.swift
//  Reindeer
//
//  Created by shiliuhua on 2017/5/23.
//  Copyright © 2017年 shiliuhua. All rights reserved.
//

import UIKit
import SwiftyJSON
import SVProgressHUD
class PaiQiDetailVC: BaseViewVC,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet var tableView: UITableView!
    //排期model
    var paiqiListBassClass:HRPaiQiListList?
    //排期详情model
    var paiqiDetailBassClass:PaiQiDetailBaseClass?
    
    var headView:PaiQiDetailHeadView?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib.init(nibName: "HRHomePageCell", bundle: nil), forCellReuseIdentifier: "HRHomePageCell")
        tableView.tableHeaderView = createHeadView()
        
        getPaiqiDetail()
    }
    //headView
    func createHeadView() -> UIView? {
        if let view = PaiQiDetailHeadView.newInstance() {
            
            view.timeLabel.text = paiqiDetailBassClass?.date
            view.timeLongLabel.text = paiqiDetailBassClass?.duration
            view.numOfPeopleLabel.text = paiqiDetailBassClass?.nums
            return view
        }
        return nil
        
    }
    //获取排期详情
    func getPaiqiDetail() -> Void {
        let dic:NSDictionary = [
            "token":GetUser(key: TOKEN),
            "id":paiqiListBassClass?.id as Any,
           // "itemId":paiqiListBassClass?.itemId as Any
            "itemId":269
        ]
        let jsonStr = JSON(dic)
        let newDic = jsonStr.dictionaryValue as NSDictionary
        print("newDic = \(newDic)")
        PaiQiDetailInterface(dic: newDic, actionHander: { (bassClass) in
            self.paiqiDetailBassClass = bassClass
            self.tableView.reloadData()
            self.tableView.tableHeaderView = self.createHeadView()
            
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
        let model:PaiQiDetailList = (self.paiqiDetailBassClass?.list![indexPath.section])!
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "HRHomePageCell") as! HRHomePageCell
        cell.installHRHomePageCell(headImageStr: model.avatar, nameAndJob: "\(model.name!)|\(model.job!)", area: model.area, year: model.exp, edu: model.edu, recentjob: model.recentJob, recentCompany: model.recentCompany)
        return cell
    }
    func numberOfSections(in tableView: UITableView) -> Int
    {
        if self.paiqiDetailBassClass != nil {
            return (self.paiqiDetailBassClass?.list?.count)!
        }
        return 0
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 1
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
