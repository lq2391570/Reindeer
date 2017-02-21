//
//  CompanyProductCell.swift
//  Reindeer
//
//  Created by shiliuhua on 17/2/20.
//  Copyright © 2017年 shiliuhua. All rights reserved.
//

import UIKit

class CompanyProductCell: UITableViewCell {

    
    @IBOutlet var headImage: UIButton!
    
    @IBOutlet var titleLabel: UILabel!
    
    @IBOutlet var introLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        headImage.layer.cornerRadius = 20
        headImage.layer.masksToBounds = true
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
