//
//  SelectorCell.swift
//  Reindeer
//
//  Created by shiliuhua on 17/1/5.
//  Copyright © 2017年 shiliuhua. All rights reserved.
//

import UIKit

class SelectorCell: UITableViewCell {

    @IBOutlet var selectorLabel: SelectorLabel!
    
    @IBOutlet var cellBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
