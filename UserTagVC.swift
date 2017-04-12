//
//  UserTagVC.swift
//  Reindeer
//
//  Created by shiliuhua on 17/2/23.
//  Copyright © 2017年 shiliuhua. All rights reserved.
//

import UIKit
import TagListView
class UserTagVC: BaseViewVC,TagListViewDelegate {

    @IBOutlet var alreadySelectLabel: UILabel!
    
    @IBOutlet var taglistSelectView: TagListView!
    var tagNameArray = ["UI","电商美工","交互","手绘","APP设计","多媒体","用户体验"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    // Do any additional setup after loading the view.
        self.title = "个人标签"
        for name in tagNameArray {
            taglistSelectView.addTag(name)
        }
       taglistSelectView.delegate = self
        
    }
    func tagPressed(_ title: String, tagView: TagView, sender: TagListView) -> Void
    {
        print("title = \(title),tagView = \(tagView) , sender = \(sender)")
        if tagView.isSelected == true {
            tagView.isSelected = false
        }else{
            tagView.isSelected = true
        }
    }
    func tagRemoveButtonPressed(_ title: String, tagView: TagView, sender: TagListView) -> Void
    {
        
        
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
