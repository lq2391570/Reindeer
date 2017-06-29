//
//  RechargeVC.swift
//  Reindeer
//
//  Created by shiliuhua on 2017/6/27.
//  Copyright © 2017年 shiliuhua. All rights reserved.
//

import UIKit
import SVProgressHUD
import SwiftyJSON
class RechargeVC: BaseViewVC {

    @IBOutlet var numOfMoneyTextField: UITextField!
    
    @IBOutlet var zhiFuBaoBtn: UIButton!
    
    @IBOutlet var weiXinBtn: UIButton!
    //支付link
    var orderString = ""
    //后台订单id
    var outTradeNo = ""
    //支付成功后的返回闭包
    var succeedReturnClosure:(() ->())?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(wxPaySucceed), name: NSNotification.Name(rawValue: "wxPaySucceed"), object: nil)
        
        // Do any additional setup after loading the view.
       //ssd numOfMoneyTextField.text = "0";
    }
    func wxPaySucceed() -> Void {
        print("微信支付成功")
        succeedReturnClosure!()
        _ = self.navigationController?.popViewController(animated: true)
        
    }
    @IBAction func zhifubaoBtnClick(_ sender: UIButton) {
        
        if numOfMoneyTextField.text == "" {
            SVProgressHUD.showInfo(withStatus: "请输入充值金额")
            return
        }
        
        AlipayZhiFu(dic: ["token":GetUser(key: TOKEN),"money":"0.01"], actionHander: { (jsonStr) in
            if jsonStr["code"] == 0 {
                print("请求支付成功")
                self.orderString = jsonStr["orderString"].stringValue
                self.outTradeNo = jsonStr["outTradeNo"].stringValue
                AlipaySDK.defaultService().payOrder(self.orderString, fromScheme: "alisdkPay", callback: { (result) in
                    if let alipayjson = result as NSDictionary?{
                        
                        print("ailpayresult = \(alipayjson)")
                      
                        var memo = ""
                        let resultStatus = alipayjson.value(forKey: "resultStatus") as! String
                        if resultStatus == "9000" {
                            memo = "支付成功"
                            SVProgressHUD.showSuccess(withStatus: memo)
                            self.succeedReturnClosure!()
                            _ = self.navigationController?.popViewController(animated: true)
                        }else{
                            switch resultStatus {
                            case "4000" :
                                memo = "失败原因:订单支付失败"
                                break
                            case "6001":
                                memo = "失败原因:用户中途取消"
                                break
                            case "6002":
                                memo = "失败原因:网络连接出错！"
                                break
                            case "8000":
                                memo = "正在处理中..."
                                break
                            default:
                                memo = alipayjson.value(forKey: "memo") as! String
                                break
                            }
                        }
                        
                        SVProgressHUD.showInfo(withStatus: memo)

                    }
                    
                   
                    
                })
            }else{
                SVProgressHUD.showInfo(withStatus: jsonStr["msg"].stringValue)
                
            }
            
            
        }) { 
            SVProgressHUD.showInfo(withStatus: "请求失败")
        }
    }

    @IBAction func weiXinBtnClick(_ sender: UIButton) {
        if numOfMoneyTextField.text == "" {
            SVProgressHUD.showInfo(withStatus: "请输入充值金额")
            return
        }
        wxPayInterface(dic: ["token":GetUser(key: TOKEN),"money":"0.01"], actionHander: { (jsonStr) in
            if jsonStr["code"] == 0 {
                let req = PayReq()
                req.partnerId = jsonStr["partnerId"].stringValue
                req.prepayId = jsonStr["prepayId"].stringValue
                req.nonceStr = jsonStr["nonceStr"].stringValue
                let currentDate:NSDate = NSDate.init()
//                print("currentDate = \(currentDate)")
//                
//                let timeTap = UInt32(dateTransformUnixStr(date: (currentDate) as Date))!
                let timeTap:TimeInterval = currentDate.timeIntervalSince1970
                let timeTapNoPoint = String.init(format: "%0.f",timeTap)
                
                req.timeStamp = UInt32(timeTapNoPoint)!
                req.package = "Sign=WXPay"
                req.sign = jsonStr["sign"].stringValue
                WXApi.send(req)
                print("timeTap = \(req.timeStamp)")
                print("")
                
            }else{
                
                SVProgressHUD.showInfo(withStatus: jsonStr["msg"].stringValue)
            }
            
           
            
        }) { 
            SVProgressHUD.showInfo(withStatus: "请求失败")
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
