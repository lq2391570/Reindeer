//
//  SelectorLabel.swift
//  Reindeer
//
//  Created by shiliuhua on 17/1/5.
//  Copyright © 2017年 shiliuhua. All rights reserved.
//

import UIKit
///右边为对号的label✔️
class SelectorLabel: UILabel {
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    var selectText:UILabel!
    var selectView:UIView!
    var bezierPath:UIBezierPath!
    var shapeLayer:CAShapeLayer!
    var selectstring:String?
    var isselect = false
    
    override func draw(_ rect: CGRect) {
        // Drawing code
        drawLabelAndCheck()
    }
    //绘制label和对号
    func drawLabelAndCheck() -> Void {
        
        if selectText == nil {
            selectText = UILabel()
            if isselect == true {
                selectText.textColor = UIColor.mainColor
            }else{
                selectText.textColor = UIColor.black
            }
            selectText.font = self.font
            selectText.text = selectstring
            selectText.textAlignment = .right
            self.addSubview(selectText)
        }
        if selectView == nil {
            selectView = UIView()
            selectView.backgroundColor = UIColor.clear
            self.addSubview(selectView)
            check()
        }
        selectText.snp.makeConstraints { (make) in
            make.left.equalTo(self.snp.left).offset(0)
            make.top.equalTo(self.snp.top).offset(0)
            make.bottom.equalTo(self.snp.bottom).offset(0)
            make.right.equalTo(self.snp.right).offset(-50)
        }
        selectView.snp.makeConstraints { (make) in
            make.left.equalTo(selectText.snp.right).offset(0)
            make.right.equalTo(self.snp.right).offset(0)
            make.top.equalTo(self.snp.top).offset(0)
            make.bottom.equalTo(self.snp.bottom).offset(0)
        }

    }
    //对号
    func check() -> Void {
     
            bezierPath = UIBezierPath()
            bezierPath.move(to: CGPoint(x: 8.5, y: 16.5))
            bezierPath.addLine(to: CGPoint(x: 13.5, y: 21.5))
            bezierPath.addLine(to: CGPoint(x: 20.5, y: 12.5))
       //     UIColor.mainColor.setStroke()
            bezierPath.lineWidth = 0
            bezierPath.stroke()
        shapeLayer = CAShapeLayer()
        shapeLayer.path = bezierPath.cgPath
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineWidth = 2
        selectView.layer.addSublayer(shapeLayer)
        if isselect == false {
             shapeLayer.strokeColor = UIColor.clear.cgColor
        }else{
             shapeLayer.strokeColor = UIColor.mainColor.cgColor
        }
        
    }

}
