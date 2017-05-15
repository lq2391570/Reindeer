//
//  CompanyDetailVC.swift
//  Reindeer
//
//  Created by shiliuhua on 17/1/24.
//  Copyright © 2017年 shiliuhua. All rights reserved.
//

import UIKit
import BLKFlexibleHeightBar
import SVProgressHUD
extension BLKDelegateSplitter:UITableViewDelegate{}
class CompanyDetailVC: UIViewController,UITableViewDelegate,UITableViewDataSource {

    
    @IBOutlet var tableView: UITableView!
    
    
    @IBOutlet var flexibleBar: LQFlexibleBar!
    var delegateSpliter:BLKDelegateSplitter!
    var myCustomBar:LQFlexibleBar!
    var myTableView:UITableView!
    //职位列表
    var positionList:NSMutableArray = []
    //公司详情model
    var companyDetailModel:CompanyDetailBaseClass?
    //公司id
    var companyId = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
       
        self.navigationController?.isNavigationBarHidden = true
        
        
        myCustomBar = LQFlexibleBar(frame: CGRect.init(x: 0, y: 0, width: ScreenWidth, height: 100))
       // myCustomBar.backgroundColor = UIColor.blue
        let behaviorDefiner = SquareCashStyleBehaviorDefiner()
        behaviorDefiner.addSnappingPositionProgress(0.0, forProgressRangeStart: 0.0, end: 0.5)
        behaviorDefiner.addSnappingPositionProgress(1.0, forProgressRangeStart: 0.5, end: 1.0)
        behaviorDefiner.isSnappingEnabled = true
        behaviorDefiner.isElasticMaximumHeightAtTop = true
        myCustomBar.behaviorDefiner = behaviorDefiner
        self.delegateSpliter = BLKDelegateSplitter(firstDelegate: behaviorDefiner, secondDelegate: self)
        self.view.addSubview(myCustomBar)
//        self.view.bringSubview(toFront: myCustomBar)
        myTableView = UITableView(frame: CGRect.init(x: 0, y: 0, width: 0, height: 0), style: .grouped)
        myTableView.delegate = self.delegateSpliter
         installTableView()
        myTableView.dataSource = self
        
        self.view.addSubview(myTableView)
        
        self.myTableView.snp.makeConstraints { (make) in
            make.bottom.equalTo(self.view.snp.bottom).offset(0)
            make.left.equalTo(self.view.snp.left).offset(0)
            make.right.equalTo(self.view.snp.right).offset(0)
            make.top.equalTo(self.myCustomBar.snp.bottom).offset(0)
        }

        getCompanyMes()
        
    }
    
    //获得公司详情
    func getCompanyMes() -> Void {
        getCompanyDetail(dic: ["id":companyId], actionHandler: { (bassClass) in
            
            self.companyDetailModel = bassClass
            self.myTableView.reloadData()
            
        }) { 
            SVProgressHUD.showInfo(withStatus: "请求失败")
        }
        
    }
    
    
    
    func installTableView() -> Void {
        
        myTableView.register(UINib.init(nibName: "CompanyTitleCell", bundle: nil), forCellReuseIdentifier: "CompanyTitleCell")
        myTableView.register(UINib.init(nibName: "CompanyIntroduceCell", bundle: nil), forCellReuseIdentifier: "CompanyIntroduceCell")
        myTableView.register(UINib.init(nibName: "CompanyProductCell", bundle: nil), forCellReuseIdentifier: "CompanyProductCell")
        myTableView.register(UINib.init(nibName: "TagListCell", bundle: nil), forCellReuseIdentifier: "TagListCell")
        myTableView.register(UINib.init(nibName: "StationFirstCell", bundle: nil), forCellReuseIdentifier: "StationFirstCell")
        myTableView.estimatedRowHeight = 50
        
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if section == 0 {
            return 2
        }else if section == 1 {
            return 2
        }else if section == 2 {
            return 2
        }else{
            return 1 + positionList.count
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                return 44
            }else{
                return UITableViewAutomaticDimension
            }
        }else if indexPath.section == 1{
            if indexPath.row == 0 {
                return 44
            }else{
                return 110
            }
        }else if indexPath.section == 2 {
            if indexPath.row == 0 {
                return 44
            }else{
                return 70
            }
        }else{
            if indexPath.row == 0 {
                return 44
            }else{
                return 70
            }
        }
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "CompanyTitleCell") as! CompanyTitleCell
                return cell
            }else{
                let cell = tableView.dequeueReusableCell(withIdentifier: "CompanyIntroduceCell") as! CompanyIntroduceCell
                return cell
            }
        }else if indexPath.section == 1{
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "CompanyTitleCell") as! CompanyTitleCell
                return cell
            }else{
                let cell = tableView.dequeueReusableCell(withIdentifier: "CompanyProductCell") as! CompanyProductCell
                return cell
            }
            
        }else if indexPath.section == 2 {
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "CompanyTitleCell") as! CompanyTitleCell
                return cell
            }else{
                let cell = tableView.dequeueReusableCell(withIdentifier: "TagListCell") as! TagListCell
                return cell
            }
        }else {
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "CompanyTitleCell") as! CompanyTitleCell
                return cell
            }else{
                let cell = tableView.dequeueReusableCell(withIdentifier: "StationFirstCell") as! StationFirstCell
                return cell
                
            }
            
            
        }
        
    }
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 4
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
