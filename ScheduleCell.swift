//
//  ScheduleCell.swift
//  Reindeer
//
//  Created by shiliuhua on 2017/4/26.
//  Copyright © 2017年 shiliuhua. All rights reserved.
//

import UIKit

class ScheduleCell: UITableViewCell,UITableViewDelegate,UITableViewDataSource {

    var scheduleCount = 0
    
    var listArray:[JobDetailInterviewTimes] = []
    
    @IBOutlet var interViewListTableView: UITableView!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        interViewListTableView.delegate = self
        interViewListTableView.dataSource = self
        interViewListTableView.register(UINib.init(nibName: "ScheduleListCell", bundle: nil), forCellReuseIdentifier: "ScheduleListCell")
        interViewListTableView.rowHeight = 25
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return (listArray.count)
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ScheduleListCell")as! ScheduleListCell
        let model:JobDetailInterviewTimes = listArray[indexPath.row]
        
        cell.timeLabel.text = "\(model.date!) \(model.time!)"
        cell.numOfPeopleLabel.text = "\(model.num!)/\(model.nums!)"
        
        return cell
        
        
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
