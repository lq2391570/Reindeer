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
import SwiftyJSON
extension BLKDelegateSplitter:UITableViewDelegate{}
class CompanyDetailVC: BaseViewVC,UITableViewDelegate,UITableViewDataSource {

    
    @IBOutlet var tableView: UITableView!
    
    
    @IBOutlet var flexibleBar: LQFlexibleBar!
    var delegateSpliter:BLKDelegateSplitter!
    var myCustomBar:LQFlexibleBar!
  //  var myTableView:UITableView!
    
    @IBOutlet var myTableView: UITableView!
    
    
    //个人信息json
    var userMesJson:JSON?
    //求职意向id
     var intentId = ""
    //求职意向name
     var intentName = ""
    
    
    //职位列表
    var positionList:NSMutableArray = []
    //公司详情model
    var companyDetailModel:CompanyDetailUserBaseClass?
    //公司id
    var companyId = ""
    
//    init(intentId1:String,intentName1:String,userMesJson1:JSON) {
//       self.intentId = intentId1
//        self.intentName = intentName1
//        self.userMesJson = userMesJson1
//    //    super.init(nibName: "UserFirstStoryboard.storyboard", bundle: Bundle.init(identifier: "CompanyDetailVC"))
//        let bundlePath = UIStoryboard.init(name: <#T##String#>, bundle: <#T##Bundle?#>)
//        super.init(nibName: "CompanyDetailVC", bundle: Bundle.init(path: bundlePath!))
//    }
//    
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//        
//        
//    }
    func inittCompanyMesWithId(intentId1:String,intentName1:String,userMesJson1:JSON) -> Void {
               self.intentId = intentId1
                self.intentName = intentName1
                self.userMesJson = userMesJson1
    }
    
    func awakeFromNib(intentId1:String,intentName1:String,userMesJson1:JSON) {
        super.awakeFromNib()
    }
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    override func viewWillDisappear(_ animated: Bool) {
         self.navigationController?.isNavigationBarHidden = false
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
       
      //  self.navigationController?.isNavigationBarHidden = true
//        myCustomBar = LQFlexibleBar(frame: CGRect.init(x: 0, y: 0, width: ScreenWidth, height: 100))
//       // myCustomBar.backgroundColor = UIColor.blue
//        let behaviorDefiner = SquareCashStyleBehaviorDefiner()
//        behaviorDefiner.addSnappingPositionProgress(0.0, forProgressRangeStart: 0.0, end: 0.5)
//        behaviorDefiner.addSnappingPositionProgress(1.0, forProgressRangeStart: 0.5, end: 1.0)
//        behaviorDefiner.isSnappingEnabled = true
//        behaviorDefiner.isElasticMaximumHeightAtTop = true
//        myCustomBar.behaviorDefiner = behaviorDefiner
//        self.delegateSpliter = BLKDelegateSplitter(firstDelegate: behaviorDefiner, secondDelegate: self)
//        self.view.addSubview(myCustomBar)
//        //返回按钮
//        let returnBtn = UIButton(type: .custom)
//        returnBtn.addTarget(self, action: #selector(returnBtnClick), for: .touchUpInside)
//        self.view.addSubview(returnBtn)
//        returnBtn.snp.makeConstraints { (make) in
//            make.width.equalTo(50)
//            make.height.equalTo(50)
//            make.left.equalTo(self.view.snp.left).offset(0)
//            make.top.equalTo(self.view.snp.top).offset(0)
//        }
//        //返回image
//        let returnImage = UIImageView.init(image: UIImage.init(named: "返回new"))
//        returnBtn.addSubview(returnImage)
//        returnImage.snp.makeConstraints { (make) in
//            make.width.equalTo(20)
//            make.height.equalTo(20)
//            make.top.equalTo(returnBtn.snp.top).offset(21)
//            make.left.equalTo(returnBtn.snp.left).offset(11)
//        }
        
//        self.view.bringSubview(toFront: myCustomBar)
    //  myTableView = UITableView(frame: CGRect.init(x: 0, y: 0, width: 0, height: 0), style: .grouped)
    //  myTableView.delegate = self.delegateSpliter
        myTableView.delegate = self
         installTableView()
        myTableView.dataSource = self
        
        self.view.addSubview(myTableView)
        
//        self.myTableView.snp.makeConstraints { (make) in
//            make.bottom.equalTo(self.view.snp.bottom).offset(0)
//            make.left.equalTo(self.view.snp.left).offset(0)
//            make.right.equalTo(self.view.snp.right).offset(0)
//          //  make.top.equalTo(self.myCustomBar.snp.bottom).offset(0)
//            make.top.equalTo(self.view.snp.top).offset(0)
//        }
        getCompanyMes()
        
    }
    //返回按钮点击
    func returnBtnClick() -> Void {
        //返回
        _ = self.navigationController?.popViewController(animated: true)
        
    }
    //获得公司详情
    func getCompanyMes() -> Void {
        //56
//        getCompanyDetail(dic: ["id":companyId], actionHandler: { (bassClass) in
//            
//            self.companyDetailModel = bassClass
//            self.myTableView.reloadData()
//            
//        }) { 
//            SVProgressHUD.showInfo(withStatus: "请求失败")
//        }
        userGetCompanyDetail(dic: ["id":"56","token":GetUser(key: TOKEN)], actionHander: { (bassClass) in
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
        myTableView.register(UINib.init(nibName: "UserCompanyDetailCell", bundle: nil), forCellReuseIdentifier: "UserCompanyDetailCell")
        myTableView.estimatedRowHeight = 50
       
        
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        
        return 10
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0.00000001
        }
        return 10
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if section == 0 {
            return 1
        }
        
        if section == 1 {
            return 2
        }else if section == 2 {
            if self.companyDetailModel != nil {
                 return 1 + (self.companyDetailModel?.products?.count)!
            }
           return 1
        }else if section == 3 {
            return 2
        }else{
            if self.companyDetailModel != nil {
                return 1 + (self.companyDetailModel?.jobs?.count)!
            }
            return 2
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 200
        }
        
        if indexPath.section == 1 {
            if indexPath.row == 0 {
                return 44
            }else{
                return UITableViewAutomaticDimension
            }
        }else if indexPath.section == 2{
            if indexPath.row == 0 {
                return 44
            }else{
                return 110
            }
        }else if indexPath.section == 3 {
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
            let cell = tableView.dequeueReusableCell(withIdentifier: "UserCompanyDetailCell") as! UserCompanyDetailCell
            guard self.companyDetailModel != nil else {
                return cell
            }
            cell.installCell(headImageStr: self.companyDetailModel?.logo, companyNameStr: self.companyDetailModel?.name, areaStr: self.companyDetailModel?.industry, yearStr: self.companyDetailModel?.scale, eduStr: self.companyDetailModel?.area)
            cell.returnBtnClickClosure = {
                _ = self.navigationController?.popViewController(animated: true)
            }
            return cell
        }
        
        
        if indexPath.section == 1 {
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "CompanyTitleCell") as! CompanyTitleCell
                cell.titleLabel.text = ">公司介绍"
                cell.selectionStyle = .none
                return cell
            }else{
                let cell = tableView.dequeueReusableCell(withIdentifier: "CompanyIntroduceCell") as! CompanyIntroduceCell
                guard self.companyDetailModel != nil else {
                    return cell
                }
                cell.contentLabel.text = self.companyDetailModel?.desc
                
                return cell
            }
        }else if indexPath.section == 2{
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "CompanyTitleCell") as! CompanyTitleCell
                cell.titleLabel.text = ">我们的产品"
                cell.selectionStyle = .none
                return cell
            }else{
                
                let model = self.companyDetailModel?.products?[indexPath.row - 1]
                let cell = tableView.dequeueReusableCell(withIdentifier: "CompanyProductCell") as! CompanyProductCell
                guard self.companyDetailModel != nil else {
                    return cell
                }
                cell.installCell(logoStr: model?.logo, name: model?.name, desc: model?.desc)
                
                return cell
            }
        }else if indexPath.section == 3 {
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "CompanyTitleCell") as! CompanyTitleCell
                cell.titleLabel.text = ">团队亮点"
                cell.selectionStyle = .none
                return cell
            }else{
                let cell = tableView.dequeueReusableCell(withIdentifier: "TagListCell") as! TagListCell
                guard self.companyDetailModel != nil else {
                    return cell
                }
                cell.recommendView.removeAllTags()
                for str in (self.companyDetailModel?.tags)! {
                    cell.recommendView.addTag(str)
                }
                
                return cell
            }
        }else {
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "CompanyTitleCell") as! CompanyTitleCell
                cell.titleLabel.text = ">招聘职位"
                return cell
            }else{
                let cell = tableView.dequeueReusableCell(withIdentifier: "StationFirstCell") as! StationFirstCell
                guard self.companyDetailModel != nil else {
                    return cell
                }
                let model = self.companyDetailModel?.jobs?[indexPath.row - 1]
                cell.installCell(jobName: model?.name, companyName: nil, payRange: model?.salary, area: model?.area, yearRange: model?.exp, edu: model?.edu)
                cell.jobNameLabel.adjustsFontSizeToFitWidth = true
                cell.lineLabel.isHidden = true
                cell.areaLabel.adjustsFontSizeToFitWidth = true
                cell.eduLabel.adjustsFontSizeToFitWidth = true
                cell.yearRangeLabel.adjustsFontSizeToFitWidth = true
                cell.jobNameLabel.textAlignment = .center
                cell.accessoryType = .disclosureIndicator
                return cell
                
            }
            
        }
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 4 {
            if indexPath.row != 0  {
                 let model = self.companyDetailModel?.jobs?[indexPath.row - 1]
                
                let vc = UIStoryboard.init(name: "UserFirstStoryboard", bundle: nil).instantiateViewController(withIdentifier: "StationDetailVC") as! StationDetailVC
               
                 vc.userMesJson = self.userMesJson
                vc.intentName = self.intentName
//                //求职意向id
                vc.intentId = self.intentId
                //职位id
                vc.jobId = NSNumber.init(value: (model?.id)!).stringValue
                self.navigationController?.pushViewController(vc, animated: true)
                
            }
        }
    }
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 5
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
