//
//  CompleteHRMesHeadCell.swift
//  Reindeer
//
//  Created by shiliuhua on 17/2/9.
//  Copyright © 2017年 shiliuhua. All rights reserved.
//

import UIKit

class CompleteHRMesHeadCell: UITableViewCell,UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    @IBOutlet var headImageBtn: UIButton!
    
    @IBOutlet var manBtn: UIButton!
    
    @IBOutlet var womanBtn: UIButton!
    //选择图片回调
    var choseImageColsure:((String) -> ())?
    
    //性别
    var sexStr:String!
    //头像字符串
    var headImageStr = ""
    
    var superVC:UIViewController!
    //性别按钮点击回调
    var sexBtnClickClosure:((_ btn:UIButton) ->())?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        installHeadBtn()
        self.selectionStyle = .none
    }
    func installHeadBtn() -> Void {
        headImageBtn.layer.cornerRadius = 50
        headImageBtn.layer.masksToBounds = true
        manBtn.layer.borderColor = UIColor.init(hexColor: "f4cda2").cgColor
        manBtn.layer.borderWidth = 1
        womanBtn.layer.borderColor = UIColor.init(hexColor: "f4cda2").cgColor
        womanBtn.layer.borderWidth = 1
        manBtn.setTitleColor(UIColor.black, for: .selected)
        manBtn.setTitleColor(UIColor.init(hexColor: "f4cda2"), for: .normal)
        womanBtn.setTitleColor(UIColor.black, for: .selected)
        womanBtn.setTitleColor(UIColor.init(hexColor: "f4cda2"), for: .normal)
        manBtn.isSelected = true
        manBtn.backgroundColor = UIColor.init(hexColor: "f4cda2")
        womanBtn.isSelected = false
    }
    @IBAction func uploadHeadImage(_ sender: UIButton) {
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
        self.superVC.present(actionSheet, animated: true, completion: nil)
        
    }
    //拍照
    func takePhoto() -> Void {
        let sourceType = UIImagePickerControllerSourceType.camera
        if UIImagePickerController.isSourceTypeAvailable(sourceType) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = sourceType
            imagePicker.allowsEditing = true
            self.superVC.present(imagePicker, animated: true, completion: nil)
        }
    }
    //从相册中选择
    func localPhoto() -> Void {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
        self.superVC.present(imagePicker, animated: true, completion: nil)
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
                self.headImageBtn.sd_setBackgroundImage(with: NSURL.init(string: self.headImageStr) as URL!, for: UIControlState.normal)
                if self.choseImageColsure != nil {
                    self.choseImageColsure!(self.headImageStr)
                }
                
            }
            
        }, fail: {
            
        })
        
    }
    
    @IBAction func manBtnClick(_ sender: UIButton) {
        
        if manBtn.isSelected == false {
            manBtn.isSelected = true
            manBtn.backgroundColor = UIColor.init(hexColor: "f4cda2")
            womanBtn.backgroundColor = UIColor.clear
            womanBtn.isSelected = false
            self.sexBtnClickClosure!(manBtn)
        }

    }
    
    @IBAction func womanBtnClick(_ sender: UIButton) {
        
        if womanBtn.isSelected == false {
            womanBtn.isSelected = true
            womanBtn.backgroundColor = UIColor.init(hexColor: "f4cda2")
            manBtn.backgroundColor = UIColor.clear
            manBtn.isSelected = false
            self.sexBtnClickClosure!(womanBtn)
        }

    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController)
    {
        picker.dismiss(animated: true, completion: nil)
    }

    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
