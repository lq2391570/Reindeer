//
//  LQTextField.swift
//  Reindeer
//
//  Created by shiliuhua on 17/2/5.
//  Copyright © 2017年 shiliuhua. All rights reserved.
//

import UIKit

class LQTextField: UITextField {
    @IBInspectable var placeholderColor:UIColor = UIColor.clear {
        didSet {
            
            self.setValue(placeholderColor, forKeyPath: "_placeholderLabel.textColor")
           
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
