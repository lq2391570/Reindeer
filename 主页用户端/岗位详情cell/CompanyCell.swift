//
//  CompanyCell.swift
//  Reindeer
//
//  Created by shiliuhua on 17/1/9.
//  Copyright © 2017年 shiliuhua. All rights reserved.
//

import UIKit

class CompanyCell: UITableViewCell {

    @IBOutlet var publishJobNumLabel: UILabel!
    
    @IBOutlet var companyImageView: UIImageView!
    
    @IBOutlet var companyNameLabel: UILabel!
    
    @IBOutlet var companyMesLabel: UILabel!
    
    @IBOutlet var companyAreaLabel: UILabel!
    
    @IBOutlet var jiantouImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        overturnReturnImage(view: jiantouImageView, degress: 180)
    }
    func installCell(publishJobNum:String,companyName:String,companyMes:String,companyArea:String) -> Void {
        self.publishJobNumLabel.text = "共发布了\(publishJobNum)个职位"
        self.companyNameLabel.text = companyName
        self.companyMesLabel.text = companyMes
        self.companyAreaLabel.text = companyArea
        
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
