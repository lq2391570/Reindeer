//
//  LQFlexibleBar.swift
//  Reindeer
//
//  Created by shiliuhua on 17/1/24.
//  Copyright © 2017年 shiliuhua. All rights reserved.
//

import UIKit
import BLKFlexibleHeightBar
class LQFlexibleBar: BLKFlexibleHeightBar {

    /*
     Only override draw() if you perform custom drawing.
     An empty implementation adversely affects performance during animation.
       */
    
    
    
    override func draw(_ rect: CGRect) {
       //  self.configureBar()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureBar()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
     //   fatalError("init(coder:) has not been implemented")
      //  super.init(coder: aDecoder)
    //    let bundle = Bundle.main.loadNibNamed("", owner: <#T##Any?#>, options: <#T##[AnyHashable : Any]?#>)
        super.init(coder: aDecoder)
     //  self.configureBar()
    }
    
    func configureBar() -> Void {
        self.backgroundColor = UIColor.black
        self.minimumBarHeight = 65.0
        self.maximumBarHeight = 200.0
        let bigImageView = UIImageView()
        bigImageView.image = UIImage.init(named: "user_home_bj.png")
        bigImageView.backgroundColor = UIColor.green
        let initialBigImageView = BLKFlexibleHeightBarSubviewLayoutAttributes()
        initialBigImageView.size = bigImageView.sizeThatFits(CGSize.zero)
       // initialBigImageView.center = CGPoint.init(x: self.frame.size.width * 0.5, y: self.minimumBarHeight - 25)
        initialBigImageView.frame = CGRect.init(x: 0, y: 0, width: self.frame.size.width, height: 200)
        initialBigImageView.alpha = 1
        bigImageView.add(initialBigImageView, forProgress: 0.0)
        
        let midwayBigImageView = BLKFlexibleHeightBarSubviewLayoutAttributes(existing: initialBigImageView)
      //  midwayBigImageView?.center = CGPoint.init(x: self.frame.size.width*0.5, y: (self.maximumBarHeight-self.minimumBarHeight)*0.4+self.minimumBarHeight-60.0)
        
        midwayBigImageView?.frame = CGRect.init(x: 0, y: 0, width: self.frame.size.width, height: 200)
        midwayBigImageView?.alpha = 1
        bigImageView.add(midwayBigImageView, forProgress: 0.6)
        
        let finalBigImageView = BLKFlexibleHeightBarSubviewLayoutAttributes(existing: midwayBigImageView)
        finalBigImageView?.alpha = 1
        finalBigImageView?.center = CGPoint.init(x: self.frame.size.width * 0.5, y: self.minimumBarHeight-25.0)
        bigImageView.add(finalBigImageView, forProgress: 1)
        self.addSubview(bigImageView)
    }
    //圆形头像
    func headImageView() -> Void {
        
        
        
    }
    
    
    
    
    
    
}




