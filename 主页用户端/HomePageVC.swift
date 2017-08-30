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
import JNDropDownMenu
import MJRefresh

class HomePageVC: UIViewController,UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate,PYSearchViewControllerDelegate,AKPickerViewDelegate,AKPickerViewDataSource,NIMNetCallManagerDelegate,JNDropDownMenuDelegate1, JNDropDownMenuDataSource1,PYSearchViewControllerDataSource {

    
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
    
    //面试时间BassClass
    var interViewTimeBassClass:PositionBaseClass?
    //学历
    var eduBassClass:PositionBaseClass?
    //工作经验
    var expBassClass:PositionBaseClass?
    //薪资要求
    var moneyBassClass:PositionBaseClass?
    //地区
    var areaBassClassArray:[AreaBaseClass] = []
    //求职意向地区id
    var jobSeekerAreaId:Int?
    //求职意向地区Name
    var jobSeekerAreaName:String?
    //下拉菜单
    var menu:JNMenu!
    
    
    //选择的地区model
    var selectAreaModel:AreaBaseClass?
    //选择的推荐还是最新
    var selectRecommonOrNew:Int = 0
    //选择的时间model
    var selectTimeModel:PositionList?
    
    //选择学历model
    var eduSelectModel:PositionList?
    //选择工作经验model
    var expSelectModel:PositionList?
    //选择薪资要求model
    var paySelectModel:PositionList?
   
    //头像ImageView
    var headImageView:UIImageView?
    
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
    
    var numOfNoReadVideo = "0"
    var numOfNoReadCommon = "0"
    
    //顶部刷新
    var header = MJRefreshGifHeader()
    //底部刷新
    let footer = MJRefreshAutoFooter()
    //gif图片数组
    var gifImageArray:[UIImage] = []
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.confineTableView()
        self.confineNavBar()
        self.getUserMesAndHeadImage()
        
        //获得学历
        self.eduBassClass = getEduExpTypePath()
        //获得工作经验
        self.expBassClass = getWorkExpTypePath()
        //获得薪资要求
        self.moneyBassClass = getPayTypePath()
        if homeType == .userHomePage {
            //应聘者
             getJobIntension(succeedClosure: { 
                self.getHomePageZhiWeiList()
             })
            //获得面试时间
            self.interViewTimeBassClass = getInterViewTypePath()
            userGetNoReadNum()
            //下拉刷新
            
            self.tableView.mj_header = setUpMJHeader(refreshingClosure: { 
                self.getHomePageZhiWeiList()
            })
            //上拉更多
            self.tableView.mj_footer = setUpMJFooter(refreshingClosure: { 
                self.tableView.mj_footer.endRefreshingWithNoMoreData()
            })
            
            
            
        }else if homeType == .HRHomePage {
            //HR
            getHRPostJobs(succeedClosure: { 
                 self.getHomePageJIanLiList()
            })
            HRGetNoReadNum()
            self.tableView.mj_header = setUpMJHeader(refreshingClosure: { 
                self.getHomePageJIanLiList()
            })
            //上拉更多
            self.tableView.mj_footer = setUpMJFooter(refreshingClosure: {
                self.tableView.mj_footer.endRefreshingWithNoMoreData()
            })
            
            
            NotificationCenter.default.addObserver(self, selector: #selector(addPositionNoti), name: NSNotification.Name(rawValue: "ADDPOSITION"), object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(addJobIntensionNoti), name: NSNotification.Name(rawValue: "ADDJobIntensionNoti"), object: nil)
            
        }
            NIMAVChatSDK.shared().netCallManager.add(self)
       
    }
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(addPositionNoti), name: NSNotification.Name(rawValue: "ADDPOSITION"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(addJobIntensionNoti), name: NSNotification.Name(rawValue: "ADDJobIntensionNoti"), object: nil)
         self.getUserMesAndHeadImage()
    }
    
    //添加求职意向noti
    func addJobIntensionNoti() -> Void {
        
        getJobIntension(succeedClosure: nil)
    }
    
    
    //将图片放入数组
    func CreateImageArray() -> Void {
        for index in 0...29 {
            let str = "roll\(index).png"
            print("str = \(str)")
            gifImageArray.append(UIImage.init(named: str)!)
        }
        
    }
    
    func onReceive(_ callID: UInt64, from caller: String, type: NIMNetCallMediaType, message extendMessage: String?) {
        print("收到呼叫")
        let vc = NTESVideoChatViewController(caller: caller, callId: callID)

        self.navigationController?.pushViewController(vc!, animated: true)
        
    }
    func addPositionNoti() -> Void {
        print("收到通知")
        getHRPostJobs(succeedClosure: nil)
        
    }
    //根据求职意向的地区id查找下属子地区（一层）
    func getAreaWithPid(pid:Int) -> Void {
        self.areaBassClassArray.removeAll()
        for bassClass:AreaBaseClass in getAreaPath()! {
            if bassClass.parentId == pid {
                self.areaBassClassArray.append(bassClass)
            }
        }
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
    func getJobIntension(succeedClosure:(()->())?) -> Void {
        searchUserResume(dic: ["token":GetUser(key: TOKEN)], actionHander: { (bassClass) in
            self.resumeBassClass = bassClass
            
            self.jobId = NSNumber.init(value: (self.resumeBassClass?.jobIntentList![0].id)!).stringValue
            
            self.getAreaWithPid(pid: (self.resumeBassClass?.jobIntentList?[0].areaId)!)
            
            self.getHomePageJobList(dic: ["token":GetUser(key: TOKEN),"jobId":self.jobId])
            
            print("self.resumeBassClass = \(String(describing: self.resumeBassClass))")
            self.navigationItem.titleView = self.createTitleViewOfAKPickView()
            if self.akPickView?.selectedItem == 0 {
                self.akPickView?.reloadData()
            }
            self.tableView.reloadData()
            if succeedClosure != nil {
                succeedClosure!()
            }
            
            
        }) {
            SVProgressHUD.showInfo(withStatus: "请求失败")
        }
    }
    
    //获得HR发布的职位列表（HR端）
    func getHRPostJobs(succeedClosure:(() -> ())?) -> Void {
        HRPostJobsInterface(dic: ["token":GetUser(key: TOKEN)], actionHander: { (bassClass) in
            
            
            
            self.HRPostjobBassClass = bassClass
            
            guard self.HRPostjobBassClass?.list?.count != 0 else {
                
                createAlert(title: "提示", message: "还没发布职位，先去发布一个职位吧", viewControll: self, closure: { 
                    let vc = UIStoryboard(name: "UserCenter", bundle: nil).instantiateViewController(withIdentifier: "HRAddJobVC") as! HRAddJobVC
                    vc.companyId = GetUser(key: COMPANYID) as! String
                    self.navigationController?.pushViewController(vc, animated: true)
                })
                
                return
            }
            
            //得到职位列表后存起来，排期选择职位时使用
            let data:Data = NSKeyedArchiver.archivedData(withRootObject: self.HRPostjobBassClass!)
            SetUser(value: data, key: HRPOSITION)
            
            self.jobStyleID = NSNumber.init(value: (self.HRPostjobBassClass?.list?[0].id)!).stringValue
            self.jobId = NSNumber.init(value: (self.HRPostjobBassClass?.list![0].jobId)!).stringValue
            print("self.jobId =\(self.jobId)")
            self.getResumeList()
            self.navigationItem.titleView = self.createTitleViewOfAKPickView()
            if self.akPickView?.selectedItem == 0 {
                self.akPickView?.reloadData()
            }
            self.tableView.reloadData()
            if succeedClosure != nil {
                succeedClosure!()
            }
        }) {
            SVProgressHUD.showInfo(withStatus: "请求失败")
        }
    }
    //获得首页职位列表（根据搜索条件）
    func getHomePageJobList(dic:NSDictionary) -> Void {
      getFirstList(dic: dic, actionHander: { (bassClass) in
          
        self.homePageJobBassClass = bassClass
        print("self.homePageJobBassClass = \(String(describing: self.homePageJobBassClass))")
        if (bassClass.list?.count)! > 0 {
            self.jobName = (bassClass.list?[0].jobName!)!
        }
//        var IndexPathArray:[IndexPath] = []
//        for index:Int in 0..<(bassClass.list?.count)!{
//            let indexPath = NSIndexPath(row: index, section: 1)
//            IndexPathArray.append(indexPath as IndexPath)
//        }
        let index = IndexSet(integer: 1)
        self.tableView.mj_header.endRefreshing()
        self.tableView.reloadSections(index, with: .automatic)
         //     self.tableView.reloadData()
        
        }) { 
        SVProgressHUD.showInfo(withStatus: "请求失败")
        }
    }
    //获得首页简历列表HR（根据搜索条件）
    func getHomePageResumeList(dic:NSDictionary) -> Void {
        HRResumeList(dic: dic, actionHander: { (bassClass) in
            
            self.HRresumeHomePageBaseClass = bassClass
            self.tableView.reloadData()
            self.tableView.mj_header.endRefreshing()
        }) {
            SVProgressHUD.showInfo(withStatus: "请求失败")
        }
    }
    
    //设置navBar
    func confineNavBar() -> Void {
        self.navigationController?.navigationBar.barTintColor=UIColor.black
        //消除毛玻璃效果
        self.navigationController?.navigationBar.isTranslucent = false;
        
        headImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 36, height: 36))
        headImageView?.layer.cornerRadius = 18
        headImageView?.layer.masksToBounds = true
     //   headImageView.backgroundColor = UIColor.green
        headImageView?.sd_setImage(with: NSURL.init(string: headImageUrlStr) as URL!, placeholderImage: UIImage.init(named: "默认头像_男.png"))
        
        
        headImageView?.isUserInteractionEnabled = true
        let leftBarBtnItem = UIBarButtonItem(customView: headImageView!)
        self.navigationItem.leftBarButtonItem = leftBarBtnItem
        let tapReginzer = UITapGestureRecognizer.init(target: self, action: #selector(headImageViewTap))
        
        headImageView?.addGestureRecognizer(tapReginzer)
        
        if homeType == .userHomePage {
            let installBtn = UIButton(type: .custom)
            installBtn.setImage(UIImage.init(named: "1电脑端登录"), for: UIControlState.normal)
            installBtn.frame = CGRect(x: 0, y: 0, width: 25, height: 25)
            installBtn.addTarget(self, action: #selector(installBtnClick), for: .touchUpInside)
            let rightBarItem = UIBarButtonItem(customView: installBtn)
            self.navigationItem.rightBarButtonItem = rightBarItem

        }else{
            let paiqiBtn = UIButton(type: .custom)
            paiqiBtn.setImage(UIImage.init(named: "1排期"), for: .normal)
            paiqiBtn.frame = CGRect.init(x: 0, y: 0, width: 25, height: 25)
            paiqiBtn.addTarget(self, action: #selector(paiqiBtnClick(_:)), for: .touchUpInside)
            let rightBarItem = UIBarButtonItem(customView: paiqiBtn)
            self.navigationItem.rightBarButtonItem = rightBarItem
            
        }
        
        let titleBtn = UIButton(type: .custom)
        titleBtn.setTitle("产品经理", for: .normal)
        titleBtn.setTitleColor(UIColor.init(hexColor: "f4cda2"), for: .normal)
        titleBtn.addTarget(self, action: #selector(titleBtnClick), for: .touchUpInside)
        
    }
    func paiqiBtnClick(_ btn:UIButton) -> Void {
        print("排期")
        let vc = UIStoryboard.init(name: "UserFirstStoryboard", bundle: nil).instantiateViewController(withIdentifier: "PaiQiListVC") as! PaiQiListVC
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //个人中心
    func headImageViewTap() -> Void {
        print("头像点击")
        if self.homeType == .userHomePage {
            //应聘者端的个人中心
//            let vc = UIStoryboard(name: "UserCenter", bundle: nil).instantiateViewController(withIdentifier: "UserCenterFirstVC") as! UserCenterFirstVC
//            vc.resumeBassClass = self.resumeBassClass
//            self.navigationController?.pushViewController(vc, animated: true)
            let vc = UIStoryboard(name: "UserCenter", bundle: nil).instantiateViewController(withIdentifier: "UserCenterFirstNewVC") as! UserCenterFirstNewVC
            
            self.navigationController?.pushViewController(vc, animated: true)
            
            
        }else{
            //hr端的个人中心
//            let vc = UIStoryboard(name: "UserCenter", bundle: nil).instantiateViewController(withIdentifier: "HRUserCenterVC") as! HRUserCenterVC
//            
//            self.navigationController?.pushViewController(vc, animated: true)
            let vc = UIStoryboard(name: "UserCenter", bundle: nil).instantiateViewController(withIdentifier: "HRUserCenterNewVC") as! HRUserCenterNewVC
            
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    //获取用户基本信息（头像）
    func getUserMesAndHeadImage() -> Void {
        getUserMes(dic: ["token":GetUser(key: TOKEN)], actionHandler: { (jsonStr) in
            if jsonStr["code"] == 0 {
                print("jsonStr = \(jsonStr)")
                self.userMesJson = jsonStr
              //  let userDic = jsonStr.dictionaryValue

                
//                let userData = NSKeyedArchiver.archivedData(withRootObject: jsonStr)
//                let dataArray = NSArray()
//                dataArray.adding(userData)
//                SetUser(value: dataArray, key: USERMES)
                
                self.headImageUrlStr = (self.userMesJson?["avatar"].stringValue)!
                self.headImageView?.sd_setImage(with: URL.init(string: self.headImageUrlStr), placeholderImage: UIImage.init(named: "默认头像_男.png"))
            }
        }) { 
        print("请求失败")
        }
    }
    
    //设置按钮点击
    func installBtnClick() -> Void {
        print("扫码登录")
        
        //扫码登陆
        let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "QRCodeVC")
        vc.title = "扫码登录"
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    //获取面试未读数量
    func userGetNoReadNum() -> Void {
        userNoManagerNumInterface(dic: ["token":GetUser(key: TOKEN)], actionHander: { (jsonStr) in
            if jsonStr["code"] == 0 {
                self.numOfNoReadVideo = jsonStr["video"].stringValue
                self.numOfNoReadCommon = jsonStr["common"].stringValue
                self.tableView.reloadData()
            }
        }) { 
            
        }
    }
    //HR获取面试未读数量
    func HRGetNoReadNum() -> Void {
        HRNoManagerNumInterface(dic: ["token":GetUser(key: TOKEN),"jobId":self.jobId], actionHander: { (jsonStr) in
            if jsonStr["code"] == 0 {
                self.numOfNoReadVideo = jsonStr["video"].stringValue
                self.numOfNoReadCommon = jsonStr["common"].stringValue
                self.tableView.reloadData()
                
            }
        }) { 
            
        }
        
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
            self.getAreaWithPid(pid: (self.resumeBassClass?.jobIntentList?[item].areaId)!)
            self.getHomePageJobList(dic: ["token":GetUser(key: TOKEN),"jobId":self.jobId])
            userGetNoReadNum()
            if self.menu.show == true {
                self.menu.dismiss()
            }
          
        }else if homeType == .HRHomePage {
            print("选中了\(String(describing: self.HRPostjobBassClass?.list?[item].name))")
            self.jobStyleID = NSNumber.init(value: (self.HRPostjobBassClass?.list?[item].id)!).stringValue
            self.jobId = NSNumber.init(value: (self.HRPostjobBassClass?.list?[item].jobId)!).stringValue
            self.getResumeList()
            HRGetNoReadNum()
            if self.menu.show == true {
                self.menu.dismiss()
            }
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
        if menu == nil {
            menu = JNMenu(origin: CGPoint(x: 0, y:100), height: 40, width: self.view.frame.size.width)
        }
        menu.datasource = self
        menu.delegate = self
        if self.homeType == .HRHomePage {
            menu.isHRDropType = true
        }
        menu.sureBtnClickClosure = { (eduModel,expModel,payModel) in
            print("eduModel.name = \(eduModel?.name) expModel.name= \(expModel?.name) payModel.name = \(payModel?.name)")
            self.eduSelectModel = eduModel
            self.expSelectModel = expModel
            self.paySelectModel = payModel
            self.getHomePageZhiWeiList()
        }
        menu.cancelBtnClickClosure = {
            self.expSelectModel = nil
            self.eduSelectModel = nil
            self.paySelectModel = nil
            self.getHomePageZhiWeiList()
        }
        //赋予选择条件的初始值，记录选择的条件
        if self.eduSelectModel != nil {
            menu.eduSelectModel = self.eduSelectModel
        }
        if self.expSelectModel != nil {
            menu.expSelectModel = self.expSelectModel
        }
        if self.paySelectModel != nil {
            menu.paySelectModel = self.paySelectModel
        }
        
        
        menu.menuOpenOrCloseClosure = { (isopen) in
            if isopen == true {
                self.isOpen = true
                if self.tableView.contentOffset.y < 140 {
                    self.tableView.setContentOffset(CGPoint.init(x: 0, y: 140), animated: true)
                }
                if self.tableView.contentSize.height > ScreenHeight {
                    self.menu.backGroundView.frame = CGRect(origin: CGPoint(x: 0, y :100),size: CGSize(width:self.view.frame.size.width, height: self.tableView.contentSize.height))
                }else{
                    self.menu.backGroundView.frame = CGRect(origin: CGPoint(x: 0, y :100),size: CGSize(width:self.view.frame.size.width, height: ScreenHeight))
                }
                self.tableView.isScrollEnabled = false
                
            }else{
                
                self.isOpen = false
                
                self.tableView.isScrollEnabled = true
            }
        }
    
        return menu
        
    }
    //JNDropDownMenuDataSource
    func numberOfRows(in column: NSInteger, for menu: JNMenu) -> Int
    {
        if self.homeType == .userHomePage {
            if column == 0 {
                return 2
            }else if column == 1 {
                return self.areaBassClassArray.count
            }else if column == 2 {
                return (interViewTimeBassClass?.list?.count)!
            }else if column == 3 {
                return 4
            }
        }else{
            if column == 0 {
                return 2
            }else if column == 1 {
                return (self.moneyBassClass?.list?.count)!
            }else if column == 2 {
                return (self.expBassClass?.list?.count)!
            }else{
                return (self.eduBassClass?.list?.count)!
            }
            
        }
        return 1
    }
    func titleForRow(at indexPath: JNIndexPath1, for menu: JNMenu) -> String
    {
        if self.homeType == .userHomePage {
            if indexPath.column == 0 {
                return ["最新","推荐"][indexPath.row]
            }else if indexPath.column == 1 {
                return self.areaBassClassArray[indexPath.row].name!
            }else if indexPath.column == 2 {
                return (interViewTimeBassClass?.list![indexPath.row].name)!
            }else if indexPath.column == 3 {
                return "222"
            }
        }else{
            if indexPath.column == 0 {
                return ["最新","推荐"][indexPath.row]
            }else if indexPath.column == 1 {
                return (self.moneyBassClass?.list![indexPath.row].name)!
            }else if indexPath.column == 2 {
                return (self.expBassClass?.list![indexPath.row].name)!
            }else if indexPath.column == 3 {
                return (self.eduBassClass?.list![indexPath.row].name)!
            }
        }
        return "123"
    }
    func numberOfColumns(in menu: JNMenu) -> NSInteger
    {
        return 4
    }
    func titleFor(column: Int, menu: JNMenu) -> String
    {
        if self.homeType == .userHomePage {
            if column == 0 {
                if self.selectRecommonOrNew == 1 {
                    return "推荐"
                }else{
                    return "最新"
                }
                
            }else if column == 1 {
                if self.selectAreaModel != nil {
                    return (self.selectAreaModel?.name)!
                }
                return "地区"
            }else if column == 2 {
                if self.selectTimeModel != nil {
                    return (self.selectTimeModel?.name)!
                }
                return "面试时间"
            }else if column == 3 {
                return "筛选"
            }
        }else{
            if column == 0 {
                if self.selectRecommonOrNew == 1 {
                    return "推荐"
                }else{
                    return "最新"
                }
                
            }else if column == 1 {
                if self.paySelectModel != nil {
                    return (self.paySelectModel?.name)!
                }
                return "薪资"
            }else if column == 2 {
                if self.expSelectModel != nil {
                    return (self.expSelectModel?.name)!
                }
                return "经验"
            }else if column == 3 {
                if self.eduSelectModel != nil {
                    return (self.eduSelectModel?.name)!
                }
                return "学历"
            }
        }
        return "222"
    }
    func didSelectRow(at indexPath: JNIndexPath1, for menu: JNMenu)
    {
         self.tableView.isScrollEnabled = true
        if self.homeType == .userHomePage {
            if indexPath.column == 0 {
                self.selectRecommonOrNew = indexPath.row
                getHomePageZhiWeiList()
            }else if indexPath.column == 1 {
                self.selectAreaModel = self.areaBassClassArray[indexPath.row]
                getHomePageZhiWeiList()
            }else if indexPath.column == 2 {
                self.selectTimeModel = interViewTimeBassClass?.list?[indexPath.row]
                getHomePageZhiWeiList()
            }
        }else{
            if indexPath.column == 0 {
                self.selectRecommonOrNew = indexPath.row
                getHomePageJIanLiList()
            }else if indexPath.column == 1 {
                self.paySelectModel = self.moneyBassClass?.list?[indexPath.row]
                 getHomePageJIanLiList()
            }else if indexPath.column == 2 {
                self.expSelectModel = self.expBassClass?.list?[indexPath.row]
                 getHomePageJIanLiList()
            }else if indexPath.column == 3 {
                self.eduSelectModel = self.eduBassClass?.list?[indexPath.row]
                 getHomePageJIanLiList()
            }
            
        }
        
    }
    func getHomePageZhiWeiList() -> Void {
        var areaId1 = 0
        var dateId1 = 0
        var eduId1 = 0
        var expId1 = 0
        var salaryId1 = 0
        if self.selectAreaModel != nil {
            areaId1 = (self.selectAreaModel?.id)!
        }
        if self.selectTimeModel != nil {
            dateId1 = (self.selectTimeModel?.id)!
        }
        if self.eduSelectModel != nil {
            eduId1 = (self.eduSelectModel?.id)!
        }
        if self.expSelectModel != nil {
            expId1 = (self.expSelectModel?.id)!
        }
        if self.paySelectModel?.id != nil {
            salaryId1 = (self.paySelectModel?.id)!
        }
        let dic:NSDictionary = [
            "token":GetUser(key: TOKEN),
            "jobId":self.jobId,
            "recommend":self.selectRecommonOrNew,
            "areaId":areaId1 ,
            "date":dateId1  ,
            "eduId":eduId1  ,
            "expId":expId1  ,
            "salaryId":salaryId1  ,
            ]
        let jsonStr = JSON(dic)
        let newDic:NSDictionary = jsonStr.dictionaryValue as NSDictionary
        print("newDic = \(newDic)")
        self.getHomePageJobList(dic: newDic)
    }
    //（hr）获得首页简历列表
    func getHomePageJIanLiList() -> Void {
        var salaryId1 = 0
        var expId1 = 0
        var eduId1 = 0
        if self.paySelectModel?.id != nil {
            salaryId1 = (self.paySelectModel?.id)!
        }
        if self.expSelectModel?.id != nil {
            expId1 = (self.expSelectModel?.id)!
        }
        if self.eduSelectModel?.id != nil {
            eduId1 = (self.eduSelectModel?.id)!
        }
        let dic:NSDictionary = [
            "token":GetUser(key: TOKEN),
            "jobId":jobStyleID,
            "recommend":self.selectRecommonOrNew,
            "salaryId":salaryId1,
            "expId":expId1,
            "eduId":eduId1
        ]
        let jsonStr = JSON(dic)
        let newDic:NSDictionary = jsonStr.dictionaryValue as NSDictionary
    
         print("newDic = \(newDic)")
        
        self.getHomePageResumeList(dic: newDic)
        
    }

    //求职者端关键词搜索
    func getHomePageZhiWeiListWithKeyword(keyWord:String) -> Void {
        let dic:NSDictionary = [
            "token":GetUser(key: TOKEN),
            "keyword":keyWord
        ]
        let jsonStr = JSON(dic)
        let newDic:NSDictionary = jsonStr.dictionaryValue as NSDictionary
        print("newDic = \(newDic)")
        self.getHomePageJobList(dic: newDic)
        
    }
    //HR端关键词搜索
    func getHomePageResumeListWithKeyword(keyWord:String) -> Void {
        let dic:NSDictionary = [
            "token":GetUser(key: TOKEN),
            "keyword":keyWord
        ]
        let jsonStr = JSON(dic)
        let newDic:NSDictionary = jsonStr.dictionaryValue as NSDictionary
        print("newDic = \(newDic)")
        self.getHomePageResumeList(dic: newDic)
        
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
//            if ScreenWidth == 320{
//                let cell:Position3Cell = tableView.dequeueReusableCell(withIdentifier: "Position3Cell") as! Position3Cell
//                cell.commonInterFaceListClosure = { (btn) in
//                    //普通面试列表
//                    print("普通面试列表")
//                    let vc = InterFaceNotiVC()
//                    vc.title = "普通面试"
//                    vc.userMesJson = self.userMesJson
//                    vc.jobId = self.jobId
//                    vc.intentId = self.jobId
//                    vc.homeType = InterFaceNotiVC.HomepageType(rawValue: self.homeType.rawValue)!
//                    self.navigationController?.pushViewController(vc, animated: true)
//                }
//                cell.videoInterFaceListClosure = { (btn) in
//                    //视频面试列表
//                    let vc = VideoInterViewListVC()
//                    vc.userMesJson = self.userMesJson
//                    vc.jobId = self.jobId
//                    vc.intentId = self.jobId
//                    vc.homeType = VideoInterViewListVC.HomepageType(rawValue: self.homeType.rawValue)!
//                    vc.title = "视频面试"
//                    self.navigationController?.pushViewController(vc, animated: true)
//                }
//                cell.notiListClosure = { (btn) in
//                    //通知列表
//                    let vc = UIStoryboard(name: "UserFirstStoryboard", bundle: nil).instantiateViewController(withIdentifier: "NotiAllVC") as! NotiAllVC
//                    
//                    self.navigationController?.pushViewController(vc, animated: true)
//                }
//                
//                cell.searchBar.delegate = self
//                return cell
//            }else {
                let cell:PositionLongCell = tableView.dequeueReusableCell(withIdentifier: "PositionLongCell") as! PositionLongCell
                cell.searchBar.delegate = self
            
            cell.numOfVideoInterView.text = self.numOfNoReadVideo
            cell.numOfCommonInterView.text = self.numOfNoReadCommon
            
                cell.searchBtnClickClosure = { (sender) in
                    print("点击搜索\(sender)")
                    let hotSeaches = ["百度","阿里巴巴","腾讯","中软国际","美团","京东","同纳信息","软通动力"]
                    let searchViewController = PYSearchViewController(hotSearches: hotSeaches, searchBarPlaceholder: "请输入关键字", didSearch: { (searchViewController, searchBar, searchText) in
                        print("searchViewController = \(searchViewController),searchBar = \(searchBar),searchText= \(searchText)")
                        searchViewController?.dismiss(animated: true, completion: nil)
                        if self.homeType == .userHomePage
                        {
                             self.getHomePageZhiWeiListWithKeyword(keyWord: searchText!)
                        }else{
                            self.getHomePageResumeListWithKeyword(keyWord: searchText!)
                        }
                       
                    })

                    searchViewController?.hotSearchTitle = "热门搜索"
                    searchViewController?.searchHistoryTitle = "搜索历史"
                    let nav = UINavigationController.init(rootViewController: searchViewController!)
                    self.present(nav, animated: false, completion: nil)
                }
                cell.commonInterFaceListClosure = { (btn) in
                    //普通面试列表
//                    print("普通面试列表")
//                    let vc = InterFaceNotiVC()
//                    vc.title = "普通面试"
//                    vc.intentId = self.jobId
//                    vc.jobId = self.jobId
//                    vc.userMesJson = self.userMesJson
//                    vc.homeType = InterFaceNotiVC.HomepageType(rawValue: self.homeType.rawValue)!
//                    self.navigationController?.pushViewController(vc, animated: true)
                   //邀请面试列表
                    let vc = HRInviteListVC()
                    vc.userMesJson = self.userMesJson
//                    vc.jobId = self.jobId
//                    vc.intentId = self.jobId
                    vc.homeType = HRInviteListVC.HomepageType(rawValue: self.homeType.rawValue)!
                    self.navigationController?.pushViewController(vc, animated: true)
                    
                    
                }
                cell.videoInterFaceListClosure = { (btn) in
                    //视频面试列表
                    let vc = VideoInterViewListVC()
                    vc.title = "视频面试"
                    vc.userMesJson = self.userMesJson
                    vc.jobId = self.jobId
                    vc.intentId = self.jobId
                    vc.homeType = VideoInterViewListVC.HomepageType(rawValue: self.homeType.rawValue)!
                    self.navigationController?.pushViewController(vc, animated: true)
                }
                cell.notiListClosure = { (btn) in
                    //通知列表
                    //通知列表
                    let vc = UIStoryboard(name: "UserFirstStoryboard", bundle: nil).instantiateViewController(withIdentifier: "NotiAllVC") as! NotiAllVC
                    
                    self.navigationController?.pushViewController(vc, animated: true)
                }

                return cell
      //      }
        }else
        {
            
            if homeType == .userHomePage {
                //应聘者
                let cell:PositionCell = tableView.dequeueReusableCell(withIdentifier: "PositionCell") as! PositionCell
            
                guard self.homePageJobBassClass != nil else {
                    return cell
                }
                let model:FirstJobList = (self.homePageJobBassClass?.list![indexPath.row])!
                
                cell.installPositionCell(jobName: model.jobName ?? "", companyName: model.companyName ?? "", payRange: model.salary ?? "", area: model.city ?? "", yearRange: model.experience ?? "", edu: model.qualification ?? "")
                
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
    //PYsearchDataSource
    func searchSuggestionView(_ searchSuggestionView: UITableView!, cellForRowAt indexPath: IndexPath!) -> UITableViewCell!
    {
      //  if indexPath.section == 0 {
            var cell = tableView.dequeueReusableCell(withIdentifier: "FilterCell") as? FilterCell
            if cell == nil {
                cell = Bundle.main.loadNibNamed("FilterCell", owner: self, options: nil)?.last as? FilterCell
                cell?.recommendView.addTag("123")
            }
            return cell
     //   }
    }
    func searchSuggestionView(_ searchSuggestionView: UITableView!, numberOfRowsInSection section: Int) -> Int
    {
        return 1
    }
    func numberOfSections(inSearchSuggestionView searchSuggestionView: UITableView!) -> Int
    {
        return 2
    }
    func searchSuggestionView(_ searchSuggestionView: UITableView!, heightForRowAt indexPath: IndexPath!) -> CGFloat
    {
        return 130
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
