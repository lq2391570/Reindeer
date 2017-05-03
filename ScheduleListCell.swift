//
//  ScheduleListCell.swift
//  Reindeer
//
//  Created by shiliuhua on 2017/4/27.
//  Copyright © 2017年 shiliuhua. All rights reserved.
//

import UIKit

class ScheduleListCell: UITableViewCell {

    
    @IBOutlet var timeLabel: UILabel!
    
    @IBOutlet var numOfPeopleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
