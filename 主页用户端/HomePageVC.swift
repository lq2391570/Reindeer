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
    //个人信息json
    var userMesJson:JSON?
    var jobName = ""
    
        var jobId = ""
        var recommend = ""
        var areaId = ""
        var date = ""
        var eduId = ""
        var expId = ""
        var salaryId = ""
        
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.confineTableView()
        self.confineNavBar()
        self.getUserMesAndHeadImage()
        getJobIntension()
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
        
        let vc = UIStoryboard(name: "UserCenter", bundle: nil).instantiateViewController(withIdentifier: "UserCenterFirstVC") as! UserCenterFirstVC
        vc.resumeBassClass = self.resumeBassClass
        self.navigationController?.pushViewController(vc, animated: true)
        
        
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
        
        return UInt((self.resumeBassClass?.jobIntentList!.count)!)
    }
    func pickerView(_ pickerView: AKPickerView!, titleForItem item: Int) -> String!
    {
        
        return self.resumeBassClass?.jobIntentList![item].name
    }
    func pickerView(_ pickerView: AKPickerView!, didSelectItem item: Int)
    {
      //  pickerView.reloadData()
        print("选中了\(String(describing: self.resumeBassClass?.jobIntentList![item].name))")
        self.jobId = NSNumber.init(value: (self.resumeBassClass?.jobIntentList![item].id)!).stringValue
        
        
        self.getHomePageJobList(dic: ["token":GetUser(key: TOKEN),"jobId":self.jobId])
        
    }
    
    //设置tableView
    func confineTableView() -> Void {
        tableView.register(UINib.init(nibName: "PositionCell", bundle: nil), forCellReuseIdentifier: "PositionCell")
        tableView.register(UINib.init(nibName: "Position2Cell", bundle: nil), forCellReuseIdentifier: "Position2Cell")
        tableView.register(UINib.init(nibName: "Position3Cell", bundle: nil), forCellReuseIdentifier: "Position3Cell")
        tableView.register(UINib.init(nibName: "PositionLongCell", bundle: nil), forCellReuseIdentifier: "PositionLongCell")
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
        switch indexPath.section {
        case 0:
            return 140
        case 1:
//            if indexPath.row == 0 {
//                return 225
//            }else{
                return 90
         //   }
        default:
            return 0
        }
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
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
    }
    func recommendCellClick(sender:UIButton) -> Void {
        print("sender.tag = \(sender.tag)")
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if indexPath.section == 0 {
            if ScreenWidth == 320{
                let cell:Position3Cell = tableView.dequeueReusableCell(withIdentifier: "Position3Cell") as! Position3Cell
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
                
                return cell
            }
        }else
        {
//            if indexPath.row == 0 {
//                let cell:Position2Cell = tableView.dequeueReusableCell(withIdentifier: "Position2Cell") as! Position2Cell
//                return cell
//            }else{
                let cell:PositionCell = tableView.dequeueReusableCell(withIdentifier: "PositionCell") as! PositionCell
            guard self.homePageJobBassClass != nil else {
                return cell
            }
               let model:FirstJobList = (self.homePageJobBassClass?.list![indexPath.row])!
           
              cell.installPositionCell(jobName: model.jobName!, companyName: model.companyName!, payRange: model.salary!, area: model.city!, yearRange: model.experience!, edu: model.qualification!)
            
                return cell
         //   }
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("点击22")
        if tableView.tag == 100 {
            print("点击33")
        }
        let vc = UIStoryboard.init(name: "UserFirstStoryboard", bundle: nil).instantiateViewController(withIdentifier: "StationDetailVC") as! StationDetailVC
        let model = self.homePageJobBassClass?.list?[indexPath.row]
        vc.userMesJson = self.userMesJson
        vc.intentName = self.jobName
        //求职意向id
        vc.intentId = self.jobId
        //职位id
        vc.jobId = NSNumber.init(value: (model?.id)!).stringValue
        self.navigationController?.pushViewController(vc, animated: true)
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
