//
//  CustomerInterviewView.swift
//  Reindeer
//
//  Created by shiliuhua on 17/1/16.
//  Copyright © 2017年 shiliuhua. All rights reserved.
//

import UIKit

class CustomerInterviewView: UIView,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate {

    @IBOutlet var tableView: UITableView!
    
    @IBOutlet var cancelBtn: UIButton!
    
    @IBOutlet var sendBtn: UIButton!
    @IBOutlet var titlelabel: UILabel!

    enum interViewType {
        case interViewApply //普通面试申请
        case interViewInvite //普通面试邀约
    }
    //面试地点
    var interfaceArea = ""
    
    
    
    var viewTypeStyle:interViewType = .interViewApply
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
    
    //textField改变时的回调
    var textFieldChangeClosure:((_ textField:UITextField) -> ())?
    //pickView滚动时传递的时间回调
    var pickViewDelegateClosure:((_ choseTimeStr:String) -> ())?
    
    //面试时间
    var timeStr = ""
    
    
//     Only override draw() if you perform custom drawing.
//     An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
       
        tableView.delegate=self
        tableView.dataSource=self
        tableView.register(UINib.init(nibName: "CustomerPopCell", bundle: nil), forCellReuseIdentifier: "CustomerPopCell")
        tableView.register(UINib.init(nibName: "SwitchCell", bundle: nil), forCellReuseIdentifier: "SwitchCell")
        rightNameArray = ["\(name)|\(sex)|\(eduExp)","\(jobName)","\(phoneNum)"]
        if viewTypeStyle == .interViewInvite {
            self.titlelabel.text = "普通邀约"
            
            tableView.register(UINib.init(nibName: "InterViewTimeChoseCell", bundle: nil), forCellReuseIdentifier: "InterViewTimeChoseCell")
            tableView.register(UINib.init(nibName: "ContactWayCell", bundle: nil), forCellReuseIdentifier: "ContactWayCell")
            tableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: "cell")
            tableView.tableFooterView = UIView()
        }
        
        
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
        if viewTypeStyle == .interViewInvite {
            return 3
        }
        
        return 4
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if viewTypeStyle == .interViewInvite {
            if indexPath.row == 0 {
                return 70
            }else if indexPath.row == 1 {
                return 50
            }else{
                return 44
            }
        }
        return 44
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if viewTypeStyle == .interViewInvite {
            //普通邀约
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "InterViewTimeChoseCell") as! InterViewTimeChoseCell
                
                cell.selectionStyle = .none
                self.timeStr = cell.timeStr
                cell.pickViewDelegateClosure = { (choseTime) in
                    if self.pickViewDelegateClosure != nil {
                        self.pickViewDelegateClosure!(choseTime)
                    }
                    self.timeStr = choseTime
                }
               
                return cell
            }else if indexPath.row == 1 {
                var cell = tableView.dequeueReusableCell(withIdentifier: "cell")
                cell = UITableViewCell.init(style: .value1, reuseIdentifier: "cell")
                cell?.detailTextLabel?.numberOfLines = 0
                cell?.textLabel?.font = UIFont.systemFont(ofSize: 12)
                cell?.detailTextLabel?.font = UIFont.systemFont(ofSize: 13)
                cell?.textLabel?.text = "面试地点"
                cell?.selectionStyle = .none
                cell?.detailTextLabel?.text = self.interfaceArea
                return cell!
                
            }else{
                let cell = tableView.dequeueReusableCell(withIdentifier: "ContactWayCell") as! ContactWayCell
                cell.selectionStyle = .none
                cell.textField.text = self.phoneNum
                cell.textField.delegate = self
                
                return cell
                
            }
            
        }else{
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
        
        
        
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        print("textField.text = \(textField.text)")
        if self.textFieldChangeClosure != nil {
            self.textFieldChangeClosure!(textField)
        }
        
        return true
        
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
