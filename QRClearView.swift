//
//  QRClearView.swift
//  Reindeer
//
//  Created by shiliuhua on 16/12/22.
//  Copyright © 2016年 shiliuhua. All rights reserved.
//

import UIKit

class QRClearView: UIView {

    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    var smlRect:CGRect?
    
    override func draw(_ rect: CGRect) {
        // Drawing code
        smlRect = smlRect ?? CGRect.init(x: 0, y: 0, width: 0, height: 0)
        
        clipArea(smlframe: smlRect!)
    }
    
    //画一个区域i
    func clipArea(smlframe:CGRect) -> Void {
        //获取画布
        let context = UIGraphicsGetCurrentContext()
        
        context?.setFillColor(UIColor.black.cgColor)
        
        context?.fill(frame)
        
        context?.clear(smlframe)
        
    }
    

}
