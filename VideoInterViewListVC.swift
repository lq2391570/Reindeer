//
//  VideoInterViewListVC.swift
//  Reindeer
//
//  Created by shiliuhua on 2017/5/19.
//  Copyright © 2017年 shiliuhua. All rights reserved.
//

import UIKit
import VTMagic
import SwiftyJSON


class VideoInterViewListVC: BaseViewVC,VTMagicViewDelegate,VTMagicViewDataSource {

    var magController:VTMagicController?
    var jobId = ""
    
    var intentId = ""

    //个人信息json
    var userMesJson:JSON?
    //首页类型（HR或应聘者）
    enum HomepageType:Int {
        case userHomePage = 1 //普通用户
        case HRHomePage   //HR
    }
    
    var homeType:HomepageType = .userHomePage
    
    var titleArray = ["待处理","待面试","已结束","未面试"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addChildViewController(createMagicController())
        self.view.addSubview((magController?.view)!)
        if self.homeType == .userHomePage {
            titleArray = ["待处理","待面试","已结束"]
        }
        self.magController?.magicView.reloadData()
        // Do any additional setup after loading the view.
       
        
    }
    //获得视频面试列表
    
    
    
    func createMagicController() -> VTMagicController {
        if self.magController == nil {
            self.magController = VTMagicController()
            self.magController?.magicView.sliderColor = UIColor.mainColor
            self.magController?.magicView.layoutStyle = .divide
            self.magController?.magicView.delegate = self
            self.magController?.magicView.dataSource = self
            self.magController?.magicView.backgroundColor = UIColor.white
        }
        return magController!
    }
    func menuTitles(for magicView: VTMagicView) -> [String]
    {
        return titleArray
    }
    func magicView(_ magicView: VTMagicView, menuItemAt itemIndex: UInt) -> UIButton
    {
        let itemIdentifier = "itemIdentifier"
        var menuItem = magicView.dequeueReusableItem(withIdentifier: itemIdentifier)
        if menuItem == nil {
            menuItem = UIButton(type: .custom)
            menuItem?.setTitleColor(UIColor.gray, for: .normal)
            menuItem?.setTitleColor(UIColor.black, for: .selected)
            menuItem?.titleLabel?.font = UIFont.systemFont(ofSize: 15)
            
        }
        return menuItem!
    }
    func magicView(_ magicView: VTMagicView, viewControllerAtPage pageIndex: UInt) -> UIViewController
    {
        var vc:VideoTableViewVC? = magicView.dequeueReusablePage(withIdentifier: "VideoTableViewVC") as? VideoTableViewVC
        if vc == nil {
            vc = VideoTableViewVC()
            vc?.jobId = self.jobId
            vc?.userMesJson = self.userMesJson
            vc?.homeType = VideoTableViewVC.HomepageType(rawValue: self.homeType.rawValue)!
            vc?.intentId = self.intentId

        }
        if pageIndex == 0 {
            //   vc?.view.backgroundColor = UIColor.red
            vc?.dataType = .waittingHandle
        }else if pageIndex == 1 {
            vc?.dataType = .waittingInterFace
        }else if pageIndex == 2 {
            vc?.dataType = .alreadyFinish
        }else if pageIndex == 3 {
            vc?.dataType = .didNotInterView
        }

        return vc!
        
        
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
