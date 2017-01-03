//
//  DropDownView.swift
//  Reindeer
//
//  Created by shiliuhua on 16/12/30.
//  Copyright © 2016年 shiliuhua. All rights reserved.
//

import UIKit

class DropDownView: UIView {

    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    var supViewController:UIViewController?
    
    
    
    
    override func draw(_ rect: CGRect) {
        // Drawing code
       
        addChoseBtn(rect)
    }
//添加按钮
    func addChoseBtn(_ rect:CGRect) -> Void {
        for index in 1...4 {
            
            let btn = UIButton(type: .custom)
            btn.frame = CGRect.init(x: rect.size.width.hashValue/(5-index), y: 0, width: rect.size.width.hashValue/4, height: 40)
            btn.backgroundColor = UIColor.green
            btn.tag = index
            btn.addTarget(supViewController, action: #selector(btnClick(btn:)), for: .touchUpInside)
            self.addSubview(btn)
            
        }

    }
    func btnClick(btn:UIButton) -> Void {
        print("点击了第\(btn.tag)个按钮")
    }
}
