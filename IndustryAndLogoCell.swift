//
//  IndustryAndLogoCell.swift
//  Reindeer
//
//  Created by shiliuhua on 17/2/10.
//  Copyright © 2017年 shiliuhua. All rights reserved.
//

import UIKit

class IndustryAndLogoCell: UITableViewCell {

    @IBOutlet var logoBtn: UIButton!
    
    @IBOutlet var leftLabel: UILabel!
    
    @IBOutlet var rightLabel: UILabel!
    
    @IBOutlet var lineLabel: UILabel!
    
    @IBOutlet var nameLabel: UILabel!
    //logo点击回调
    var logoBtnClickclosure:((UIButton) -> ())?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        logoBtn.layer.cornerRadius = 35
        logoBtn.layer.masksToBounds = true
        logoBtn.addTarget(self, action: #selector(logoBtnClick(sender:)), for: .touchUpInside)
        self.selectionStyle = .none
        self.backgroundColor = UIColor.init(red: 246/255.0, green: 246/255.0, blue: 246/255.0, alpha: 1)
        
    }
    //logo点击
    func logoBtnClick(sender:UIButton) -> Void {
        if (logoBtnClickclosure != nil) {
            logoBtnClickclosure!(sender)
        }
        
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
