//
//  StationDetailVC.swift
//  Reindeer
//
//  Created by shiliuhua on 17/1/9.
//  Copyright © 2017年 shiliuhua. All rights reserved.
//

import UIKit
import JCAlertView
class StationDetailVC: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet var tableView: UITableView!
    
    @IBOutlet var leftBtn: UIButton!
    
    @IBOutlet var rightBtn: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        installTableView()
    }
    //tableView设置
    func installTableView() -> Void {
        tableView.register(UINib.init(nibName: "StationFirstCell", bundle: nil), forCellReuseIdentifier: "StationFirstCell")
        tableView.register(UINib.init(nibName: "InterviewTimeCell", bundle: nil), forCellReuseIdentifier: "InterviewTimeCell")
        tableView.register(UINib.init(nibName: "StationDescripeCell", bundle: nil), forCellReuseIdentifier: "StationDescripeCell")
        tableView.register(UINib.init(nibName: "PublisherCell", bundle: nil), forCellReuseIdentifier: "PublisherCell")
        tableView.register(UINib.init(nibName: "CompanyCell", bundle: nil), forCellReuseIdentifier: "CompanyCell")
        tableView.estimatedRowHeight = 80
    }
    
    @IBAction func btnClick(_ sender: UIButton) {
        if let customView = CustomerInterviewView.newInstance() {
            customView.frame = CGRect.init(x: 0, y: 0, width: 260, height: 280)
            let customAlert = JCAlertView.init(customView: customView, dismissWhenTouchedBackground: true)
            customAlert?.show()
            customView.cancelBtnClickClosure = { (sender) in
                print("点击了取消")
                customAlert?.dismiss(completion: nil)
            }
            customView.sureBtnClickClosure = { (sender) in
                print("点击了确定")
                customAlert?.dismiss(completion: { 
                    //出现成功或失败（根据业务逻辑）
                    let succeedView = Bundle.main.loadNibNamed("SucceedView", owner: self, options: nil)?.last as! SucceedView
                    succeedView.frame = CGRect.init(x: 0, y: 0, width: 260, height: 320)
                    let succeedAlert = JCAlertView.init(customView: succeedView, dismissWhenTouchedBackground: true)
                    succeedAlert?.show()
                    succeedView.cancelBtnClickClsure = { (sender) in
                        print("取消")
                        succeedAlert?.dismiss(completion: nil)
                    }
                    
                })
                
            }
            
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 69
        }else if indexPath.section == 1 {
            return 169
        }else if indexPath.section == 2{
            return UITableViewAutomaticDimension
        }else if indexPath.section == 3 {
            return 96
        }else if indexPath.section == 4 {
            return 148
        }
        return 0
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 5
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 5
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "StationFirstCell")
            cell?.selectionStyle = .none
            return cell!
        }else if indexPath.section == 1{
            let cell = tableView.dequeueReusableCell(withIdentifier: "InterviewTimeCell")
            cell?.selectionStyle = .none
            return cell!
        }else if indexPath.section == 2{
            let cell = tableView.dequeueReusableCell(withIdentifier: "StationDescripeCell") as! StationDescripeCell
            cell.selectionStyle = .none
            cell.contentLabel.text="hihihihihihihihihihihihihihihi"
            return cell
        }else if indexPath.section == 3{
            let cell = tableView.dequeueReusableCell(withIdentifier: "PublisherCell")
            cell?.selectionStyle = .none
            return cell!
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "CompanyCell")
            cell?.selectionStyle = .none
            return cell!
        }
    }
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 5
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 4 {
            let vc = UIStoryboard.init(name: "UserFirstStoryboard", bundle: nil).instantiateViewController(withIdentifier: "CompanyDetailVC") as! CompanyDetailVC
            self.navigationController?.pushViewController(vc, animated: true)
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
