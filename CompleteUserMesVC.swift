//
//  CompleteUserMesVC.swift
//  Reindeer
//
//  Created by shiliuhua on 17/2/7.
//  Copyright © 2017年 shiliuhua. All rights reserved.
//

import UIKit
import SDWebImage
import SVProgressHUD
import JVFloatLabeledTextField
import JCAlertView
class CompleteUserMesVC: BaseViewVC,UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    
    @IBOutlet var headImageBtn: UIButton!
    
    @IBOutlet var manBtn: UIButton!
    
    @IBOutlet var womanBtn: UIButton!
    
    @IBOutlet var nameTextField: JVFloatLabeledTextField!
    
    @IBOutlet var cityTextField: JVFloatLabeledTextField!
    
    @IBOutlet var nextBtn: UIButton!
    
    @IBOutlet var choseCityBtn: UIButton!
    
    //地区id
    var areaId:String = ""
    //地区model
    var areaModel:AreaBaseClass?
    
    //性别
    var sexStr:String!
    //头像字符串
    var headImageStr = ""
    
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
    @IBAction func choseCityBtnClick(_ sender: UIButton) {
        
        if let customView = LQAreaPickView.newInstance() {
           
            let customAlert = JCAlertView.init(customView: customView, dismissWhenTouchedBackground: false)
            
            customAlert?.center = CGPoint.init(x: ScreenWidth/2, y: ScreenHeight - customView.frame.size.height/2-20)
            customView.cancelbtnClickClosure = { (btn) in
                customAlert?.dismiss(completion: nil)
                
            }
            customView.sureBtnClickclosure = { (btn) in
                
                print("cityName = \(customView.selevtCityModel?.name) , cityId = \(customView.selevtCityModel?.id)")
                self.cityTextField.text = "\(customView.selectProvinModel?.name! ?? "")\(customView.selevtCityModel?.name! ?? "")"
                customAlert?.dismiss(completion: nil)
                self.areaModel = customView.selevtCityModel
                
                
            }
            customAlert?.show()
            
        }
        
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
        manBtn.isSelected = true
        manBtn.backgroundColor = UIColor.init(hexColor: "f4cda2")
        womanBtn.isSelected = false
        nameTextField.floatingLabelFont = UIFont.systemFont(ofSize: 16)
        cityTextField.floatingLabelFont = UIFont.systemFont(ofSize: 16)
        cityTextField.isUserInteractionEnabled = false
    }
    

    //上传头像
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
    
    
    @IBAction func nextBtnClick(_ sender: UIButton) {
        //判断性别
        if manBtn.isSelected == true {
            sexStr = "男"
        }else if womanBtn.isSelected == true{
            sexStr = "女"
        }
        guard nameTextField.text != nil && nameTextField.text != "" else {
            SVProgressHUD.showInfo(withStatus: "姓名不能为空")
            return
        }
        
        completeMesOfUsers(dic: ["token":GetUser(key: "token"),"sex":sexStr,"name":nameTextField.text!,"avatar":self.headImageStr,"area":self.areaModel?.id as Any], actionHandler: {(jsonStr) in
            if jsonStr["code"] == 0 {
                SVProgressHUD.showSuccess(withStatus: "完善信息成功")
                //完善信息后必须填写求职意向，否则无法进入首页（什么鬼需求）
                let vc = UIStoryboard(name: "UserCenter", bundle: nil).instantiateViewController(withIdentifier: "AddJobIntensionVC") as! AddJobIntensionVC
                self.navigationController?.pushViewController(vc, animated: true)
                
//                //跳转首页
//                let vc = UIStoryboard(name: "UserFirstStoryboard", bundle: nil).instantiateInitialViewController()
//                let nav = UINavigationController(rootViewController: vc!)
//                self.view.window?.rootViewController = nav
                
            }else{
                SVProgressHUD.showInfo(withStatus: jsonStr["msg"].string)
            }
            
        }, fail: {
            
        })
        
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
