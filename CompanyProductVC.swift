//
//  CompanyProductVC.swift
//  Reindeer
//
//  Created by shiliuhua on 17/2/20.
//  Copyright © 2017年 shiliuhua. All rights reserved.
//

// 公司产品VC

import UIKit
import SVProgressHUD
import SwiftyJSON
class CompanyProductVC: UIViewController,UITableViewDelegate,UITableViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    @IBOutlet var tableView: UITableView!
    
    var headImageStr:String = ""
    var productNameStr:String = ""
  
    var productIntroduceStr = ""
    var companyId:String = ""
 
    //添加成功后回调
    var succeedReturnClosure:((JSON) -> ())?
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 60
        tableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: "cell")
        tableView.register(UINib.init(nibName: "ProductLogoCell", bundle: nil), forCellReuseIdentifier: "ProductLogoCell")
        tableView.register(UINib.init(nibName: "ProductIntroduceCell", bundle: nil), forCellReuseIdentifier: "ProductIntroduceCell")
        
        tableView.tableFooterView = UIView()
        
        let navBtn = UIBarButtonItem(title: "完成", style: .plain, target: self, action: #selector(addProduct))
        self.navigationItem.rightBarButtonItem = navBtn
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 80
        }else if indexPath.row == 1 {
            return 60
        }else{
            if self.productIntroduceStr == "" {
                return 60
            }else{
                return UITableViewAutomaticDimension
            }
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 3
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProductLogoCell") as! ProductLogoCell
            cell.selectionStyle = .none
            cell.accessoryType = .disclosureIndicator
            cell.backgroundColor = UIColor(hexColor: "f9f6f4")
            cell.logoBtn.addTarget(self, action: #selector(logoBtnClick), for: .touchUpInside)
            if self.headImageStr != "" {
                cell.logoBtn.sd_setBackgroundImage(with: NSURL.init(string: self.headImageStr) as URL!, for: UIControlState.normal)
            }
            return cell
        }else if indexPath.row == 1{
            var cell = tableView.dequeueReusableCell(withIdentifier: "cell")
            cell = UITableViewCell(style: .value1, reuseIdentifier: "cell")
            cell?.accessoryType = .disclosureIndicator
            cell?.textLabel?.font = UIFont.systemFont(ofSize: 15)
            cell?.textLabel?.text = "产品名称"
            cell?.backgroundColor = UIColor(hexColor: "f9f6f4")
            cell?.detailTextLabel?.text = self.productNameStr
            cell?.selectionStyle = .none
            return cell!
        }else if indexPath.row == 2{
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProductIntroduceCell") as! ProductIntroduceCell
            // cell = UITableViewCell(style: .value1, reuseIdentifier: "cell")
          //  cell?.accessoryType = .disclosureIndicator
            cell.textLabel?.font = UIFont.systemFont(ofSize: 15)
           // cell.textLabel?.text = "产品介绍"
            cell.backgroundColor = UIColor(hexColor: "f9f6f4")
            cell.productintroLabel.text = self.productIntroduceStr
           // cell.detailTextLabel?.numberOfLines = 0
            cell.selectionStyle = .none
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
            return cell!
        }
        
}
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            logoBtnClick()
        }else if indexPath.row == 1 {
            //产品名称
            let vc = UIStoryboard.init(name: "LoginAndUserStoryboard", bundle: nil).instantiateViewController(withIdentifier: "PhoneNumVC") as! PhoneNumVC
            
            vc.placeholderStr = "请输入产品名称"
            vc.doneClosure = { (str) in
                self.productNameStr = str
                tableView.reloadData()
            }
            self.navigationController?.pushViewController(vc, animated: true)
        }else if indexPath.row == 2 {
            //产品介绍
           let vc = TextViewVC()
            vc.placeholdText = "请简单描述产品"
            vc.navTitle = "产品描述"
            vc.saveBtnClickClosure = { (deacStr) in
                self.productIntroduceStr = deacStr
                tableView.reloadData()
            }
            self.navigationController?.pushViewController(vc, animated: true)
            
        }
        
    }
    //添加公司产品
    func addProduct() -> Void {
        print("点击完成")
        
        if companyId == "" {
            SVProgressHUD.showInfo(withStatus: "公司id不存在")
            return
        }else if productNameStr == "" {
            SVProgressHUD.showInfo(withStatus: "请输入产品名称")
            return
        }else if productIntroduceStr == "" {
            SVProgressHUD.showInfo(withStatus: "请输入产品描述")
            return
        }
        
        addCompanyProduct(dic: ["companyId":companyId,"logo":self.headImageStr,"name":productNameStr,"desc":productIntroduceStr], actionHandler: { (jsonStr) in
            print("jsonStr = \(jsonStr)")
            if jsonStr["code"] == 0 {
                //成功
                SVProgressHUD.showSuccess(withStatus: jsonStr["msg"].string)
                if (self.succeedReturnClosure != nil) {
                    self.succeedReturnClosure!(jsonStr)
                }
                _ = self.navigationController?.popViewController(animated: true)
                
            }else{
                SVProgressHUD .showInfo(withStatus: jsonStr["msg"].string)
                
            }
            
        }, fail: {

        })
        
    }
    
    
    func logoBtnClick() -> Void {
        
        let actionSheet = UIAlertController.init(title: "设置头像", message: nil, preferredStyle: .actionSheet)
        let chose1 = UIAlertAction(title: "拍一张", style: .default, handler: {(action) in
            self.takePhoto()
        })
        let chose2 = UIAlertAction(title: "从相册中选择", style: .default, handler: {(action) in
            self.localPhoto()
        })
        let cancelBtn = UIAlertAction(title: "取消", style: .cancel, handler: {(action) in
            
        })
        actionSheet.addAction(chose1)
        actionSheet.addAction(chose2)
        actionSheet.addAction(cancelBtn)
        self.present(actionSheet, animated: true, completion: nil)
        
    }
    //拍照
    func takePhoto() -> Void {
        let sourceType = UIImagePickerControllerSourceType.camera
        if UIImagePickerController.isSourceTypeAvailable(sourceType) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = sourceType
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    //从相册中选择
    func localPhoto() -> Void {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
        self.present(imagePicker, animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    {
        picker.dismiss(animated: true, completion: nil)
        let image = info[UIImagePickerControllerEditedImage] as! UIImage
        let imageData = UIImageJPEGRepresentation(image, 0.5)
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0].appending("/headImage.jpg")
        print("path =\(path)")
        let url = NSURL.fileURL(withPath: path)
        do {
            try imageData?.write(to: url)
        } catch  {
            print("error")
        }
        //显示及上传头像
        uploadImage(fileUrl: url, actionHandler: {(jsonStr) in
            print("uploadjsonStr = \(jsonStr)")
            if jsonStr["code"] == 0 {
                //上传成功获得url
                print("imageUrl = \(jsonStr["url"])")
                self.headImageStr = jsonStr["url"].string!
               self.tableView.reloadData()
                
            }
            
        }, fail: {
            
        })
        
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController)
    {
        picker.dismiss(animated: true, completion: nil)
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
