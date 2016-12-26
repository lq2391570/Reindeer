//
//  WebVC.swift
//  Reindeer
//
//  Created by shiliuhua on 16/12/23.
//  Copyright © 2016年 shiliuhua. All rights reserved.
//

import UIKit
import WebKit
class WebVC: UIViewController {

    var webStr = ""
    
    @IBOutlet var cancelBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let webView = WKWebView(frame: view.bounds)
        let request = NSURLRequest(url: NSURL(string: webStr) as! URL)
        print("webStr=\(webStr)")
        webView.load(request as URLRequest)
        
        self.view.addSubview(webView)
        self.view.bringSubview(toFront: cancelBtn)
        
    }
    @IBAction func cancelToPlayersViewController(_ segue:UIStoryboardSegue) {
        
       
    }
    
    
    @IBAction func dissMissVC(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
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
