//
//  IndustryChoseVC.swift
//  Reindeer
//
//  Created by shiliuhua on 17/3/1.
//  Copyright © 2017年 shiliuhua. All rights reserved.
//

import UIKit
import TagListView
import SVProgressHUD

class IndustryChoseVC: BaseViewVC,TagListViewDelegate {

    
    @IBOutlet var titleLabel: UILabel!
    
    @IBOutlet var tagListView: TagListView!
    
    var industryModel:CompanyIndustryListBaseClass?
    
    var modelArray:NSMutableArray = []
    var industryModelArray:[CompanyIndustryListList]? = []
    
    //点击确定回调
    var sureBtnClickClosure:((_ listModelArray:[CompanyIndustryListList]) ->())?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        getAllIndustry()
        tagListView.delegate = self
        //右侧完成
        let surebtn = UIBarButtonItem(title: "完成", style: .plain, target: self, action: #selector(completeBtnClick))
        
        self.navigationItem.rightBarButtonItem = surebtn
    }
    func completeBtnClick() -> Void {
        
        print("selectTag.count = \(tagListView.selectedTags().count)")
        print("industryModelArray = \(industryModelArray)")
        for listModel in industryModelArray! {
            let model:CompanyIndustryListList = listModel 
            print("model.name=\(model.name) model.id=\(model.id)")
        }
        for selectTagView in tagListView.selectedTags() {
            print("selectTagView = \(selectTagView.currentTitle)")
        }
        if (sureBtnClickClosure != nil) {
            sureBtnClickClosure!(industryModelArray!)
        }
       _ = self.navigationController?.popViewController(animated: true)
        
    }
    
    //获得所有行业
    func getAllIndustry() -> Void {
        getCompanyIndustry(dic: ["token":GetUser(key: "token"),"no":"1","size":"20"], actionHandler: { (bassClass) in
            self.industryModel = bassClass
            var indexNum = 0
            for listModel in (self.industryModel?.list)! {
                indexNum = indexNum + 1
                if indexNum < 20 {
                    let industryListModel:CompanyIndustryListList = listModel
                    self.tagListView.addTag(industryListModel.name!)
                    self.modelArray.add(industryListModel)
                }
            }
            
        }, fail: {
            
        })
    }
    
    func tagPressed(_ title: String, tagView: TagView, sender: TagListView) -> Void
    {
        print("title = \(title),tagView = \(tagView) , sender = \(sender)")
        if tagListView.selectedTags().count >= 3 {
            SVProgressHUD.showInfo(withStatus: "最多选择3个")
            return
        }
        if tagView.isSelected == true {
            tagView.isSelected = false
        }else{
            tagView.isSelected = true
        }
        //反遍历得到id
        for tagModel in self.modelArray {
            let industryListModel:CompanyIndustryListList = tagModel as! CompanyIndustryListList
            if title == industryListModel.name {
                industryModelArray?.append(industryListModel)
            }
        }
        print("industryModelArray = \(industryModelArray)")
        
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
