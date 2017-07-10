//
//  StationDescripeCell.swift
//  Reindeer
//
//  Created by shiliuhua on 17/1/9.
//  Copyright © 2017年 shiliuhua. All rights reserved.
//

import UIKit

class StationDescripeCell: UITableViewCell {

    @IBOutlet var jiantouImageView: UIImageView!
    @IBOutlet var contentLabel: UILabel!
    
    var jiantouClickclosure:((_ btn:UIButton) ->())?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
      
    overturnReturnImage(view: jiantouImageView, degress: 270)
        
    contentLabel.numberOfLines = 1
    }

    @IBAction func jiantouClick(_ sender: UIButton) {
        
        if sender.isSelected == true {
            sender.isSelected = false
            contentLabel.numberOfLines = 1
        }else {
            sender.isSelected = true
            contentLabel.numberOfLines = 0
        }
        
        jiantouClickclosure!(sender)
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
