//
//  RecommendHRListVC.swift
//  Reindeer
//
//  Created by shiliuhua on 2017/8/23.
//  Copyright © 2017年 shiliuhua. All rights reserved.
//

import UIKit

class RecommendHRListVC: BaseViewVC,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet var tableView: UITableView!
    
    var bassClass:PhoneNumSearchPhoneNumSearchBassClass?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "推荐记录"
        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib.init(nibName: "PhoneSearchCell", bundle: nil), forCellReuseIdentifier: "PhoneSearchCell")
        tableView.tableFooterView = UIView()
        getRecommendRecordList()
    }
    //获得推荐给HR的记录列表
    func getRecommendRecordList() -> Void {
        
        RecommendHRRecordListInterface(dic: ["token":GetUser(key: TOKEN),"no":1,"size":100], actionHander: { (bassClass) in
            self.bassClass = bassClass
            self.tableView.reloadData()
            
        }) { 
            
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if self.bassClass != nil {
            return (self.bassClass?.list?.count)!
        }
        return 0
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "我推荐过的"
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let model:PhoneNumSearchList = (self.bassClass?.list![indexPath.row])!
        let cell = tableView.dequeueReusableCell(withIdentifier: "PhoneSearchCell") as! PhoneSearchCell
        cell.installCell(headImageStr: model.avatar, name: model.name, phoneNumStr: model.phone)
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
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
