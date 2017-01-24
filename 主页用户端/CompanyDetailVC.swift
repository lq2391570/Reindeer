//
//  CompanyDetailVC.swift
//  Reindeer
//
//  Created by shiliuhua on 17/1/24.
//  Copyright © 2017年 shiliuhua. All rights reserved.
//

import UIKit

class CompanyDetailVC: UIViewController,UITableViewDelegate,UITableViewDataSource {

    
    @IBOutlet var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        installTableView()
    }
    func installTableView() -> Void {
        tableView.register(UINib.init(nibName: "CompanyTitleCell", bundle: nil), forCellReuseIdentifier: "CompanyTitleCell")
        tableView.register(UINib.init(nibName: "CompanyIntroduceCell", bundle: nil), forCellReuseIdentifier: "CompanyIntroduceCell")
        tableView.estimatedRowHeight = 50
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 2
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                return 44
            }else{
                return UITableViewAutomaticDimension
            }
        }else{
            return 44
        }
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "CompanyTitleCell") as! CompanyTitleCell
                return cell
            }else{
                let cell = tableView.dequeueReusableCell(withIdentifier: "CompanyIntroduceCell") as! CompanyIntroduceCell
                return cell
            }
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "CompanyTitleCell") as! CompanyTitleCell
            return cell
        }
        
    }
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
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
