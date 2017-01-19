//
//  TagListCell.swift
//  Reindeer
//
//  Created by shiliuhua on 17/1/18.
//  Copyright © 2017年 shiliuhua. All rights reserved.
//

import UIKit
import TagListView
class TagListCell: UITableViewCell {

    @IBOutlet var recommendView: TagListView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        recommendView.borderColor = UIColor.init(red: 233/255.0, green: 228/255.0, blue: 222/255.0, alpha: 1)
        recommendView.tagBackgroundColor = UIColor.white
        recommendView.textFont = UIFont.systemFont(ofSize: 16)
        recommendView.borderWidth = 1
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
