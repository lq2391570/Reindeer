//
//  CompleteHRMesVC2.swift
//  Reindeer
//
//  Created by shiliuhua on 2017/9/8.
//  Copyright © 2017 shiliuhua. All rights reserved.
//

import UIKit
import SDWebImage
import SVProgressHUD
import JVFloatLabeledTextField
import JCAlertView
import SwiftyJSON
class CompleteHRMesVC2: BaseViewVC,UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    
    @IBOutlet var headImageBtn: UIButton!
    
    @IBOutlet var manBtn: UIButton!
    
    @IBOutlet var womanBtn: UIButton!
    
    @IBOutlet var nameTextField: JVFloatLabeledTextField!
    
    @IBOutlet var jobTextField: JVFloatLabeledTextField!
    
    @IBOutlet var nextBtn: UIButton!
    
    @IBOutlet var choseCityBtn: UIButton!
    
    @IBOutlet var choseYearbtn: UIButton!
    
    @IBOutlet var emailTextField: JVFloatLabeledTextField!
    //个人信息json
    var userMesJson:JSON?
    //头像字符串
    var headImageStr = ""
    //性别
    var sexStr:String!
    override func viewDidLoad() {
        super.viewDidLoad()
       self.title = "完善信息"
        // Do any additional setup after loading the view.
        self.installHeadBtn()
    }
    //设置头像为圆形,性别选择框边框,textfield
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
        if self.userMesJson?["sex"].stringValue == "男" {
            manBtn.isSelected = true
            womanBtn.isSelected = false
            manBtn.backgroundColor = UIColor.init(hexColor: "f4cda2")
            womanBtn.backgroundColor = UIColor.clear
            
            
        }else{
            manBtn.isSelected = false
            womanBtn.isSelected = true
            womanBtn.backgroundColor = UIColor.init(hexColor: "f4cda2")
            manBtn.backgroundColor = UIColor.clear
            
        }
        
        
        nameTextField.floatingLabelFont = UIFont.systemFont(ofSize: 14)
        nameTextField.text = self.userMesJson?["name"].stringValue
        nameTextField.setPlaceholder("真实姓名", floatingTitle: "姓名")
        jobTextField.floatingLabelFont = UIFont.systemFont(ofSize: 14)
       // jobTextField.isUserInteractionEnabled = false
        jobTextField.text = self.userMesJson?["area"].stringValue
        jobTextField.setPlaceholder("您的职务", floatingTitle: "职务")
        emailTextField.floatingLabelFont = UIFont.systemFont(ofSize: 14)
        emailTextField.setPlaceholder("您的邮箱", floatingTitle: "邮箱")
//        self.areaModel = AreaBaseClass(object: "")
//        self.areaModel?.id = self.userMesJson?["areaId"].intValue
        
        
    }
    
    
    @IBAction func nextBtnClick(_ sender: UIButton) {
        
        SVProgressHUD.show()
        if manBtn.isSelected == true {
            sexStr = "男"
        }else if womanBtn.isSelected == true{
            sexStr = "女"
        }
        if nameTextField.text == nil || nameTextField.text == "" {
            SVProgressHUD.showInfo(withStatus: "请填写姓名")
            return
        }
        if jobTextField.text == nil || jobTextField.text == "" {
            SVProgressHUD.showInfo(withStatus: "请填写职务")
            return
        }
        if emailTextField.text == nil || emailTextField.text == "" {
            SVProgressHUD.showInfo(withStatus: "请填写邮箱")
            return
        }
        

        let dic = [
            "token":GetUser(key: TOKEN),
            "avatar":self.headImageStr,
            "sex":sexStr,
            "name":nameTextField.text!,
            "job":jobTextField.text!,
            "email":emailTextField.text!
        ]
        
        let jsonStr = JSON(dic)
        let newDic:NSDictionary = jsonStr.dictionaryValue as NSDictionary
        print("newDic = \(newDic)")
        HRCompleteMesNewInterface(dic: newDic, actionHander: { (jsonStr) in
            if jsonStr["code"] == 0 {
                SVProgressHUD.showSuccess(withStatus: jsonStr["msg"].stringValue)
                
                
            }else{
                SVProgressHUD.showInfo(withStatus: jsonStr["msg"].stringValue)
            }
            
        }) { 
            
        }
        
        
        
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
                self.headImageBtn.sd_setBackgroundImage(with: NSURL.init(string: self.headImageStr) as URL!, for: UIControlState.normal)
                
            }
            
        }, fail: {
            
        })
        
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController)
    {
        picker.dismiss(animated: true, completion: nil)
    }
    @IBAction func menBtnClick(_ sender: UIButton) {
        
        if manBtn.isSelected == false {
            manBtn.isSelected = true
            manBtn.backgroundColor = UIColor.init(hexColor: "f4cda2")
            womanBtn.backgroundColor = UIColor.clear
            womanBtn.isSelected = false
        }
        
    }
    @IBAction func womanBtnClick(_ sender: UIButton) {
        
        if womanBtn.isSelected == false {
            womanBtn.isSelected = true
            womanBtn.backgroundColor = UIColor.init(hexColor: "f4cda2")
            manBtn.backgroundColor = UIColor.clear
            manBtn.isSelected = false
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
