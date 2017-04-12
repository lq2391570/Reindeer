//
//  DefaultSelectCell.swift
//  Reindeer
//
//  Created by shiliuhua on 17/2/10.
//  Copyright © 2017年 shiliuhua. All rights reserved.
//

import UIKit

class DefaultSelectCell: UITableViewCell {

    @IBOutlet var topLineLabel: UILabel!
    
    @IBOutlet var bottomLineLabel: UILabel!
    
    @IBOutlet var rightLabel: UILabel!
    
    @IBOutlet var nameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.selectionStyle = .none
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
