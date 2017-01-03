//
//  PositionLongCell.swift
//  Reindeer
//
//  Created by shiliuhua on 16/12/30.
//  Copyright © 2016年 shiliuhua. All rights reserved.
//

import UIKit

class PositionLongCell: UITableViewCell {

    
    @IBOutlet var searchBar: UISearchBar!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
       // searchBar.barTintColor = UIColor.white
        
        self.selectionStyle = .none
            
        
        
        print("searcharray\(searchBar.subviews.first?.subviews.last?.subviews)")
        
        if searchBar.subviews.first?.subviews.last?.isKind(of: UITextField.self) == true {
            let searchTextField:UITextField = searchBar.subviews.first?.subviews.last as! UITextField
            searchTextField.layer.cornerRadius = 15
           // searchTextField.layer.backgroundColor = UIColor.white.cgColor
          //  searchTextField.backgroundColor = UIColor(hexColor: "ffffff")
          //  searchTextField.layer.opacity = 0.2
            searchTextField.textColor = UIColor.blue
            
        }
        
        
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        
    }
    
}
