//
//  DropDownView.swift
//  Reindeer
//
//  Created by shiliuhua on 16/12/30.
//  Copyright © 2016年 shiliuhua. All rights reserved.
//

import UIKit
import SnapKit


class DropDownView: UIView,UITableViewDelegate,UITableViewDataSource{

    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    var supViewController:UIViewController?
    
    //半透明大背景
    var transparentView:UIView?
    //全局btn（布局用）
    var overAllBtn:UIButton?
    //页面类型(枚举)应聘者
    enum viewType {
        case recommend //推荐
        case area      //地区
        case InterviewTime  //面试时间
        case filter     //筛选
    }
    enum viewTypeHR {
        case HRRecommend //推荐
        case HRPay       //薪资
        case HRExp       //经验
        case HREdu       //学历
    }
    
    // 全局类型
    var viewTypeNum:viewType?
    //底部view
    var bottomView:UIView!
    
    var tableView:UITableView!
    
    var recommendArray = ["推荐","最新"]
    
    var recommendSelect = false
    
    //是否展开
    var isOpen = false
    
    //设置一个secitionheight的colsure
    
    var viewHeight:((CGFloat) -> ())?
    
    //选择按钮的点击事件闭包
    var titleBtnClickClosure:((_ sender:UIButton,_ heightOfView:CGFloat) ->())?
    //背景高度
    var heightOftransparentView:CGFloat!
    //面试时间model
    var interViewModel:PositionBaseClass?
    
    
    
    override func draw(_ rect: CGRect) {
        // Drawing code
       //第一步：添加按钮
       //第二步：添加按钮的点击事件
       //第三步：按钮点击后出现一个半透明背景及不透明的背景
       //第四步：底部添加btn
       //第五步：添加各视图(第一个展开视图为两行的tableView)
        if overAllBtn == nil {
            addChoseBtn(rect)
        }
       //添加一个半透明的背景，大小为刚好覆盖底层
        if transparentView == nil {
            createTransparentView()
    
       //     addTap()
        }
        createBottomView()
        getInterViewList()
    }
    
    //获取面试时间分类
    
    func getInterViewList() -> Void {
          self.interViewModel = getInterViewTypePath()
    }
    
    
//添加按钮
    func addChoseBtn(_ rect:CGRect) -> Void {
        
        let nameArray = ["推荐","地区","面试时间","筛选"]
        
        for index in 1...4 {
            let btn = UIButton(type: .custom)
            btn.frame = CGRect.init(x: rect.size.width/4.0*CGFloat(index-1), y: 0, width: rect.size.width/4.0, height: 40)
            print("rect.size.width/4=\(rect.size.width/4)")
          //  btn.backgroundColor = UIColor.green
            btn.tag = index
           // btn.isSelected = false
            btn.addTarget(self, action: #selector(btnClick(btn:)), for: .touchUpInside)
            self.addSubview(btn)
            //分别创建按钮上的文字和箭头
            let titleLabel = UILabel(frame: CGRect.init(x: btn.frame.midX-btn.frame.minX-30, y: btn.frame.midY-10, width: 60, height: 20))
            titleLabel.font = UIFont.systemFont(ofSize: 14)
            titleLabel.text = nameArray [index-1]
            titleLabel.textAlignment = .center
            titleLabel.tag = index + 100
            btn.addSubview(titleLabel)
            overAllBtn = btn
            let arrowView = ArrowsView(frame: CGRect.init(x: btn.frame.midX-btn.frame.minX-30+40, y: btn.frame.midY-10, width: 20, height: 20))
            if index == 3 {
                arrowView.frame = CGRect.init(x: btn.frame.midX-btn.frame.minX-30+60, y: btn.frame.midY-10, width: 20, height: 20)
            }
            arrowView.backgroundColor = UIColor.clear
            btn.addSubview(arrowView)
            print("btn.frame.midX=\(btn.frame.midX)")
            print("btn.frame.minX=\(btn.frame.minX)")
        }

    }
    func btnClick(btn:UIButton) -> Void {
        print("点击了第\(btn.tag)个按钮")
    print("heightOfsupViewController?.view=\(supViewController?.view.frame.size.height)")
        print("overAllBtn.frame=\(overAllBtn?.frame)")
        print("selfOfHeight=\(self.frame)")
        
        if btn.isSelected == true {
            let label:UILabel = btn.viewWithTag(btn.tag + 100) as! UILabel
            print("label.text = \(label.text)")
            label.textColor = UIColor.init(red: 206/255.0, green: 88/255.0, blue: 61/255.0, alpha: 1)
            btn.isSelected = false
        }else{
            let label:UILabel = btn.viewWithTag(btn.tag + 100) as! UILabel
            print("label.text = \(label.text)")
            label.textColor = UIColor.black
            btn.isSelected = true
        }
        
        
        if isOpen == false{
            switch btn.tag {
            case 1:
                viewTypeNum = .recommend
            case 2:
                viewTypeNum = .area
            case 3:
                viewTypeNum = .InterviewTime
                self.tableView.reloadData()
            case 4:
                viewTypeNum = .filter
                self.tableView.reloadData()
            default:
                break
            }
            transparentView?.isHidden = false
      //      updatetransparentView()
            print("heightOftransparentView=\(transparentView?.frame)")
            //重新计算tableView高度
            reCalculateHeight()
      
            //闭包传值
             heightOftransparentView = transparentView?.frame.size.height
            isOpen = true
            titleBtnClickClosure?(btn,heightOftransparentView)
            //transparentView 重新赋值
        }else{
            
            transparentView?.isHidden = true
            isOpen = false
            //闭包传值
            titleBtnClickClosure?(btn,0)
            
        }
        
    }
    //transparentView 重新赋值（bottom应为self.snp.bottom,因为supViewController?.view.snp.bottom的高度不确定）
    func updatetransparentView() -> Void {
        transparentView?.snp.makeConstraints({ (make) in
            make.width.equalToSuperview()
           make.height.equalTo(ScreenHeight-self.frame.origin.y-60)
            make.top.equalTo((overAllBtn?.snp.bottom)!).offset(0)
        })
    }
    
    //重新计算tableView高度（选项不同高度不同）
    func reCalculateHeight() -> Void {
        if viewTypeNum == viewType.recommend {
            tableView.snp.updateConstraints({ (make) in
                make.bottom.equalTo((transparentView?.snp.bottom)!).offset(-60)
            })
            }else{
            tableView.snp.updateConstraints({ (make) in
                make.bottom.equalTo((transparentView?.snp.bottom)!).offset(-60)
            })
        }
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
         print("=heightOftransparentView=\(transparentView?.frame.size.height)")
    }
    //半透明的大背景
    func createTransparentView() -> Void {
        self.backgroundColor = UIColor.clear
        transparentView = UIView()
        transparentView?.backgroundColor = UIColor.black
       // transparentView?.alpha = 0.1
      //  transparentView?.isUserInteractionEnabled = false
        self.addSubview(transparentView!)
        //tableView
        tableView = UITableView(frame: CGRect.init(), style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
       // tableView.isUserInteractionEnabled = false
        tableView.register(UINib.init(nibName: "SelectorCell", bundle: nil), forCellReuseIdentifier: "SelectorCell")
        tableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: "timeCell")
        tableView.register(UINib.init(nibName: "InterViewTimeCell", bundle: nil), forCellReuseIdentifier: "InterViewTimeCell")
        tableView.register(UINib.init(nibName: "FilterCell", bundle: nil), forCellReuseIdentifier: "FilterCell")
        
        
        
        transparentView?.addSubview(tableView)
        //需要autoLayout
        transparentView?.snp.makeConstraints({ (make) in
            make.width.equalToSuperview()
          //  make.bottom.equalTo((supViewController?.view.snp.bottom)!).offset(0)
            make.height.equalTo(ScreenHeight-100)
            make.top.equalTo((overAllBtn?.snp.bottom)!).offset(0)
        })
        tableView.snp.makeConstraints { (make) in
            make.width.equalToSuperview()
            make.top.equalTo((transparentView?.snp.top)!).offset(0)
            make.bottom.equalTo((transparentView?.snp.bottom)!).offset(-60)
        }
        transparentView?.isHidden = true
    }
    //背景添加手势
    func addTap() -> Void {
        let tapGR = UITapGestureRecognizer(target: self, action: #selector(tapGRHandler))
          transparentView?.isUserInteractionEnabled = true
          transparentView?.addGestureRecognizer(tapGR)
      
    }
    //背景的点击事件
    func tapGRHandler() -> Void {
        print("点击背景")
    }
    //创建一个底部View
    func createBottomView() -> Void {
        bottomView = UIView()
        bottomView.backgroundColor = UIColor(red: 241/255.0, green: 237/255.0, blue: 236/255.0, alpha: 1)
        transparentView?.addSubview(bottomView)
        //确定按钮
        let sureBtn = UIButton(type: .custom)
        sureBtn.backgroundColor = UIColor.black
        sureBtn.layer.cornerRadius = 5
        sureBtn.setTitle("确定", for: .normal)
        sureBtn.setTitleColor(UIColor.mainColor, for: .normal)
        sureBtn.addTarget(self, action: #selector(sureBtnClick), for: .touchUpInside)
        bottomView.addSubview(sureBtn)
        bottomView.snp.makeConstraints { (make) in
            make.width.equalToSuperview()
            make.height.equalTo(60)
            make.bottom.equalTo((transparentView?.snp.bottom)!).offset(0)
        }
        sureBtn.snp.makeConstraints { (make) in
            make.left.equalTo(bottomView.snp.left).offset(20)
            make.top.equalTo(bottomView.snp.top).offset(5)
            make.right.equalTo(bottomView.snp.right).offset(-20)
            make.bottom.equalTo(bottomView.snp.bottom).offset(-20)
        }
    }
    //底部view重新排布
    func updateBottomView() -> Void {
        bottomView.snp.updateConstraints { (make) in
            make.width.equalToSuperview()
            make.height.equalTo(60)
            make.bottom.equalTo((transparentView?.snp.bottom)!).offset(0)
        }
    }
    
    func sureBtnClick() -> Void {
        print("sureBtnClick")
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if viewTypeNum == viewType.recommend {
            return 40
        }else if viewTypeNum == viewType.InterviewTime
        {
            return 60
        }else if viewTypeNum == viewType.filter
        {
            return 120
        }
        return 44
    }
    func numberOfSections(in tableView: UITableView) -> Int
    {
        
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if viewTypeNum == viewType.recommend {
            return 2
        }else if viewTypeNum == viewType.InterviewTime
        {
            return (self.interViewModel?.list?.count)!
        }else if viewTypeNum == viewType.filter
        {
            return 3
        
        }
        return 0
    }
   
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if viewTypeNum == viewType.recommend {
            if indexPath.row == 0 {
                recommendSelect = false
            }else{
                recommendSelect = true
            }
            tableView.reloadData()
            transparentView?.isHidden = true
            print("点击第\(indexPath.row)行")
        }else if viewTypeNum == viewType.InterviewTime
        {
            
             print("点击第\(indexPath.row)行")
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if viewTypeNum == viewType.InterviewTime {
            let cell = tableView.dequeueReusableCell(withIdentifier: "InterViewTimeCell") as! InterViewTimeCell
            let model:PositionList = (self.interViewModel?.list?[indexPath.row])!
            
            cell.nameLable.text = model.name
            
            return cell
            
//            let cell = tableView.dequeueReusableCell(withIdentifier: "SelectorCell") as! SelectorCell
//            cell.selectorLabel.backgroundColor = UIColor.clear
//            cell.selectorLabel.font = UIFont.systemFont(ofSize: 14)
//            cell.selectorLabel.isselect = recommendSelect
//            cell.selectorLabel.selectstring = recommendArray[indexPath.row]
//            cell.cellBtn.addTarget(self,action:#selector(recommendCellClick(sender:)), for: .touchUpInside)
//            cell.cellBtn.tag = indexPath.row
//            
//            return cell
            
        }else if viewTypeNum == viewType.filter {
            
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "FilterCell") as! FilterCell
            cell.recommendView.removeAllTags()
            let tagArray = ["百度","阿里巴巴","腾讯","中软国际","美团","京东","同纳信息","软通动力"]
            for str in tagArray {
                cell.recommendView.addTag(str)
            }
            if indexPath.row == 0 {
                cell.nameLabel.text = "学历"
            }else if indexPath.row == 1 {
                cell.nameLabel.text = "工作经验"
            }else if indexPath.row == 2 {
                cell.nameLabel.text = "薪资要求"
            }
            
            return cell
            
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SelectorCell") as! SelectorCell
            cell.selectorLabel.backgroundColor = UIColor.clear
            cell.selectorLabel.font = UIFont.systemFont(ofSize: 14)
            cell.selectorLabel.isselect = recommendSelect
            cell.selectorLabel.selectstring = recommendArray[indexPath.row]
            cell.cellBtn.addTarget(self,action:#selector(recommendCellClick(sender:)), for: .touchUpInside)
            cell.cellBtn.tag = indexPath.row
        
            return cell
        
    }
    //cell按钮点击
    func recommendCellClick(sender:UIButton) -> Void {
        print("sender.tag = \(sender.tag)")
        
    }
    
    
}
