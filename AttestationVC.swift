//
//  AttestationVC.swift
//  Reindeer
//
//  Created by shiliuhua on 2017/6/26.
//  Copyright © 2017年 shiliuhua. All rights reserved.
//

import UIKit
import SwiftyJSON
import SVProgressHUD
class AttestationVC: BaseViewVC,UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    @IBOutlet var leftLabel: UILabel!
    
    @IBOutlet var rightLabel: UILabel!
    
    @IBOutlet var lineLabel: UILabel!
    
    @IBOutlet var imageBtn: UIButton!
    //zhizhaoImageStr
    var zhizhaoImageStr = ""
    
    //提交type(线上0，线下1)
    var commitType = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        leftLabel.isUserInteractionEnabled = true
        rightLabel.isUserInteractionEnabled = true
        let leftTap = UITapGestureRecognizer(target: self, action: #selector(leftLabelTap))
        leftLabel.addGestureRecognizer(leftTap)
        let rightTap = UITapGestureRecognizer(target: self, action: #selector(rightLabelTap))
        rightLabel.addGestureRecognizer(rightTap)
        
    }
    
    @IBAction func commitBtnClick(_ sender: UIButton) {
        if self.commitType == 0 {
            let dic:NSDictionary = [
                "token":GetUser(key: TOKEN),
                "anthType":0,
                "busiLicense":self.zhizhaoImageStr
            ]
            let jsonStr = JSON(dic)
            let newDic = jsonStr.dictionaryValue as NSDictionary
            HRcompanyAttestation(dic: newDic, actionHander: { (jsonStr) in
                if jsonStr["code"] == 0 {
                    SVProgressHUD.showSuccess(withStatus: "上传成功")
                }else{
                    SVProgressHUD.showInfo(withStatus: jsonStr["msg"].stringValue)
                }
            }, fail: { 
                
            })
            
        }
        
    }
    
    
    @IBAction func imageBtnClick(_ sender: UIButton) {
        //上传执照图片
        let actionSheet = UIAlertController.init(title: "上传执照", message: nil, preferredStyle: .actionSheet)
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
    //图片选择代理
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        picker.dismiss(animated: true, completion: nil)
        let image = info[UIImagePickerControllerEditedImage] as! UIImage
        let imageData = UIImageJPEGRepresentation(image, 0.5)
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0].appending("/logoImage.jpg")
        print("path =\(path)")
        let url = NSURL.fileURL(withPath: path)
        do {
            try imageData?.write(to: url)
        } catch  {
            print("error")
        }
        //显示及上传logo
        uploadImage(fileUrl: url, actionHandler: {(jsonStr) in
            print("uploadjsonStr = \(jsonStr)")
            if jsonStr["code"] == 0 {
                //上传成功获得url
                print("imageUrl = \(jsonStr["url"])")
                self.zhizhaoImageStr = jsonStr["url"].string!
                self.imageBtn.sd_setBackgroundImage(with: URL.init(string: self.zhizhaoImageStr), for: UIControlState.normal, placeholderImage: nil)
                
            }
            
        }, fail: {
            
        })
        
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController)
    {
        picker.dismiss(animated: true, completion: nil)
    }

    
    
    //左边的label点击
    func leftLabelTap() -> Void {
        print("左边label点击")
         print("self.lineLabel.center = \(self.lineLabel.center)")

        self.commitType = 0
//        delay(0.3) {
//            self.leftLabel.font = UIFont.systemFont(ofSize: 24)
//            self.leftLabel.textColor = UIColor.black
//            self.rightLabel.font = UIFont.systemFont(ofSize: 20)
//            self.rightLabel.textColor = UIColor.darkGray
//            
//        }

        
        UIView.animate(withDuration: 0.3) {
            
        print("self.lineLabel.center = \(self.lineLabel.center)")
            self.lineLabel.center=CGPoint.init(x: self.leftLabel.center.x, y:self.lineLabel.center.y)
            
        }
       
    }
    //右边的label点击
    func rightLabelTap() -> Void {
        print("右边label点击")
        print("self.lineLabel.center = \(self.lineLabel.center)")
        self.commitType = 1
//        delay(0.3) {
//            self.rightLabel.font = UIFont.systemFont(ofSize: 24)
//            self.rightLabel.textColor = UIColor.black
//            self.leftLabel.font = UIFont.systemFont(ofSize: 20)
//            self.leftLabel.textColor = UIColor.darkGray
//        }

        
    UIView.animate(withDuration: 0.3) {
        self.lineLabel.center=CGPoint.init(x: self.rightLabel.center.x, y: self.lineLabel.center.y)
            print("self.lineLabel.center = \(self.lineLabel.center)")
    }
        
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
