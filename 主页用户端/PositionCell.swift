//
//  PositionCell.swift
//  Reindeer
//
//  Created by shiliuhua on 16/12/27.
//  Copyright © 2016年 shiliuhua. All rights reserved.
//

import UIKit

class PositionCell: UITableViewCell {

    @IBOutlet var jobNameLabel: UILabel!
    
    @IBOutlet var companyNameLabel: UILabel!
    
    @IBOutlet var payRangeLabel: UILabel!
    
    @IBOutlet var areaLabel: UILabel!
    
    @IBOutlet var yearRangeLabel: UILabel!
    
    @IBOutlet var eduLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .none
    }
    //设置列表信息
    func installPositionCell(jobName:String?,companyName:String?,payRange:String?,area:String?,yearRange:String?,edu:String?) -> Void {
        self.jobNameLabel.text = jobName ?? ""
        self.companyNameLabel.text = companyName ?? ""
        self.payRangeLabel.text = payRange ?? ""
        self.areaLabel.text = area ?? ""
        self.yearRangeLabel.text = yearRange ?? ""
        self.eduLabel.text = edu ?? ""
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
