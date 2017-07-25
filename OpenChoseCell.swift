//
//  OpenChoseCell.swift
//  Reindeer
//
//  Created by shiliuhua on 17/2/9.
//  Copyright © 2017年 shiliuhua. All rights reserved.
//

import UIKit

class OpenChoseCell: UITableViewCell {

    @IBOutlet var nameLabel: UILabel!
    
    @IBOutlet var switchBtn: UIButton!
    
    @IBOutlet var switchImage: UIImageView!
    
    var switchBtnClickColsure :((UIButton) -> ())?
    
    @IBOutlet var bgView: UIView!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.selectionStyle = .none
     //   switchBtn.isSelected = true
        
    }

    @IBAction func switchBtnClick(_ sender: UIButton) {
        
        if switchBtn.isSelected == true {
            switchImage.image = UIImage(named: "关")
            switchBtn.isSelected = false
        }else{
            switchImage.image = UIImage(named: "开")
            switchBtn.isSelected = true
        }
        if switchBtnClickColsure != nil {
            switchBtnClickColsure!(sender)
        }
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if switchBtn.isSelected == true {
            switchImage.image = UIImage(named: "开")
        }else{
            switchImage.image = UIImage(named: "关")
        }
        // Configure the view for the selected state
    }
    
}
