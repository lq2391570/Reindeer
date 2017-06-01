//
//  BaseViewVC.swift
//  Reindeer
//
//  Created by shiliuhua on 17/2/22.
//  Copyright © 2017年 shiliuhua. All rights reserved.
//

import UIKit
import SwiftyJSON
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
