//
//  CustomerInterviewView.swift
//  Reindeer
//
//  Created by shiliuhua on 17/1/16.
//  Copyright © 2017年 shiliuhua. All rights reserved.
//

import UIKit

class CustomerInterviewView: UIView,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet var tableView: UITableView!
    
    @IBOutlet var cancelBtn: UIButton!
    
    @IBOutlet var sendBtn: UIButton!

    var leftNameArray = ["个人简历","求职意向","联系方式"]
    var rightNameArray = ["王小明|男|本科","研发部经理","187-8989-8989"]
    
//     Only override draw() if you perform custom drawing.
//     An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
       
        tableView.delegate=self
        tableView.dataSource=self
        tableView.register(UINib.init(nibName: "CustomerPopCell", bundle: nil), forCellReuseIdentifier: "CustomerPopCell")
        tableView.reloadData()
    }
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        
    }
    static func newInstance() ->CustomerInterviewView?{
        let view = Bundle.main.loadNibNamed("CustomerInterviewView", owner: self, options: nil)?.last as!CustomerInterviewView
        
        return view
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 3
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomerPopCell") as! CustomerPopCell
        cell.leftLabel.text = leftNameArray[indexPath.row]
        cell.rightLabel.text = rightNameArray[indexPath.row]
        return cell
    }
    
    
}
