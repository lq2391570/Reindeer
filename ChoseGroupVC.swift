//
//  ChoseGroupVC.swift
//  Reindeer
//
//  Created by shiliuhua on 17/2/6.
//  Copyright © 2017年 shiliuhua. All rights reserved.
//

import UIKit
import SVProgressHUD
class ChoseGroupVC: UIViewController {

    @IBOutlet var bgImageView: UIImageView!
    
    @IBOutlet var choseWorkBtn: UIButton!
    
    @IBOutlet var recruitBtn: UIButton!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createAnimationForBGImageView()
        installRecruitBtn()
        // Do any additional setup after loading the view.
    }
//设置recruitBtn
    func installRecruitBtn() -> Void {
        recruitBtn.layer.borderColor = UIColor.mainColor.cgColor
        recruitBtn.layer.borderWidth = 0.5
    }
    //我找工作
    @IBAction func choseWorkBtnClick(_ sender: UIButton) {
        SVProgressHUD.show()
        choseWorkSwitch(dic: ["token":GetUser(key: "token")], actionHandler: { (jsonStr) in
            print("choseWorkJsonStr=\(jsonStr)")
            if jsonStr["code"] == 0 {
                //先判断是否完善了信息（注册的话先去完善）
                let vc = UIStoryboard(name: "LoginAndUserStoryboard", bundle: nil).instantiateViewController(withIdentifier: "CompleteUserMesVC") as! CompleteUserMesVC
           
                let nav = UINavigationController.init(rootViewController: vc)
                
                self.view.window?.rootViewController = nav
                
            }
        }, fail: {
            
        })
    }
    @IBAction func recruitBtnClick(_ sender: UIButton) {
        choseHRSwitch(dic: ["token":GetUser(key: "token")], actionHandler: { (jsonStr) in
            print("choseHRJsonStr=\(jsonStr)")
        }, fail: {
            
        })
    }
    //背景做动画
    func createAnimationForBGImageView() -> Void {
        let scaleAnimation = CABasicAnimation.init(keyPath: "transform.scale")
        scaleAnimation.fromValue = NSNumber(value: 1)
        scaleAnimation.toValue = NSNumber(value: 2)
        scaleAnimation.duration = 10
        scaleAnimation.repeatCount = MAXFLOAT
        bgImageView.layer.add(scaleAnimation, forKey: nil)
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
