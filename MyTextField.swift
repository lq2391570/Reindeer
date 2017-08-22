//
//  MyTextField.swift
//  Reindeer
//
//  Created by shiliuhua on 2017/8/21.
//  Copyright © 2017年 shiliuhua. All rights reserved.
//

import UIKit

class MyTextField: UITextField {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    //控制placeHolder的位置
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        let inset = CGRect.init(x: bounds.origin.x + 20, y: bounds.origin.y, width: bounds.size.width, height: bounds.size.height)
        return inset

    }
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        let inset = CGRect.init(x: bounds.origin.x + 20, y: bounds.origin.y, width: bounds.size.width, height: bounds.size.height)
        return inset
    }
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        let inset = CGRect.init(x: bounds.origin.x + 20, y: bounds.origin.y, width: bounds.size.width, height: bounds.size.height)
        return inset
    }

}
