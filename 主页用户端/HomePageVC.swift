//
//  HomePageVC.swift
//  Reindeer
//
//  Created by shiliuhua on 16/12/27.
//  Copyright © 2016年 shiliuhua. All rights reserved.
//

import UIKit
import PYSearch
import TagListView
import SVProgressHUD
import AKPickerView
import SwiftyJSON
class HomePageVC: UIViewController,UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate,PYSearchViewControllerDelegate,AKPickerViewDelegate,AKPickerViewDataSource {

    
    @IBOutlet var tableView: UITableView!
    
    //首页类型（HR或应聘者）
    enum HomepageType:Int {
        case userHomePage = 1 //普通用户
        case HRHomePage   //HR
    }
    
    var homeType:HomepageType = .userHomePage
    var headView:DropDownView?
    var arrowView:ArrowsView!
    var heightOfSeciton:CGFloat = 0.0
    var heightOfSectionAll:CGFloat = 0.0
    //headView是否展开
    var isOpen = false
    
    var titleBtn:UIButton!
    
    var searchController:UISearchController!
    var headImageUrlStr = ""
//    //求职意向Array
//    var jobIntensionArray = ["22","33","44"]
    
    var resumeBassClass:ResumeBaseClass?
    var akPickView:AKPickerView?
    
    var filterDic:NSDictionary = [:]
    //首页职位列表model
    var homePageJobBassClass:FirstJobBaseClass?
    
    //首页HR发布的职位model
    var HRPostjobBassClass:HRPostJobBaseClass?
    
    //首页简历列表model
    var HRresumeHomePageBaseClass:HRFirstResumeBaseClass?
    
    //个人信息json
    var userMesJson:JSON?
    //职位名称
    var jobName = ""
    
        var jobId = ""    // 职位id
        var recommend = ""
        var areaId = ""
        var date = ""
        var eduId = ""
        var expId = ""
        var salaryId = ""
        var jobStyleID = "" // 职位类型id
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.confineTableView()
        self.confineNavBar()
        self.getUserMesAndHeadImage()
        
        if homeType == .userHomePage {
            //应聘者
             getJobIntension()
        }else if homeType == .HRHomePage {
            //HR
            getHRPostJobs()
            NotificationCenter.default.addObserver(self, selector: #selector(addPositionNoti), name: NSNotification.Name(rawValue: "ADDPOSITION"), object: nil)
            
        }
       
    }
    func addPositionNoti() -> Void {
        print("收到通知")
        getHRPostJobs()
        
    }
    //获得简历列表（HR模式）
    func getResumeList() -> Void {
        HRResumeList(dic: ["token":GetUser(key: TOKEN),"jobId":jobStyleID], actionHander: { (bassClass) in
            
            self.HRresumeHomePageBaseClass = bassClass
            self.tableView.reloadData()
            
        }) { 
            SVProgressHUD.showInfo(withStatus: "请求失败")
        }
    }
    
    
    //获得求职意向列表
    func getJobIntension() -> Void {
        searchUserResume(dic: ["token":GetUser(key: TOKEN)], actionHander: { (bassClass) in
            self.resumeBassClass = bassClass
            
            self.jobId = NSNumber.init(value: (self.resumeBassClass?.jobIntentList![0].id)!).stringValue
            
            self.getHomePageJobList(dic: ["token":GetUser(key: TOKEN),"jobId":self.jobId])
            
            print("self.resumeBassClass = \(String(describing: self.resumeBassClass))")
            self.navigationItem.titleView = self.createTitleViewOfAKPickView()
            if self.akPickView?.selectedItem == 0 {
                self.akPickView?.reloadData()
            }
            self.tableView.reloadData()
        }) {
            SVProgressHUD.showInfo(withStatus: "请求失败")
        }
    }
    
    //获得HR发布的职位列表（HR端）
    func getHRPostJobs() -> Void {
        HRPostJobsInterface(dic: ["token":GetUser(key: TOKEN)], actionHander: { (bassClass) in
            
            self.HRPostjobBassClass = bassClass
            
            self.jobStyleID = NSNumber.init(value: (self.HRPostjobBassClass?.list?[0].id)!).stringValue
            self.jobId = NSNumber.init(value: (self.HRPostjobBassClass?.list![0].jobId)!).stringValue
            print("self.jobId =\(self.jobId)")
            self.getResumeList()
            self.navigationItem.titleView = self.createTitleViewOfAKPickView()
            if self.akPickView?.selectedItem == 0 {
                self.akPickView?.reloadData()
            }
            self.tableView.reloadData()
        }) {
            SVProgressHUD.showInfo(withStatus: "请求失败")
        }
    }
    //获得首页职位列表（根据搜索条件）
    func getHomePageJobList(dic:NSDictionary) -> Void {
      getFirstList(dic: dic, actionHander: { (bassClass) in
          
        self.homePageJobBassClass = bassClass
        print("self.homePageJobBassClass = \(String(describing: self.homePageJobBassClass))")
        if (bassClass.list?.count)! > 0{
            self.jobName = (bassClass.list?[0].jobName!)!

        }
              self.tableView.reloadData()
        
      }) { 
        SVProgressHUD.showInfo(withStatus: "请求失败")
        }
    }
    //设置navBar
    func confineNavBar() -> Void {
        self.navigationController?.navigationBar.barTintColor=UIColor.black
        //消除毛玻璃效果
        self.navigationController?.navigationBar.isTranslucent = false;
        
        let headImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 36, height: 36))
        headImageView.layer.cornerRadius = 18
        headImageView.layer.masksToBounds = true
     //   headImageView.backgroundColor = UIColor.green
        headImageView.sd_setImage(with: NSURL.init(string: headImageUrlStr) as URL!, placeholderImage: UIImage.init(named: "默认头像_男.png"))
        headImageView.isUserInteractionEnabled = true
        let leftBarBtnItem = UIBarButtonItem(customView: headImageView)
        self.navigationItem.leftBarButtonItem = leftBarBtnItem
        let tapReginzer = UITapGestureRecognizer.init(target: self, action: #selector(headImageViewTap))
        
        headImageView.addGestureRecognizer(tapReginzer)
        
    //    let rightBarBtnItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(rightBarBtnClick))
        let installBtn = UIButton(type: .custom)
        installBtn.setImage(UIImage.init(named: "1电脑端登录"), for: UIControlState.normal)
        installBtn.frame = CGRect(x: 0, y: 0, width: 25, height: 25)
        installBtn.addTarget(self, action: #selector(installBtnClick), for: .touchUpInside)
        
        let rightBarItem = UIBarButtonItem(customView: installBtn)
        self.navigationItem.rightBarButtonItem = rightBarItem
        
        let titleBtn = UIButton(type: .custom)
        titleBtn.setTitle("产品经理", for: .normal)
        titleBtn.setTitleColor(UIColor.init(hexColor: "f4cda2"), for: .normal)
        titleBtn.addTarget(self, action: #selector(titleBtnClick), for: .touchUpInside)
        

    }
    //个人中心
    func headImageViewTap() -> Void {
        print("头像点击")
        if self.homeType == .userHomePage {
            //应聘者端的个人中心
            let vc = UIStoryboard(name: "UserCenter", bundle: nil).instantiateViewController(withIdentifier: "UserCenterFirstVC") as! UserCenterFirstVC
            vc.resumeBassClass = self.resumeBassClass
            self.navigationController?.pushViewController(vc, animated: true)
        }else{
            //hr端的个人中心
            let vc = UIStoryboard(name: "UserCenter", bundle: nil).instantiateViewController(withIdentifier: "HRUserCenterVC") as! HRUserCenterVC
            
            self.navigationController?.pushViewController(vc, animated: true)
            
        }
        
       
        
        
    }
    //获取用户基本信息（头像）
    func getUserMesAndHeadImage() -> Void {
        getUserMes(dic: ["token":GetUser(key: TOKEN)], actionHandler: { (jsonStr) in
            if jsonStr["code"] == 0 {
                print("jsonStr = \(jsonStr)")
                self.userMesJson = jsonStr
            }
            
        
        }) { 
        print("请求失败")
        }
    }
    
    //设置按钮点击
    func installBtnClick() -> Void {
        print("设置")
        
        //暂时放完善信息
        let vc = UIStoryboard(name: "LoginAndUserStoryboard", bundle: nil).instantiateViewController(withIdentifier: "CompleteHRMesVC") as! CompleteHRMesVC
        
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    //titleView
    func createTitleView() -> UIView {
        
        let titleView = UIView()
        titleView.frame = CGRect(x: 0, y: 0, width: 100, height: 30)
        titleBtn = UIButton(type: .custom)
        titleBtn.frame = CGRect(x: 0, y: 0, width: 80, height: 30)
        titleBtn.setTitle("产品经理", for: .normal)
        titleBtn.setTitleColor(UIColor.init(hexColor: "f4cda2"), for: .normal)
        titleBtn.addTarget(self, action: #selector(titleBtnClick), for: .touchUpInside)
        titleBtn.isSelected = false
        titleView.addSubview(titleBtn)
        
        arrowView = ArrowsView(frame: CGRect(x: 80, y: 5, width: 20, height: 20))
        arrowView.backgroundColor = UIColor.clear
        titleView.addSubview(arrowView)
        return titleView
    }
    //titleView(AKPickView)
    func createTitleViewOfAKPickView() -> UIView {
        akPickView = AKPickerView.init(frame: CGRect.init(x: 0, y: 0, width: 200, height: 30))
        akPickView?.delegate = self
        akPickView?.dataSource = self
        akPickView?.interitemSpacing = 15
        akPickView?.highlightedTextColor = UIColor.mainColor
        akPickView?.font = UIFont.systemFont(ofSize: 16)
        akPickView?.highlightedFont = UIFont.systemFont(ofSize: 20)
        
        return akPickView!
        
    }
    //AKPickViewDatasource
    func numberOfItems(in pickerView: AKPickerView!) -> UInt
    {
        if homeType == .userHomePage {
            //应聘者
             return UInt((self.resumeBassClass?.jobIntentList!.count)!)
        }else if homeType == .HRHomePage {
            return UInt((self.HRPostjobBassClass?.list?.count)!)
            
        }else{
            return 0
        }
       
    }
    
    func pickerView(_ pickerView: AKPickerView!, titleForItem item: Int) -> String!
    {
        if homeType == .userHomePage {
            return self.resumeBassClass?.jobIntentList![item].name
        }else if homeType == .HRHomePage {
            return self.HRPostjobBassClass?.list![item].name
        }else{
            return ""
        }
        
    }
    func pickerView(_ pickerView: AKPickerView!, didSelectItem item: Int)
    {
      //  pickerView.reloadData()
        if homeType == .userHomePage {
            print("选中了\(String(describing: self.resumeBassClass?.jobIntentList![item].name))")
            self.jobId = NSNumber.init(value: (self.resumeBassClass?.jobIntentList![item].id)!).stringValue
            
            self.getHomePageJobList(dic: ["token":GetUser(key: TOKEN),"jobId":self.jobId])
        }else if homeType == .HRHomePage {
            print("选中了\(String(describing: self.HRPostjobBassClass?.list?[item].name))")
            self.jobStyleID = NSNumber.init(value: (self.HRPostjobBassClass?.list?[item].id)!).stringValue
            
            self.getResumeList()
        }
        
        
        
    }
    
    //设置tableView
    func confineTableView() -> Void {
        tableView.register(UINib.init(nibName: "PositionCell", bundle: nil), forCellReuseIdentifier: "PositionCell")
        tableView.register(UINib.init(nibName: "Position2Cell", bundle: nil), forCellReuseIdentifier: "Position2Cell")
        tableView.register(UINib.init(nibName: "Position3Cell", bundle: nil), forCellReuseIdentifier: "Position3Cell")
        tableView.register(UINib.init(nibName: "PositionLongCell", bundle: nil), forCellReuseIdentifier: "PositionLongCell")
        
        tableView.register(UINib.init(nibName: "HRHomePageCell", bundle: nil), forCellReuseIdentifier: "HRHomePageCell")
    //    tableView.tableHeaderView?.isUserInteractionEnabled = false
        tableView.separatorStyle = .none
        
    }
    
    func titleBtnClick() -> Void {
        print("titileBtnClick")
        if titleBtn.isSelected == false {
            arrowView.layer.transform = CATransform3DMakeRotation(CGFloat(M_PI), 0, 0, 1)
            titleBtn.isSelected = true
        }else{
            arrowView.layer.transform = CATransform3DMakeRotation(CGFloat(0), 0, 0, 1)
            titleBtn.isSelected = false
        }
    }
    
     func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
     {
        guard section == 1 else {
            return 0
        }
        if isOpen == true {
            return heightOfSeciton+40
        }else{
            return 40
        }
        
    }
       func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        guard section == 1 else {
            return nil
        }
        if headView == nil {
             headView = DropDownView()
             headView!.supViewController = self

        }
        headView!.backgroundColor = UIColor.white
        
        headView?.titleBtnClickClosure = { (sender,height) in
            print("height = \(height)")
            if self.headView?.isOpen == true {
                self.heightOfSeciton = height
                self.isOpen = true
                self.tableView.setContentOffset(CGPoint.init(x: 0, y: 140), animated: true)
                self.tableView.isScrollEnabled = false
                
            }else{
                self.heightOfSeciton = height
                self.isOpen = false
                self.tableView.isScrollEnabled = true
               
            }
           self.tableView.reloadData()
         //    print("headView.frame=\(self.headView!.frame)")
        }
      //  headView?.isUserInteractionEnabled = false
             return headView
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
       // print("headView.frame=\(headView?.frame)")
    }
    func btnClick(btn:UIButton) -> Void {
        print("点击了第\(btn.tag)个按钮")
        
    }
    //rightBarBtnClick
    func rightBarBtnClick() -> Void {
        print("rightBarBtnClick")
    }
    //背景的点击事件
    func tapGRHandler() -> Void {
        print("点击背景")
        
    }
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 2
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if homeType == .userHomePage {
            switch indexPath.section {
            case 0:
                return 140
            case 1:
                return 90
            default:
                return 0
            }

        }else if homeType == .HRHomePage {
            switch indexPath.section {
            case 0:
                return 140
            case 1 :
                return 120
            default:
                return 0
            }
            
        }else{
            return 0
        }
        
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if homeType == .userHomePage {
            switch section {
            case 0:
                return 1
            case 1:
                if self.homePageJobBassClass == nil {
                    return 0
                }else{
                    return (self.homePageJobBassClass?.list?.count)!
                }
            default:
                return 0
            }
 
        }else if homeType == .HRHomePage {
            //HR
            switch section {
            case 0:
                return 1
            case 1:
                if HRresumeHomePageBaseClass == nil {
                    return 0
                }else{
                    return (HRresumeHomePageBaseClass?.list?.count)!
                }
            default:
                return 0
            }
            
        }else{
            return 0
        }
        
    }
    func recommendCellClick(sender:UIButton) -> Void {
        print("sender.tag = \(sender.tag)")
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if indexPath.section == 0 {
            if ScreenWidth == 320{
                let cell:Position3Cell = tableView.dequeueReusableCell(withIdentifier: "Position3Cell") as! Position3Cell
                
                cell.commonInterFaceListClosure = { (btn) in
                    //普通面试列表
                    print("普通面试列表")
                    let vc = InterFaceNotiVC()
                    vc.title = "普通面试"
                    vc.userMesJson = self.userMesJson
                    vc.jobId = self.jobId
                    
                    
                     vc.intentId = self.jobId
                    
                   
                    
                    vc.homeType = InterFaceNotiVC.HomepageType(rawValue: self.homeType.rawValue)!
                    self.navigationController?.pushViewController(vc, animated: true)
                }
                cell.videoInterFaceListClosure = { (btn) in
                    //视频面试列表
                    
                }
                cell.notiListClosure = { (btn) in
                    //通知列表
                }
                
                cell.searchBar.delegate = self
                return cell
            }else {
                let cell:PositionLongCell = tableView.dequeueReusableCell(withIdentifier: "PositionLongCell") as! PositionLongCell
                cell.searchBar.delegate = self
                
                cell.searchBtnClickClosure = { (sender) in
                    print("点击搜索\(sender)")
                    
                    let vc = UIStoryboard.init(name: "UserFirstStoryboard", bundle: nil).instantiateViewController(withIdentifier: "SearchVC") as! SearchVC
                    let nav = UINavigationController.init(rootViewController: vc)
                    self.present(nav, animated: false, completion: nil)
                }
                cell.commonInterFaceListClosure = { (btn) in
                    //普通面试列表
                    print("普通面试列表")
                    let vc = InterFaceNotiVC()
                    vc.title = "普通面试"
                    vc.intentId = self.jobId
                    vc.jobId = self.jobId
                    vc.userMesJson = self.userMesJson
                    vc.homeType = InterFaceNotiVC.HomepageType(rawValue: self.homeType.rawValue)!
                    self.navigationController?.pushViewController(vc, animated: true)
                }
                cell.videoInterFaceListClosure = { (btn) in
                    //视频面试列表
                    
                }
                cell.notiListClosure = { (btn) in
                    //通知列表
                }

                
                return cell
            }
        }else
        {
            
            if homeType == .userHomePage {
                //应聘者
                let cell:PositionCell = tableView.dequeueReusableCell(withIdentifier: "PositionCell") as! PositionCell
                
                
                
                guard self.homePageJobBassClass != nil else {
                    return cell
                }
                let model:FirstJobList = (self.homePageJobBassClass?.list![indexPath.row])!
                
                cell.installPositionCell(jobName: model.jobName!, companyName: model.companyName!, payRange: model.salary!, area: model.city!, yearRange: model.experience!, edu: model.qualification!)
                
                return cell
            }else if homeType == .HRHomePage
            {
                //HR
                let cell = tableView.dequeueReusableCell(withIdentifier: "HRHomePageCell") as! HRHomePageCell
                guard self.HRresumeHomePageBaseClass != nil else {
                    return cell
                }
                let model:HRFirstResumeList = (self.HRresumeHomePageBaseClass?.list![indexPath.row])!
                
                cell.installHRHomePageCell(headImageStr: model.avatar, nameAndJob: model.job, area: model.area, year: model.exp, edu: model.edu, recentjob:model.recentJob,recentCompany:model.recentCompany)
                
                return cell
                
            }else{
                let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
                return cell!
            }
            
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("点击22")
        if tableView.tag == 100 {
            print("点击33")
        }
        guard indexPath.section != 0 else {
            return
        }
        
        if homeType == .userHomePage {
            //应聘者进入职位详情
            let vc = UIStoryboard.init(name: "UserFirstStoryboard", bundle: nil).instantiateViewController(withIdentifier: "StationDetailVC") as! StationDetailVC
            let model = self.homePageJobBassClass?.list?[indexPath.row]
            vc.userMesJson = self.userMesJson
            vc.intentName = self.jobName
            //求职意向id
            vc.intentId = self.jobId
            //职位id
            vc.jobId = NSNumber.init(value: (model?.id)!).stringValue
            self.navigationController?.pushViewController(vc, animated: true)

        }else if homeType == .HRHomePage {
            //HR进入简历详情
            let vc = UIStoryboard.init(name: "UserFirstStoryboard", bundle: nil).instantiateViewController(withIdentifier: "ResumeDetailVC") as! ResumeDetailVC
            let model = HRresumeHomePageBaseClass?.list?[indexPath.row]
            
            vc.intentId = NSNumber.init(value: (model?.intentId)!).stringValue
            
            vc.jobId = self.jobId
            
            vc.resumeId = NSNumber.init(value: (model?.id)!).stringValue
            //这个json是存储个人信息的，下个页面取到公司id使用
            vc.userMesJson = self.userMesJson
            
            self.navigationController?.pushViewController(vc, animated: true)
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
