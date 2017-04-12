//
//  ChoseIntensionVC.swift
//  Reindeer
//
//  Created by shiliuhua on 17/4/5.
//  Copyright © 2017年 shiliuhua. All rights reserved.
//

import UIKit
import Spring
import SVProgressHUD
class ChoseIntensionVC: BaseViewVC,UITableViewDelegate,UITableViewDataSource,UISearchControllerDelegate,UISearchBarDelegate {
    
    
    @IBOutlet var tableView: UITableView!
     var searchController:UISearchController!
    var tempArray:NSMutableArray = []
    var searchVC:SearchPositionVC!
    
    
    var TranslucentModel = TranslucentViewSingleTon.translucentView
    //半透明遮罩View
  //  var translucentView:UIView!
    //单行单例（必须保证init方法的私有性，只有这样，才能保证单例是真正唯一的，避免外部对象通过访问init方法创建单例类的其他实例）
    class TranslucentViewSingleTon:NSObject,UITableViewDelegate,UITableViewDataSource{
        static let translucentView = TranslucentViewSingleTon()
        private override init() {} //This prevents others from using the default '()' initializer for this class.
        var backgroundView : UIView!
        //rightView
        var rightView: UIView!
        //选择后的传值闭包
        var returnClosure:((PositionList) -> ())?
        //二级tableView
        var leftTableView:UITableView!
        var rightTableView:UITableView!
        
        var leftTableViewTempArray:NSMutableArray = []
        var rightTableViewTempArray:NSMutableArray = []
        var superVC:ChoseIntensionVC!
        
        func setupTableView() -> Void {
            leftTableView = UITableView(frame: CGRect.init(x: 0, y: 0, width: rightView.frame.size.width/2, height: rightView.frame.height), style: .plain)
            leftTableView.delegate = self
            leftTableView.dataSource = self
            leftTableView.tag = 11
            leftTableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: "leftCell")
            leftTableView.separatorStyle = .none
            rightView.addSubview(leftTableView)
            rightTableView = UITableView(frame: CGRect.init(x: rightView.frame.size.width/2, y: 0, width: rightView.frame.size.width/2, height: rightView.frame.height), style: .plain)
            rightTableView.dataSource = self
            rightTableView.delegate = self
            rightTableView.tag = 22
            rightTableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: "rightCell")
            rightTableView.separatorStyle = .none
            rightView.addSubview(rightTableView)
            
        }
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
        {
            if tableView.tag == 11 {
                return leftTableViewTempArray.count
            }else if tableView.tag == 22 {
                return rightTableViewTempArray.count
            }
            return 0
            
        }
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
        {
            if tableView.tag == 11 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "leftCell")
                let listModel:PositionList = leftTableViewTempArray[indexPath.row] as! PositionList
                cell?.textLabel?.font = UIFont.systemFont(ofSize: 14)
                cell?.textLabel?.text = listModel.name
                cell?.textLabel?.numberOfLines = 0
                cell?.selectionStyle = .blue
                cell?.tag = indexPath.row
                return cell!
            }else{
                let cell = tableView.dequeueReusableCell(withIdentifier: "rightCell")
                let listModel:PositionList = rightTableViewTempArray[indexPath.row] as! PositionList
                cell?.textLabel?.font = UIFont.systemFont(ofSize: 14)
                cell?.textLabel?.text = listModel.name
                cell?.textLabel?.numberOfLines = 0
                cell?.selectionStyle = .none
                return cell!
            }
            
        }
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            if tableView.tag == 11 {
                
                 let listModel:PositionList = leftTableViewTempArray[indexPath.row] as! PositionList
                getPositionIntension2(pid: NSNumber.init(value: listModel.id!).stringValue)
            }else if tableView.tag == 22 {
                let listModel:PositionList = rightTableViewTempArray[indexPath.row] as! PositionList
                print("选择了\(listModel.name)")
                if (returnClosure != nil) {
                    returnClosure!(listModel)
                   _ = superVC.navigationController?.popViewController(animated: true)
                }
            }
        }
        
        func setbackgroundView(frame:CGRect, superView:UIView,pid:Int,supVC:ChoseIntensionVC) -> Void {
            backgroundView = UIView(frame: frame)
            backgroundView.backgroundColor = UIColor.black
            backgroundView.alpha = 0.5
            backgroundView.isUserInteractionEnabled = true
            let tapReginer = UITapGestureRecognizer(target: self, action: #selector(backgroundViewTapClic(_:)))
            backgroundView.addGestureRecognizer(tapReginer)
            superView.addSubview(backgroundView)
            
            setRightView(frame: frame, superView: superView)
            setupTableView()
            getPositionIntension(pid: NSNumber.init(value: pid).stringValue)
            superVC = supVC
            
            
        }
        @objc func backgroundViewTapClic(_ reign:UIGestureRecognizer) -> Void {
            
            SpringAnimation.spring(duration: 0.8) {
                self.backgroundView.alpha = 0
                self.rightView.frame = CGRect(x: (reign.view?.frame.size.width)!, y: 0, width: (reign.view?.frame.size.width)!*5/6, height: (reign.view?.frame.size.height)!)
            }
            
        }
        func setRightView(frame:CGRect,superView:UIView) -> Void {
            rightView = UIView(frame: CGRect.init(x: frame.size.width, y: 0, width: frame.size.width*5/6, height: frame.size.height))
            rightView.backgroundColor = UIColor.white
            superView.addSubview(rightView)
            SpringAnimation.spring(duration: 0.5) {
                self.rightView.frame = CGRect(x: frame.size.width/6+20, y: 0, width: frame.size.width*5/6, height: frame.size.height)
                self.rightTableViewTempArray.removeAllObjects()
            }
            
        }
        //获得职位分类
        func getPositionIntension(pid:String) -> Void {
            positionClassify(dic: ["pid":pid,"no":1,"size":1000], actionHandler: { (bassClass) in
                
                print("bassclass.msg = \(bassClass.msg)")
                self.leftTableViewTempArray.removeAllObjects()
                self.leftTableViewTempArray.addObjects(from: bassClass.list!)
                self.leftTableView.reloadData()
                if self.leftTableViewTempArray.count>0{
                    let listModel:PositionList = self.leftTableViewTempArray[0] as! PositionList
                    self.getPositionIntension2(pid: NSNumber.init(value: listModel.id!).stringValue)
                }
                
                
            }) {
                SVProgressHUD.showInfo(withStatus: "请求失败")
            }
        }
        //获得职位分类2
        func getPositionIntension2(pid:String) -> Void {
            positionClassify(dic: ["pid":pid,"no":1,"size":1000], actionHandler: { (bassClass) in
                
                print("bassclass.msg = \(bassClass.msg)")
                self.rightTableViewTempArray.removeAllObjects()
                self.rightTableViewTempArray.addObjects(from: bassClass.list!)
                self.rightTableView.reloadData()
                
            }) {
                SVProgressHUD.showInfo(withStatus: "请求失败")
            }
        }

        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "选择职位类型"
        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: "cell")
        getPositionIntension(pid: "")
        
            if searchController == nil {
            searchVC = SearchPositionVC.init()
            searchVC.view.backgroundColor = UIColor.white
            searchController = UISearchController(searchResultsController: searchVC)
            searchController.searchBar.sizeToFit()
            searchController.dimsBackgroundDuringPresentation = true
            searchController.hidesNavigationBarDuringPresentation = true
            searchController.searchBar.placeholder = "请输入职位关键字"
            searchController.delegate = self
            searchController.searchBar.delegate = self
                
                
            self.tableView.tableHeaderView = searchController.searchBar
            self.definesPresentationContext = true
            self.automaticallyAdjustsScrollViewInsets = false
                
        }
        
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String)
    {
        print("searchText = \(searchText)")
        searchVC.tempArray.add(searchText)
        searchVC.tableView.reloadData()
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return tempArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        let listModel:PositionList = tempArray[indexPath.row] as! PositionList
        cell?.textLabel?.font = UIFont.systemFont(ofSize: 14)
        cell?.textLabel?.text = listModel.name
        return cell!
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("点击列表")
        
         let listModel:PositionList = tempArray[indexPath.row] as! PositionList
         TranslucentModel.setbackgroundView(frame: self.tableView.frame, superView: self.tableView, pid: listModel.id!,supVC: self)
    }
    
    //获得职位分类
    func getPositionIntension(pid:String) -> Void {
        positionClassify(dic: ["pid":pid,"no":1,"size":1000], actionHandler: { (bassClass) in
            print("bassclass.msg = \(bassClass.msg)")
            self.tempArray.addObjects(from: bassClass.list!)
            self.tableView.reloadData()
        }) { 
            SVProgressHUD.showInfo(withStatus: "请求失败")
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
