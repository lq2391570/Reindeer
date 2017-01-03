//
//  ViewController.swift
//  Reindeer
//
//  Created by shiliuhua on 16/12/21.
//  Copyright © 2016年 shiliuhua. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        print("123")
        
    }

    @IBAction func gotoLogin(_ sender: UIButton) {
        
        let vc = UIStoryboard(name: "LoginAndUserStoryboard", bundle: nil).instantiateInitialViewController()
        self.navigationController?.pushViewController(vc!, animated: true)
        
        
    }
    
    @IBAction func gotoHomePage(_ sender: UIButton) {
        let vc = UIStoryboard(name: "UserFirstStoryboard", bundle: nil).instantiateInitialViewController()
        let nav = UINavigationController(rootViewController: vc!)
        self.view.window?.rootViewController = nav
        
    //    self.navigationController.roo
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

