//
//  ProductLogoCell.swift
//  Reindeer
//
//  Created by shiliuhua on 17/2/20.
//  Copyright © 2017年 shiliuhua. All rights reserved.
//

import UIKit

class ProductLogoCell: UITableViewCell {

    @IBOutlet var logoBtn: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        logoBtn.layer.cornerRadius = 25
        logoBtn.layer.masksToBounds = true
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
