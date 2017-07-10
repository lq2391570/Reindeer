//
//  StationFirstCellNew.swift
//  Reindeer
//
//  Created by shiliuhua on 2017/7/4.
//  Copyright © 2017年 shiliuhua. All rights reserved.
//

import UIKit
import TagListView
class StationFirstCellNew: UITableViewCell {

    @IBOutlet var jobNameLabel: UILabel!
    
    @IBOutlet var companyNameLabel: UILabel!
    
    @IBOutlet var moneyLabel: UILabel!
    
    @IBOutlet var areaLabel: UILabel!
    
    @IBOutlet var yearLabel: UILabel!
    
    @IBOutlet var eduLabel: UILabel!
    
    @IBOutlet var tagListView: TagListView!
    
    @IBOutlet var headImageView: UIImageView!
    
    @IBOutlet var HRNameLabel: UILabel!
    
    @IBOutlet var starView: UIView!
    
    @IBOutlet var star1: UIImageView!
    
    @IBOutlet var star2: UIImageView!
    
    @IBOutlet var star3: UIImageView!
    
    @IBOutlet var star4: UIImageView!
    
    @IBOutlet var star5: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        tagListView.alignment = .center
        ViewBorderRadius(view: self.headImageView, radius: 20, width: nil, color: nil)
       
    }
    func installCell(jobName:String?,companyName:String?,money:String?,area:String?,year:String?,edu:String?,headImageName:String?,HRName:String?,HRJobName:String?,starNum:Int) -> Void {
        self.jobNameLabel.text = jobName
        self.companyNameLabel.text = companyName
        self.moneyLabel.text = money
        self.areaLabel.text = area
        self.yearLabel.text = year
        self.eduLabel.text = edu
        self.areaLabel.adjustsFontSizeToFitWidth = true
        self.yearLabel.adjustsFontSizeToFitWidth = true
        self.eduLabel.adjustsFontSizeToFitWidth = true
        self.headImageView.sd_setImage(with: URL.init(string: headImageName ?? ""), placeholderImage: UIImage.init(named: "默认头像_男.png"))
        self.HRNameLabel.text = "\(HRName ?? "无")|\(HRJobName ?? "无")"
        if starNum == 1 {
            star1.image = UIImage.init(named: "star2.png")
        }else if starNum == 2 {
            star1.image = UIImage.init(named: "star2.png")
            star2.image = UIImage.init(named: "star2.png")
        }else if starNum == 3 {
            star1.image = UIImage.init(named: "star2.png")
            star2.image = UIImage.init(named: "star2.png")
            star3.image = UIImage.init(named: "star2.png")
        }else if starNum == 4 {
            star1.image = UIImage.init(named: "star2.png")
            star2.image = UIImage.init(named: "star2.png")
            star3.image = UIImage.init(named: "star2.png")
            star4.image = UIImage.init(named: "star2.png")
        }else if starNum == 5 {
            star1.image = UIImage.init(named: "star2.png")
            star2.image = UIImage.init(named: "star2.png")
            star3.image = UIImage.init(named: "star2.png")
            star4.image = UIImage.init(named: "star2.png")
            star5.image = UIImage.init(named: "star2.png")
        }
        
    }
    
    
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
