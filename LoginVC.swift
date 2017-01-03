//
//  LoginVC.swift
//  Reindeer
//
//  Created by shiliuhua on 16/12/26.
//  Copyright © 2016年 shiliuhua. All rights reserved.
//

import UIKit

class LoginVC: UIViewController {

    
    var token = "eyJhbGciOiJIUzUxMiIsInppcCI6IkdaSVAifQ.H4sIAAAAAAAAAKtWKi5NUrJSMlKqBQBuk7zJCwAAAA.RPGxEneRZjimYveUz7Gol_QN8dtRaQx_LotSBSUCxWUk7FadPiWQQSaoK-e66yyORad-D02F7LfwlIrY-f5bQg"
    
    @IBOutlet var phoneNumTextField: UITextField!
    
    @IBOutlet var passwordTextField: UITextField!
    
    
    @IBAction func LoginBtnClick(_ sender: UIButton) {
        
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
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
