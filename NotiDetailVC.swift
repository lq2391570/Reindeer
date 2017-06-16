//
//  NotiDetailVC.swift
//  Reindeer
//
//  Created by shiliuhua on 2017/6/13.
//  Copyright © 2017年 shiliuhua. All rights reserved.
//

import UIKit
import SwiftyJSON
import SVProgressHUD
class NotiDetailVC: BaseViewVC,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet var tableView: UITableView!
    var notiType:Int = -1  //1,系统 2视频 , 3普通
    var bassClass:NotiBaseClass?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib.init(nibName: "NotiDetailCell", bundle: nil), forCellReuseIdentifier: "NotiDetailCell")
        tableView.estimatedRowHeight = 100
        getUserNotiList()
    }
    //获得用户通知信息
    func getUserNotiList() -> Void {
        let dic = [
            "token":GetUser(key: TOKEN),
            "type":notiType,
            "no":1,
            "size":100
        ]
        let jsonStr = JSON(dic)
        let newDic = jsonStr.dictionaryValue as NSDictionary
        GetUserNotiMesInterface(dic: newDic, actionHander: { (bassClass) in
            self.bassClass = bassClass
            self.tableView.reloadData()
        }) { 
            SVProgressHUD.showInfo(withStatus: "请求失败")
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if self.bassClass != nil {
            return (self.bassClass?.list?.count)!

        }
        return 0
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let model:NotiList = (self.bassClass?.list![indexPath.row])!
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotiDetailCell") as! NotiDetailCell
        cell.neiRongLabel.text = model.content
        cell.timeLabel.text = model.time
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 1
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return UITableViewAutomaticDimension
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
