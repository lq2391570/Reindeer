//
//  SwitchCell.swift
//  Reindeer
//
//  Created by shiliuhua on 17/1/19.
//  Copyright © 2017年 shiliuhua. All rights reserved.
//

import UIKit

class SwitchCell: UITableViewCell {

    @IBOutlet var switchBtn: UIButton!
    var switchbtnClickClosure:((UIButton)->())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        switchBtn.addTarget(self, action: #selector(switchBtnClick(_:)), for: .touchUpInside)
    }
    func switchBtnClick(_ btn:UIButton) -> Void {
        if switchbtnClickClosure != nil {
            switchbtnClickClosure!(btn)
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
