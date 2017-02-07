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
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
          // Drawing code
    }
    */
    override init(frame: CGRect) {
        super.init(frame: frame)
         self.configureBar()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
      //  super.init(coder: aDecoder)
    //    let bundle = Bundle.main.loadNibNamed("", owner: <#T##Any?#>, options: <#T##[AnyHashable : Any]?#>)
        
    }
    func configureBar() -> Void {
        self.minimumBarHeight = 65.0
        self.maximumBarHeight = 200.0
        let bigImageView = UIImageView()
        bigImageView.image = UIImage.init(named: "hua")
        
        let initialBigImageView = BLKFlexibleHeightBarSubviewLayoutAttributes()
        initialBigImageView.size = bigImageView.sizeThatFits(CGSize.zero)
        initialBigImageView.center = CGPoint.init(x: self.frame.size.width * 0.5, y: self.minimumBarHeight - 25)
        initialBigImageView.alpha = 0
        bigImageView.add(initialBigImageView, forProgress: 0.0)
        
        let midwayBigImageView = BLKFlexibleHeightBarSubviewLayoutAttributes(existing: initialBigImageView)
        midwayBigImageView?.center = CGPoint.init(x: self.frame.size.width*0.5, y: (self.maximumBarHeight-self.minimumBarHeight)*0.4+self.minimumBarHeight-60.0)
        midwayBigImageView?.alpha = 0
        bigImageView.add(midwayBigImageView, forProgress: 0.6)
        
        let finalBigImageView = BLKFlexibleHeightBarSubviewLayoutAttributes(existing: midwayBigImageView)
        finalBigImageView?.alpha = 1
        bigImageView.add(finalBigImageView, forProgress: 1)
        self.addSubview(bigImageView)
        
    }
}
    


