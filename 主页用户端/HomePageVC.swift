//
//  HomePageVC.swift
//  Reindeer
//
//  Created by shiliuhua on 16/12/27.
//  Copyright © 2016年 shiliuhua. All rights reserved.
//

import UIKit

class HomePageVC: UIViewController,UITableViewDelegate,UITableViewDataSource {

    
    @IBOutlet var tableView: UITableView!
    
    var arrowView:ArrowsView!
    var titleBtn:UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        confineNavBar()
        confineTableView()
    }
    //设置navBar
    func confineNavBar() -> Void {
        self.navigationController?.navigationBar.barTintColor=UIColor.black
        //消除毛玻璃效果
        self.navigationController?.navigationBar.isTranslucent = false;
        
        let headImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 36, height: 36))
        headImageView.layer.cornerRadius = 18
        headImageView.layer.masksToBounds = true
        headImageView.backgroundColor = UIColor.green
        let leftBarBtnItem = UIBarButtonItem(customView: headImageView)
        self.navigationItem.leftBarButtonItem = leftBarBtnItem
        
    //    let rightBarBtnItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(rightBarBtnClick))
        let installBtn = UIButton(type: .custom)
        installBtn.setImage(UIImage.init(named: "1设置"), for: UIControlState.normal)
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
    //设置按钮点击
    func installBtnClick() -> Void {
        print("设置")
        
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
        return 40
    }
       func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        guard section == 1 else {
            return nil
        }
        let headView = DropDownView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 40))
        headView.supViewController = self
        headView.backgroundColor = UIColor.blue
       
        return headView
        
    }
    func btnClick(btn:UIButton) -> Void {
        print("点击了第\(btn.tag)个按钮")
    }
    //rightBarBtnClick
    func rightBarBtnClick() -> Void {
        print("rightBarBtnClick")
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
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if indexPath.section == 0 {
            if ScreenWidth == 320{
                let cell:Position3Cell = tableView.dequeueReusableCell(withIdentifier: "Position3Cell") as! Position3Cell
                
                return cell
            }else {
                let cell:PositionLongCell = tableView.dequeueReusableCell(withIdentifier: "PositionLongCell") as! PositionLongCell
                
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
