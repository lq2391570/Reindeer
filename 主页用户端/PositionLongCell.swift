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
    
    var searchBtnClickClosure:((_ sender:UIButton) -> ())?
    
    var videoInterFaceListClosure:((_ sender:UIButton) -> ())?
    var commonInterFaceListClosure:((_ sender:UIButton) -> ())?
    var notiListClosure:((_ sender:UIButton) -> ())?
    

    @IBOutlet var redNotiImageView: UIImageView!
    
    @IBOutlet var numOfVideoInterView: UILabel!
    
    @IBOutlet var numOfCommonInterView: UILabel!
    
    
    
  //   var viewHeight:((CGFloat) -> ())?
    @IBOutlet var searchView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
       // searchBar.barTintColor = UIColor.white
        
        self.selectionStyle = .none
        
        print("searcharray\(searchBar.subviews.first?.subviews.last?.subviews)")
        
        self.redNotiImageView.backgroundColor = UIColor.red
        
        self.redNotiImageView.layer.cornerRadius = 4
        self.redNotiImageView.layer.masksToBounds = true
        
        if searchBar.subviews.first?.subviews.last?.isKind(of: UITextField.self) == true {
            let searchTextField:UITextField = searchBar.subviews.first?.subviews.last as! UITextField
            searchTextField.layer.cornerRadius = 15
           // searchTextField.layer.backgroundColor = UIColor.white.cgColor
          //  searchTextField.backgroundColor = UIColor(hexColor: "ffffff")
          //  searchTextField.layer.opacity = 0.2
            searchTextField.textColor = UIColor.blue
            
        }
        
        
        
        
    }
        @IBAction func searchBtnClick(_ sender: UIButton) {
        
           print("点击搜索按钮")
      
            searchBtnClickClosure!(sender)
     
    }
    
    @IBAction func videoInterFaceBtnClick(_ sender: UIButton) {
        
        if videoInterFaceListClosure != nil {
            videoInterFaceListClosure!(sender)
        }

    }
    
    @IBAction func commonInterViewBtnClick(_ sender: UIButton) {
        print("点击")
        if commonInterFaceListClosure != nil {
            commonInterFaceListClosure!(sender)
        }

    }
    
    @IBAction func notiBtnClick(_ sender: UIButton) {
        if notiListClosure != nil {
            notiListClosure!(sender)
        }
        
    }
    
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        
    }
    
}
