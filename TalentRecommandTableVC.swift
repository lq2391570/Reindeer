//
//  TalentRecommandTableVC.swift
//  Reindeer
//
//  Created by shiliuhua on 2017/8/22.
//  Copyright © 2017年 shiliuhua. All rights reserved.
//

import UIKit
import SwiftyJSON
import MJRefresh
import DZNEmptyDataSet
import JCAlertView
class TalentRecommandTableVC: BaseViewVC,UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate {

    @IBOutlet var tableView: UITableView!
    
    var positionTypeId:Int?
    
    var typeNum = 1  //类型 1推荐给我 2我推荐的
    //顶部刷新
    var header = MJRefreshGifHeader()
    //底部刷新
    let footer = MJRefreshAutoFooter()

    var bassClass:MyRecommendMyRecommendBassClass?
    //搜索条件（职位列表）
    var positionBassClass:ConditionConditionBassClass?
    
    //选择的model
    var selectModel:ConditionList?
    
    var label = UILabel()
    
    @IBOutlet var filterView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
         tableView.delegate = self
        tableView.dataSource = self
        tableView.emptyDataSetSource = self
        tableView.emptyDataSetDelegate = self

        tableView.register(UINib.init(nibName: "TalentRecommendCell", bundle: nil), forCellReuseIdentifier: "TalentRecommendCell")
        tableView.tableFooterView = UIView()
        // Do any additional setup after loading the view.
        getRecommendList()
        self.tableView.mj_header = setUpMJHeader(refreshingClosure: {
        self.getRecommendList()
        })
//       self.tableView.tableHeaderView = createTableViewHeadView()
//        createLayout()
        getPositionTypeList(typeNum: self.typeNum)
        
    }
    
    
    @IBAction func filterBtnClick(_ sender: UIButton) {
        print("筛选点击")
        if let customView = PositionFilterView.newInstance(superView: self.view) {
            let customAlert = JCAlertView.init(customView: customView, dismissWhenTouchedBackground: true)
            customAlert?.center = CGPoint.init(x: ScreenWidth/2, y:  ScreenHeight/2 - sender.center.y)
            customView.positionBassClass = self.positionBassClass
            customView.tableView.reloadData()
            customView.selectPositionClosure = { model in
                print("选择了\(model.name ?? "")")
                self.selectModel = model
                self.getRecommendListWithPositionId(positionId: model.id!)
                customAlert?.dismiss(completion: nil)
            }
            customAlert?.show()
        }
        
    }
    
//    //获得职位列表
    func getPositionTypeList(typeNum:Int) -> Void {
        positionConditionInterface(dic: ["token":GetUser(key: TOKEN),"type":typeNum], actionHander: { (bassClass) in
            self.positionBassClass = bassClass
            
        
        }) { 
            
        }
        
    }
    
    
    
    //创建布局
    func createLayout() -> Void {
        label.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.tableView.snp.left).offset(8)
            maker.right.equalTo(self.tableView.snp.right).offset(-8)
            maker.top.equalTo(self.tableView.snp.top).offset(10)
            //maker.bottom.equalTo((self.tableView.tableHeaderView?.snp.bottom)!).offset(-10)
        }
        self.tableView.reloadData()
    }
    func createTableViewHeadView() -> UIView {
        
        label.backgroundColor = UIColor.init(red: 246/255.0, green: 246/255.0, blue: 246/255.0, alpha: 1)
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 15)
        label.text = "按岗位筛选 ∨"
        
        return label
        
        
    }
    
    
    func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
        return UIImage(named: "null_icon.png")
    }
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let text = "点击刷新"
        let attributes = [NSFontAttributeName:UIFont.boldSystemFont(ofSize: 18),NSForegroundColorAttributeName:UIColor.gray]
        return NSAttributedString.init(string: text, attributes: attributes)
        
    }
    func emptyDataSet(_ scrollView: UIScrollView!, didTap view: UIView!) {
        print("点击kongbai")
       
            self.tableView.mj_header.beginRefreshing {
                self.getRecommendList()
            }
        
        
    }
    //获得推荐列表
    func getRecommendList() -> Void {
        let dic:NSDictionary = [
            "token":GetUser(key: TOKEN),
            "type":typeNum,
            "no":1,
            "size":100
        ]
        let jsonStr = JSON(dic)
        let newDic:NSDictionary = jsonStr.dictionaryValue as NSDictionary
        
        HRMyRecommendList(dic: newDic, actionHander: { (bassClass) in
            self.bassClass = bassClass
            self.tableView.reloadData()
            self.tableView.mj_header.endRefreshing()
        }) { 
            
        }
    }
    //根据职位id获得推荐列表
    func getRecommendListWithPositionId(positionId:Int) -> Void {
        let dic:NSDictionary = [
            "token":GetUser(key: TOKEN),
            "type":typeNum,
            "no":1,
            "size":100,
            "id":positionId
        ]
        
        let jsonStr = JSON(dic)
        let newDic:NSDictionary = jsonStr.dictionaryValue as NSDictionary
        print("newDic = \(newDic)")
        HRMyRecommendList(dic: newDic, actionHander: { (bassClass) in
            self.bassClass = bassClass
            self.tableView.reloadData()
            self.tableView.mj_header.endRefreshing()
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
            let model:MyRecommendList = (self.bassClass?.list![indexPath.section])!
            let cell = tableView.dequeueReusableCell(withIdentifier: "TalentRecommendCell") as! TalentRecommendCell
            if self.typeNum == 1 {
                cell.installCell(leftStr: "来自 \(model.referrer ?? "") 的推荐", rightStr: "已推荐\(model.recommendCount ?? 0)人", headImageStr: model.avatar, name: model.name, money: model.salary, area: model.area, year: model.exp, edu: model.edu, intro: model.reason)
            }else{
                cell.installCell(leftStr: "推荐给 \(model.receiver ?? "")", rightStr: "已推荐\(model.recommendCount ?? 0)人", headImageStr: model.avatar, name: model.name, money: model.salary, area: model.area, year: model.exp, edu: model.edu, intro: model.reason)
                
            }
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "TalentRecommendCell") as! TalentRecommendCell
            return cell
        }
        
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 153
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        if self.bassClass != nil {
            return (self.bassClass?.list?.count)!
        }
        return 0
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
