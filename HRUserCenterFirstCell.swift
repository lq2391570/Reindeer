//
//  HRUserCenterFirstCell.swift
//  Reindeer
//
//  Created by shiliuhua on 2017/5/16.
//  Copyright © 2017年 shiliuhua. All rights reserved.
//

import UIKit

class HRUserCenterFirstCell: UITableViewCell {

    @IBOutlet var renzhengLabel: UILabel!
    
    @IBOutlet var renzhengImage: UIImageView!
    
    @IBOutlet var headImageBtn: UIButton!
    
    @IBOutlet var zhunDianLvLabel: UILabel!
    
    @IBOutlet var nameAndSexLabel: UILabel!
    
    @IBOutlet var companyNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.headImageBtn.layer.cornerRadius = 30
        self.headImageBtn.layer.masksToBounds = true
        
    }

    func installCell(renzhengState:Int?,headImageStr:String?,callRate:String?,name:String?,sex:String?,company:String?) -> Void {
        if renzhengState == 0 {
            self.renzhengLabel.text = "等待认证"
            self.renzhengImage.image = UIImage.init(named: "未认证.png")
        }else if renzhengState == 1 {
            self.renzhengLabel.text = "已认证"
            self.renzhengImage.image = UIImage.init(named: "认证.png")
        }else if renzhengState == 2 {
            self.renzhengLabel.text = "认证失败"
            self.renzhengImage.image = UIImage.init(named: "未认证.png")
        }
        self.headImageBtn.sd_setBackgroundImage(with: URL.init(string: headImageStr!), for: .normal, placeholderImage: UIImage.init(named: "默认头像_女.png"))
        self.zhunDianLvLabel.text = callRate
        self.nameAndSexLabel.text = "\(name!)|\(sex!)"
        self.companyNameLabel.text = company
        
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
