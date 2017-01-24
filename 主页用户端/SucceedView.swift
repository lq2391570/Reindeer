//
//  SucceedView.swift
//  Reindeer
//
//  Created by shiliuhua on 17/1/20.
//  Copyright © 2017年 shiliuhua. All rights reserved.
//

import UIKit

class SucceedView: UIView {

    var cancelBtnClickClsure:((_ sender:UIButton) -> ())?
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

    @IBAction func cancelBtnClick(_ sender: UIButton) {
        cancelBtnClickClsure!(sender)
        
    }
}
