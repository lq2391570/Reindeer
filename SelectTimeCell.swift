//
//  SelectTimeCell.swift
//  Reindeer
//
//  Created by shiliuhua on 17/4/13.
//  Copyright © 2017年 shiliuhua. All rights reserved.
//

import UIKit
import JCAlertView
class SelectTimeCell: UITableViewCell {

    @IBOutlet var nameLabel: UILabel!
    
    @IBOutlet var beforeTimeBtn: UIButton!
    
    @IBOutlet var afterTimeBtn: UIButton!
    
    //before时间选择闭包
    var beforeTimeClosure:((String,Date)->())?
    //after时间选择闭包
    var afterTimeClosure:((String,Date) -> ())?
    
 
    func transitionTimeBefore(beginTimeUnixStr:String) -> Void {
        
        let nsNum:NSNumber = NSNumber(value: NSString(string: beginTimeUnixStr).floatValue)
        self.beforeTimeBtn.setTitle(unixTransformtimeStr(unixStr: nsNum, dateStyle: "YYYY.MM"), for: .normal)
        
    }
    func transitionTimeEnd(endTimeUnixStr:String) -> Void {
        let nsNum:NSNumber = NSNumber(value: NSString(string: endTimeUnixStr).floatValue)
        self.afterTimeBtn.setTitle(unixTransformtimeStr(unixStr: nsNum, dateStyle: "YYYY.MM"), for: .normal)
        
    }
    
    
    @IBAction func beforeTimeBtnClick(_ sender: UIButton) {
        let customView = LQDatePickView.newInstance()
        
        let alertView = JCAlertView(customView: customView, dismissWhenTouchedBackground: true)
        alertView?.center = CGPoint.init(x: ScreenWidth/2, y: ScreenHeight - (customView?.frame.size.height)!/2-20)
        customView?.cancelbtnClickClosure = { (btn) in
            alertView?.dismiss(completion: nil)
        }
        customView?.sureBtnClickclosure = { (btn) in
            alertView?.dismiss(completion: { 
                print("点击确定")
                let dateFormort = DateFormatter.init()
                dateFormort.dateFormat = "YYYY.MM"
                let dateStr = dateFormort.string(from: (customView?.datePicker.date)!)
                self.beforeTimeBtn.setTitle(dateStr, for: .normal)
                if self.beforeTimeClosure != nil {
                   self.beforeTimeClosure!(dateStr,(customView?.datePicker.date)!)
                }
            })
            
        }
        customView?.datePickChangeClosure = { (datePicker) in
            print("datePicker = \(datePicker)")
        }
        
        alertView?.show()
        
        
    }
    @IBAction func afterTimeBtnClick(_ sender: UIButton) {
        
        let customView = LQDatePickView.newInstance()
        
        let alertView = JCAlertView(customView: customView, dismissWhenTouchedBackground: true)
        alertView?.center = CGPoint.init(x: ScreenWidth/2, y: ScreenHeight - (customView?.frame.size.height)!/2-20)
        customView?.cancelbtnClickClosure = { (btn) in
            alertView?.dismiss(completion: nil)
            
        }
        customView?.sureBtnClickclosure = { (btn) in
            
            alertView?.dismiss(completion: {
                print("点击确定")
                let dateFormort = DateFormatter.init()
                dateFormort.dateFormat = "YYYY.MM"
                let dateStr = dateFormort.string(from: (customView?.datePicker.date)!)
                self.afterTimeBtn.setTitle(dateStr, for: .normal)
                if self.afterTimeClosure != nil {
                    self.afterTimeClosure!(dateStr,(customView?.datePicker.date)!)
                }
                
            })
            
        }
        customView?.datePickChangeClosure = { (datePicker) in
            print("datePicker = \(datePicker)")
        }
        
        alertView?.show()
        
    }
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
