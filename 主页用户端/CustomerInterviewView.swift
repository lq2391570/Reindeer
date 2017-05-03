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

    var name = ""
    var sex = ""
    var eduExp = ""
    var jobName = ""
    var phoneNum = ""
    
    
    var leftNameArray = ["个人简历","求职意向","联系方式"]
    var rightNameArray = ["王小明|男|本科","研发部经理","187-8989-8989"]
    var isOpenEmail = true
    
    var cancelBtnClickClosure:((_ sender:UIButton) ->())?
    var sureBtnClickClosure:((_ sender:UIButton) -> ())?
    
//     Only override draw() if you perform custom drawing.
//     An empty implementation adversely affects performance during animation.
    
    
    
    override func draw(_ rect: CGRect) {
       
        tableView.delegate=self
        tableView.dataSource=self
        tableView.register(UINib.init(nibName: "CustomerPopCell", bundle: nil), forCellReuseIdentifier: "CustomerPopCell")
        tableView.register(UINib.init(nibName: "SwitchCell", bundle: nil), forCellReuseIdentifier: "SwitchCell")
        rightNameArray = ["\(name)|\(sex)|\(eduExp)","\(jobName)","\(phoneNum)"]
        
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
        return 4
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if indexPath.row == 3 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SwitchCell") as! SwitchCell
            cell.switchbtnClickClosure = { (btn) in
                if btn.isSelected == true {
                    btn.isSelected = false
                }else{
                    btn.isSelected = true
                }
                self.isOpenEmail = !btn.isSelected
                print("self.isOpenEmail = \(self.isOpenEmail)")
                    btn.setImage(UIImage.init(named: "开"), for: .normal)
                    btn.setImage(UIImage.init(named: "关"), for: .selected)
            }
            
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "CustomerPopCell") as! CustomerPopCell
            cell.leftLabel.text = leftNameArray[indexPath.row]
            cell.rightLabel.text = rightNameArray[indexPath.row]
            return cell

        }
        
    }
    @IBAction func cancelBtnClick(_ sender: UIButton) {
        
        print("cancelBtnClick")
        cancelBtnClickClosure!(sender)
        
    }
    
    @IBAction func sureBtnClick(_ sender: UIButton) {
        print("sureBtnClick")
        sureBtnClickClosure!(sender)
        
    }
    
    
    
}
