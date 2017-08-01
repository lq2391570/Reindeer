//
//  BaseViewVC.swift
//  Reindeer
//
//  Created by shiliuhua on 17/2/22.
//  Copyright © 2017年 shiliuhua. All rights reserved.
//

import UIKit
import SwiftyJSON
import SVProgressHUD
//import NIMSDK
class BaseViewVC: UIViewController {
       override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.barTintColor=UIColor.black
        //消除毛玻璃效果
        self.navigationController?.navigationBar.isTranslucent = false;
      //  self.title = "完善公司信息"
        self.navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName:UIFont.systemFont(ofSize: 20)]
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.mainColor]
        SVProgressHUD.setDefaultMaskType(.none)
        
        
        if self.navigationController != nil{
            //自定义左键，并重写返回方法
            let leftBtn = UIButton(type: .custom)
            leftBtn.frame = CGRect.init(x: 0, y: 0, width: 20, height: 20)
            leftBtn.setImage(UIImage.init(named: "返回new"), for: .normal)
            leftBtn.addTarget(self, action: #selector(leftReturnBtnClick), for: .touchUpInside)
            let leftBarButtonItem = UIBarButtonItem(customView: leftBtn)
            self.navigationItem.leftBarButtonItem = leftBarButtonItem
            
        }
        
    }
    func leftReturnBtnClick() -> Void {
       _ = self.navigationController?.popViewController(animated: true)
        
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
