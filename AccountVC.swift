//
//  AccountVC.swift
//  Reindeer
//
//  Created by shiliuhua on 2017/6/26.
//  Copyright © 2017年 shiliuhua. All rights reserved.
//

import UIKit

class AccountVC: BaseViewVC {

    @IBOutlet var accountNumLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        getAccountBalance()
    }

    //获得账户余额
    func getAccountBalance() -> Void {
        HRAccountBalance(dic: ["token":GetUser(key: TOKEN)], actionHander: { (jsonStr) in
            if jsonStr["code"] == 0 {
                self.accountNumLabel.text = jsonStr["balance"].stringValue
            }
        }) { 
            
        }
    }
    
    @IBAction func accountManagerClick(_ sender: UIButton) {
        let vc = UIStoryboard(name: "UserCenter", bundle: nil).instantiateViewController(withIdentifier: "AccountListVC") as! AccountListVC
        vc.title = "账户记录"
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func rechargeClick(_ sender: UIButton) {
        
        
    }
    
    @IBAction func applyInvoiceClick(_ sender: UIButton) {
        
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
