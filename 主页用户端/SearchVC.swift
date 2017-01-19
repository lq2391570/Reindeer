//
//  SearchVC.swift
//  Reindeer
//
//  Created by shiliuhua on 17/1/17.
//  Copyright © 2017年 shiliuhua. All rights reserved.
//

import UIKit
import TagListView
class SearchVC: UIViewController,UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate {

    @IBOutlet var tableView: UITableView!
    
    var searchBar:UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationController?.navigationBar.barTintColor=UIColor.black
        //消除毛玻璃效果
        self.navigationController?.navigationBar.isTranslucent = false;
        
        createSearchbar()
        installTableView()
        searchBar.becomeFirstResponder()
    }
    
    //创建searchBar
    func createSearchbar() -> Void {
        searchBar = UISearchBar(frame: CGRect.init(x: 0, y: 0, width: 200, height: 20))
        searchBar.showsCancelButton = true
        searchBar.delegate = self
        searchBar.placeholder = "搜索职位和企业"
        self.navigationItem.titleView = searchBar
        
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar)
    {
        self.dismiss(animated: true, completion: nil)
    }
    //设置tableView
    func installTableView() -> Void {
//        tableView.delegate = self
//        tableView.dataSource = self
        tableView.register(UINib.init(nibName: "TagListCell", bundle: nil), forCellReuseIdentifier: "TagListCell")
        tableView.estimatedRowHeight = 80
        
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if section == 0 {
            return 1
        }else if section == 1 {
            return 1
        }else{
            return 2
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return UITableViewAutomaticDimension
        }else if indexPath.section == 1{
            return UITableViewAutomaticDimension
        }else{
            return 44
        }
    }
    //自定义section的title
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
       
            let titleLabel = UILabel(frame: CGRect.init(x: 0, y: 0, width: ScreenWidth, height: 40))
            titleLabel.textColor = UIColor.mainColor
            titleLabel.font = UIFont.systemFont(ofSize: 16)
        if section == 0 {
            titleLabel.text = "热门企业"
        }else if section == 1 {
            titleLabel.text = "热门职业"
        }else{
            titleLabel.text = "最近搜索"
        }
            return titleLabel
        
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 15
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TagListCell") as! TagListCell
            let tagArray = ["百度","阿里巴巴","腾讯","中软国际","美团","京东","同纳信息","软通动力"]
            for str in tagArray {
                cell.recommendView.addTag(str)
            }
            return cell
        }else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TagListCell") as! TagListCell
            let tagArray = ["百度","阿里巴巴","腾讯","中软国际","美团","京东","同纳信息","软通动力"]
            for str in tagArray {
                cell.recommendView.addTag(str)
            }
            return cell
        }else{
            var cell = tableView.dequeueReusableCell(withIdentifier: "cell3")
            if cell == nil {
                cell = UITableViewCell.init(style: .default, reuseIdentifier: "cell3")
            }
            return cell!
        }
    }
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 3
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
