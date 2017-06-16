//
//  NotiAllVC.swift
//  Reindeer
//
//  Created by shiliuhua on 2017/6/12.
//  Copyright © 2017年 shiliuhua. All rights reserved.
//

import UIKit

class NotiAllVC: BaseViewVC,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.title = "通知"
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib.init(nibName: "NotiCell", bundle: nil), forCellReuseIdentifier: "NotiCell")
        tableView.tableFooterView = UIView()
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 3
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotiCell") as! NotiCell
        if indexPath.row == 0 {
            cell.headimage.image = UIImage.init(named: "系统通知noti.png")
            cell.titleLabel.text = "系统通知"
        }else if indexPath.row == 1 {
            cell.headimage.image = UIImage.init(named: "视频面试通知noti.png")
            cell.titleLabel.text = "视频面试通知"
        }else if indexPath.row == 2 {
            cell.headimage.image = UIImage.init(named: "普通面试通知noti.png")
            cell.titleLabel.text = "普通面试通知"
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = UIStoryboard.init(name: "UserFirstStoryboard", bundle: nil).instantiateViewController(withIdentifier: "NotiDetailVC") as! NotiDetailVC
        if indexPath.row == 0 {
            vc.notiType = 1
            vc.title = "系统通知"
        }else if indexPath.row == 1 {
            vc.notiType = 2
            vc.title = "视频面试通知"
        }else if indexPath.row == 2{
            vc.notiType = 3
            vc.title = "普通面试通知"
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 1
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
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
