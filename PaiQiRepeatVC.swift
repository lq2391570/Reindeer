//
//  PaiQiRepeatVC.swift
//  Reindeer
//
//  Created by shiliuhua on 2017/5/24.
//  Copyright © 2017年 shiliuhua. All rights reserved.
//

import UIKit

class PaiQiRepeatVC: BaseViewVC,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet var tableView: UITableView!
    var saveBtnClosure:((Int) -> ())?
    
    var nameArray = ["星期一","星期二","星期三","星期四","星期五","星期六","星期日"]
    
    var selectArray:NSMutableArray = []
    
    var returnClosure:(([Int]) ->())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "重复"
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.register(UINib.init(nibName: "PaiQiRepeatCell", bundle: nil), forCellReuseIdentifier: "PaiQiRepeatCell")
        let rightBtnItem = UIBarButtonItem.init(title: "保存", style: .plain, target: self, action: #selector(rightBtnItemClick))
        self.navigationItem.rightBarButtonItem = rightBtnItem
        // Do any additional setup after loading the view.
        
    }
    func rightBtnItemClick() -> Void {
          print("保存")
        print("self.selectArray = \(self.selectArray)")
        let newArray:[Int] = self.selectArray as! [Int]
        let paiXuArray = newArray.sorted{$0<$1}
        print("paiXuArray = \(paiXuArray)")
        if self.returnClosure != nil {
            self.returnClosure!(paiXuArray)
        }
        _ = self.navigationController?.popViewController(animated: true)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 7
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PaiQiRepeatCell") as! PaiQiRepeatCell
        cell.selectionStyle = .none
        cell.selectBtn.tag = indexPath.row + 1
        cell.nameLabel.text = nameArray[indexPath.row]
        
        cell.selectBtnClickClosure = { (btn) in
            if cell.selectBtn.isSelected == true {
                if self.selectArray.contains(cell.selectBtn.tag) == false {
                    self.selectArray.add(cell.selectBtn.tag)
                }
            }else{
                if self.selectArray.contains(cell.selectBtn.tag) == true {
                    self.selectArray.remove(cell.selectBtn.tag)
                }
            }
        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
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
