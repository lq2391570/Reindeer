//
//  Position3Cell.swift
//  Reindeer
//
//  Created by shiliuhua on 16/12/27.
//  Copyright © 2016年 shiliuhua. All rights reserved.
//

import UIKit

class Position3Cell: UITableViewCell {

    
    @IBOutlet var leadingLeftContents: NSLayoutConstraint!
    
    @IBOutlet weak var trailingRightContents: NSLayoutConstraint!
    
    @IBOutlet var searchBar: UISearchBar!

    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .none
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
