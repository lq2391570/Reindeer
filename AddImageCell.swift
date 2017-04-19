//
//  AddImageCell.swift
//  Reindeer
//
//  Created by shiliuhua on 17/2/10.
//  Copyright © 2017年 shiliuhua. All rights reserved.
//

import UIKit

class AddImageCell: UITableViewCell {

    @IBOutlet var nameLabel: UILabel!
    
    @IBOutlet var bgView: UIView!
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
