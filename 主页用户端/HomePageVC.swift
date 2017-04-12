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


class HomePageVC: UIViewController,UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate,PYSearchViewControllerDelegate {

    
    @IBOutlet var tableView: UITableView!
    
    
    var headView:DropDownView?
    var arrowView:ArrowsView!
    var heightOfSeciton:CGFloat = 0.0
    var heightOfSectionAll:CGFloat = 0.0
    //headView是否展开
    var isOpen = false
    
    var titleBtn:UIButton!
    
    var searchController:UISearchController!
    var headImageUrlStr = "'"
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        confineNavBar()
        confineTableView()
        getUserMesAndHeadImage()
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
        self.navigationItem.titleView=createTitleView()

    }
    //个人中心
    func headImageViewTap() -> Void {
        print("头像点击")
        
        let vc = UIStoryboard(name: "UserCenter", bundle: nil).instantiateViewController(withIdentifier: "UserCenterFirstVC") as! UserCenterFirstVC
        self.navigationController?.pushViewController(vc, animated: true)
        
        
    }
    //获取用户基本信息（头像）
    func getUserMesAndHeadImage() -> Void {
        getUserMes(dic: ["token":GetUser(key: TOKEN)], actionHandler: { (jsonStr) in
            if jsonStr["code"] == 0 {
                print("jsonStr = \(jsonStr)")
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
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("点击22")
        if tableView.tag == 100 {
            print("点击33")
        }
        let vc = UIStoryboard.init(name: "UserFirstStoryboard", bundle: nil).instantiateViewController(withIdentifier: "StationDetailVC")
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
    
    //设置tableView
    func confineTableView() -> Void {
        tableView.register(UINib.init(nibName: "PositionCell", bundle: nil), forCellReuseIdentifier: "PositionCell")
        tableView.register(UINib.init(nibName: "Position2Cell", bundle: nil), forCellReuseIdentifier: "Position2Cell")
        tableView.register(UINib.init(nibName: "Position3Cell", bundle: nil), forCellReuseIdentifier: "Position3Cell")
        tableView.register(UINib.init(nibName: "PositionLongCell", bundle: nil), forCellReuseIdentifier: "PositionLongCell")
    //    tableView.tableHeaderView?.isUserInteractionEnabled = false
        tableView.separatorStyle = .none
        
//        let vc = UIViewController.init()
//        vc.view.backgroundColor = UIColor.white
//        searchController = UISearchController(searchResultsController: vc)
//        searchController.searchBar.sizeToFit()
//        searchController.dimsBackgroundDuringPresentation = true
//        searchController.hidesNavigationBarDuringPresentation = true
//        self.view.addSubview(tableView)
//        self.tableView.tableHeaderView = searchController.searchBar
//        self.definesPresentationContext = true
       
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
        print("headView.frame=\(headView?.frame)")
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
            if indexPath.row == 0 {
                return 225
            }else{
                return 90
            }
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
            return 10
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
            if indexPath.row == 0 {
                let cell:Position2Cell = tableView.dequeueReusableCell(withIdentifier: "Position2Cell") as! Position2Cell
                return cell
            }else{
                let cell:PositionCell = tableView.dequeueReusableCell(withIdentifier: "PositionCell") as! PositionCell
                return cell
            }
        }
    }
    //searchBar代理
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool
    {
        return true
    }
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar)
    {
//        print("开始搜索")
//        let vc = UIStoryboard.init(name: "UserFirstStoryboard", bundle: nil).instantiateViewController(withIdentifier: "SearchVC") as! SearchVC
//        let nav = UINavigationController.init(rootViewController: vc)
//        self.present(nav, animated: false, completion: nil)
        
//        //创建热门搜索
//        let hotSearchs = ["Java", "Python", "Objective-C", "Swift", "C", "C++", "PHP", "C#", "Perl", "Go", "JavaScript", "R", "Ruby", "MATLAB"]
//        //创建控制器
//        let searchViewController = PYSearchViewController.init(hotSearches: hotSearchs, searchBarPlaceholder: "搜索职位和企业", didSearch: {(searchViewController,searchBar,SearchText) in
//            let searchVC = SearchVC()
//            
//            searchViewController?.navigationController?.pushViewController(searchVC, animated: true)
//            
//        })
//        //设置风格
//        searchViewController?.hotSearchStyle = .default
//        searchViewController?.searchHistoryStyle = .default
//        searchViewController?.cancelButton.title = "取消"
//        //设置代理
//        searchViewController?.delegate = self
//        searchViewController?.navigationController?.navigationBar.barTintColor=UIColor.black
//        //消除毛玻璃效果
//        searchViewController?.navigationController?.navigationBar.isTranslucent = false;
//        //跳转到搜索控制器
//        let nav = UINavigationController.init(rootViewController: searchViewController!)
//        self.present(nav, animated: false, completion: nil)

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
