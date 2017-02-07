//
//  LQView.swift
//  Reindeer
//
//  Created by shiliuhua on 17/2/5.
//  Copyright © 2017年 shiliuhua. All rights reserved.
//

import UIKit

class LQView: UIView {
    @IBInspectable var borderWidth:CGFloat = 0 {
        didSet{
            self.layer.borderWidth = borderWidth
        }
    }
    @IBInspectable var boreLineColor:UIColor = UIColor.clear {
        didSet{
            self.layer.borderColor = boreLineColor.cgColor
        }
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
