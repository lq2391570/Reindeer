//
//  PaiQiDetailHeadView.swift
//  Reindeer
//
//  Created by shiliuhua on 2017/5/25.
//  Copyright © 2017年 shiliuhua. All rights reserved.
//

import UIKit

class PaiQiDetailHeadView: UIView {

    
    @IBOutlet var timeLabel: UILabel!
    
    @IBOutlet var timeLongLabel: UILabel!
    
    @IBOutlet var numOfPeopleLabel: UILabel!
    static func newInstance() -> PaiQiDetailHeadView?{
        let view = Bundle.main.loadNibNamed("PaiQiDetailHeadView", owner: self, options: nil)?.last as! PaiQiDetailHeadView
        return view
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
