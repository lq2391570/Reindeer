//
//  ResumeDetailCell1.swift
//  Reindeer
//
//  Created by shiliuhua on 2017/5/9.
//  Copyright © 2017年 shiliuhua. All rights reserved.
//

import UIKit

class ResumeDetailCell1: UITableViewCell {

    @IBOutlet var headImageView: UIImageView!
    
    @IBOutlet var nameAndJobLabel: UILabel!
    
    @IBOutlet var moneyLabel: UILabel!
    
    @IBOutlet var areaLabel: UILabel!
    
    @IBOutlet var expYearLabel: UILabel!
    
    @IBOutlet var eduLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func installCell(headImageStr:String?,nameAndJobStr:String?,moneyStr:String?,areaStr:String?,expYearStr:String?,eduStr:String?) -> Void {
        
        
        self.headImageView.sd_setImage(with: URL.init(string: headImageStr ?? ""), placeholderImage: UIImage.init(named: "hua"))
        self.nameAndJobLabel.text = nameAndJobStr
        self.moneyLabel.text = moneyStr
        self.areaLabel.text = areaStr ?? "不限"
        self.expYearLabel.text = expYearStr ?? "不限"
        self.eduLabel.text = eduStr ?? "不限"
        
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
