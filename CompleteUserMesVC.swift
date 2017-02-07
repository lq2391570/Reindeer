//
//  CompleteUserMesVC.swift
//  Reindeer
//
//  Created by shiliuhua on 17/2/7.
//  Copyright © 2017年 shiliuhua. All rights reserved.
//

import UIKit

class CompleteUserMesVC: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    
    @IBOutlet var headImageBtn: UIButton!
    
    @IBOutlet var manBtn: UIButton!
    
    @IBOutlet var womanBtn: UIButton!
    
    @IBOutlet var nameTextField: UITextField!
    
    @IBOutlet var cityTextField: UITextField!
    
    @IBOutlet var nextBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
         installHeadBtn()
        // Do any additional setup after loading the view.
        self.navigationController?.navigationBar.barTintColor=UIColor.black
        //消除毛玻璃效果
        self.navigationController?.navigationBar.isTranslucent = false;
        self.title = "完善个人信息"
        self.navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName:UIFont.systemFont(ofSize: 20)]
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.mainColor]
    }
   //设置头像为圆形,性别选择框边框
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
    //上传头像
    @IBAction func uploadHeadImage(_ sender: UIButton) {
        let actionSheet = UIAlertController.init(title: "设置头像", message: nil, preferredStyle: .actionSheet)
        let chose1 = UIAlertAction(title: "拍一张", style: .default, handler: {(action) in
            
        })
        let chose2 = UIAlertAction(title: "从相册中选择", style: .default, handler: {(action) in
            
        })
        let cancelBtn = UIAlertAction(title: "取消", style: .cancel, handler: {(action) in
            
        })
        actionSheet.addAction(chose1)
        actionSheet.addAction(chose2)
        actionSheet.addAction(cancelBtn)
        self.present(actionSheet, animated: true, completion: nil)
        
    }
    @IBAction func nextBtnClick(_ sender: UIButton) {
    //  completeMesOfUsers(dic: <#T##NSDictionary#>, actionHandler: <#T##(JSON) -> Void#>, fail: <#T##() -> Void#>)
        
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
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    {
        picker.dismiss(animated: true, completion: nil)
        
//        let image = info[UIImagePickerControllerEditedImage] as! UIImage
//        let imageData = UIImageJPEGRepresentation(image, 0.5)
//        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0].appending("/headImage.jpg")
//      //  imageData?.write(to: NSURL.fileURL(withPath: path))
//        let url = NSURL.fileURL(withPath: path)
     //   imageData?.write(to: url)
        
        
        
        
        
        
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
