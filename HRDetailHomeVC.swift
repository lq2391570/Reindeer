//
//  HRDetailHomeVC.swift
//  Reindeer
//
//  Created by shiliuhua on 2017/8/30.
//  Copyright © 2017年 shiliuhua. All rights reserved.
//

import UIKit
import SVProgressHUD
class HRDetailHomeVC: BaseViewVC,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet var tableView: UITableView!
    
    var score = 0
    var hrId = 0
    var hrName = ""
    //面试id
    var interviewId = 0
    
    var bassClass:HRInviteMesHRInviteMesBassClass?
    
    var returnClosure:(() -> ())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "\(hrName)的主页"
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib.init(nibName: "HRDetailCell", bundle: nil), forCellReuseIdentifier: "HRDetailCell")
        tableView.tableFooterView = createAgreeBtnAndFefuseBtn()
        // Do any additional setup after loading the view.
        getHRMes()
    }
    
    //获取HR信息
    func getHRMes(){
        HRMesInUserInviteListInterface(dic: ["token":GetUser(key: TOKEN),"id":hrId], actionHander: { (bassClass) in
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
        if self.bassClass != nil {
            let model:HRInviteMesHRInviteMesBassClass = self.bassClass!
            let cell = tableView.dequeueReusableCell(withIdentifier: "HRDetailCell") as! HRDetailCell
           
            
            cell.installCell(numOfToday: model.today ?? 0, numOfAll: model.total ?? 0, numOfMinute: model.duration ?? 0, headImageStr: model.avatar, name: model.name, job: model.job, score: model.score)
            
            return cell

        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "HRDetailCell") as! HRDetailCell
            return cell

            
        }
        
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 5
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 330
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    //底部状态（收到申请中，底部为同意或拒绝）
    func createAgreeBtnAndFefuseBtn() -> UIView {
        let view = UIView(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.size.width, height: 40))
        let refuseBtn = UIButton(type: .custom)
        refuseBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        refuseBtn.setTitle("拒绝", for: .normal)
        refuseBtn.backgroundColor = UIColor.init(red: 223/255.0, green: 212/255.0, blue: 203/255.0, alpha: 1)
        refuseBtn.setTitleColor(UIColor.black, for: .normal)
        refuseBtn.addTarget(self, action: #selector(refuseBtnClick), for: .touchUpInside)
        
        view.addSubview(refuseBtn)
        let agreeBtn = UIButton(type: .custom)
        agreeBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        agreeBtn.setTitle("同意", for: .normal)
        agreeBtn.addTarget(self, action: #selector(agreeBtnClick), for: .touchUpInside)
      //  agreeBtn.backgroundColor = UIColor.init(red: 195/255.0, green: 174/255.0, blue: 158/255.0, alpha: 1)
        agreeBtn.backgroundColor = UIColor.black
        agreeBtn.setTitleColor(UIColor.mainColor, for: .normal)
        view.addSubview(agreeBtn)
        refuseBtn.snp.makeConstraints { (make) in
            make.left.equalTo(view.snp.left).offset(20)
            make.top.equalTo(view.snp.top).offset(0)
            make.bottom.equalTo(view.snp.bottom).offset(0)
            make.width.equalTo(130)
            
        }
        agreeBtn.snp.makeConstraints { (make) in
           // make.left.equalTo(refuseBtn.snp.right).offset(40)
            make.top.equalTo(view.snp.top).offset(0)
            make.bottom.equalTo(view.snp.bottom).offset(0)
            make.right.equalTo(view.snp.right).offset(-20)
            make.width.equalTo(130)
        }
        
        return view
        
    }
    func refuseBtnClick() -> Void {
        print("拒绝")
        SVProgressHUD.show()
        UserHandleInvitesInterface(dic: ["token":GetUser(key: TOKEN),"id":self.interviewId,"type":1], actionHander: { (jsonStr) in
            if jsonStr["code"] == 0 {
                SVProgressHUD.showSuccess(withStatus: jsonStr["msg"].stringValue)
             //   self.getUserInviteInterViewList()
                if self.returnClosure != nil {
                    self.returnClosure!()
                }
                
                _ = self.navigationController?.popViewController(animated: true)
            }else{
                SVProgressHUD.showInfo(withStatus: jsonStr["msg"].stringValue)
            }
        }, fail: {
            
        })
    }
    func agreeBtnClick() -> Void {
        print("同意")
        SVProgressHUD.show()
        UserHandleInvitesInterface(dic: ["token":GetUser(key: TOKEN),"id":self.interviewId,"type":0], actionHander: { (jsonStr) in
            if jsonStr["code"] == 0 {
                SVProgressHUD.showSuccess(withStatus: jsonStr["msg"].stringValue)
              //  self.getUserInviteInterViewList()
                if self.returnClosure != nil {
                    self.returnClosure!()
                }
                _ = self.navigationController?.popViewController(animated: true)
            }else{
                SVProgressHUD.showInfo(withStatus: jsonStr["msg"].stringValue)
            }
        }, fail: {
            
        })
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
