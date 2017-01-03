//
//  ArrowsView.swift
//  Reindeer
//
//  Created by shiliuhua on 16/12/29.
//  Copyright © 2016年 shiliuhua. All rights reserved.
//

import UIKit

class ArrowsView: UIView {

    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    
    
    override func draw(_ rect: CGRect) {
        // Drawing code
        self.backgroundColor = UIColor.clear
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 5, y: 7.5))
        path.addLine(to: CGPoint(x: 15, y: 7.5))
        path.addLine(to: CGPoint(x: 10, y: 12.5))
        path.close()
        path.lineWidth = 2
        path.stroke()
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.fillColor = UIColor(hexColor: "f4cda2").cgColor
        shapeLayer.strokeColor = UIColor.clear.cgColor
        self.layer.addSublayer(shapeLayer)
        
    }
    
}
