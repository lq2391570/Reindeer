//
//  MyColleagueVC.swift
//  Reindeer
//
//  Created by shiliuhua on 2017/8/16.
//  Copyright © 2017年 shiliuhua. All rights reserved.
//

import UIKit

class MyColleagueVC: BaseViewVC,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet var tableView: UITableView!
    var bassClass:MyColleagueMyColleagueBassClass?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = "邀请同事"
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib.init(nibName: "MyColleagueCell", bundle: nil), forCellReuseIdentifier: "MyColleagueCell")
        tableView.register(UINib.init(nibName: "InvitePeopleCell", bundle: nil), forCellReuseIdentifier: "InvitePeopleCell")
        getMyColleague()
    }
    //获得我的同事
    func getMyColleague() -> Void {
        HRcolleagueList(dic: ["token":GetUser(key: "token"),"no":1,"size":"100"], actionHander: { (bassClass) in
            self.bassClass = bassClass
            self.tableView.reloadData()
        }) { 
            
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 1
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "InvitePeopleCell") as! InvitePeopleCell
            
            return cell
        }else{
            let model:MyColleagueList = (self.bassClass?.list![indexPath.section - 1])!
            let cell = tableView.dequeueReusableCell(withIdentifier: "MyColleagueCell") as! MyColleagueCell
            cell.installCell(headImageStr: model.avatar, name: model.name, job: model.job, numOfPeople: model.today, numOfHour: model.duration, numOfInvites: model.total)
            
            return cell
        }
    }
    func numberOfSections(in tableView: UITableView) -> Int
    {
        if self.bassClass == nil {
            return 1
        }else{
            return (self.bassClass?.list?.count)! + 1
        }
        
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 44
        }else{
            return 120
        }
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 0 {
            return 1
        }else{
            return 10
        }
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
