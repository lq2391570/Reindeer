//
//  CompleteCompanyMesVC.swift
//  Reindeer
//
//  Created by shiliuhua on 17/2/10.
//  Copyright © 2017年 shiliuhua. All rights reserved.
//

import UIKit
import QBImagePickerController
import SVProgressHUD
import SwiftyJSON
class CompleteCompanyMesVC: UIViewController,UITableViewDelegate,UITableViewDataSource,QBImagePickerControllerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    @IBOutlet var tableView: UITableView!
    
    var imagePickerController:QBImagePickerController!
    
    //是否添加了图片
    var isHaveImage = false
    //collectionView的item个数(根据item个数判断是否有图片)
    var itemCount:Int = 0
    //图片地址Array
    var imageFileArray:NSMutableArray = []
    //公司产品Array
    var productArray:[CompanyDetail2ProductList] = []
    //公司图片Array
    var companyImageModelArray:[CompanyDetail2ImageList] = []
    
    //公司详情model
    var companyDetailModel:CompanyDetail2BaseClass?
    //公司id
    var companyId:String! = "1"
    //公司行业modelArray
    var industryModelArray:[CompanyIndustryListList]?
    //公司行业String
    var industryString:String! = ""
    //公司行业id
    var industryId:String! = ""
    
    //公司规模Bassmodel
    var scaleBassClass:CompanyScaleBaseClass?
    //公司规模model
    var scaleListModel:CompanyScaleCompanyScale?
    //公司电话String
    var phoneNumStr:String! = ""
    
    //collection是否刷新的标示（bool类型）
    var isReflashCollection = false
    
    //logoImageStr
    var logoImageStr = ""
    //公司简介Str
    var descStr = ""
    //公司图片Array
    var companyImageArray:[String] = [""]
    
    //公司简称
    var companySimpleName = ""
    //公司全称
    var companyCompleteName = ""
    
    
    
    //是完善公司信息还是个人中心进入的公司信息
    enum EnterTypeNum {
        case registerEnter   //注册进入
        case userCenterEnter //个人中心进入
    }
    var enterType:EnterTypeNum = .registerEnter
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.barTintColor=UIColor.black
        //消除毛玻璃效果
        self.navigationController?.navigationBar.isTranslucent = false;
        self.title = "完善公司信息"
        
        if self.enterType == .userCenterEnter {
            self.title = "公司信息"
        }
        
        self.navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName:UIFont.systemFont(ofSize: 20)]
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.mainColor]
        
        confineQBImagePickerController()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib.init(nibName: "AddImageCell", bundle: nil), forCellReuseIdentifier: "AddImageCell")
        tableView.register(UINib.init(nibName: "DefaultSelectCell", bundle: nil), forCellReuseIdentifier: "DefaultSelectCell")
        tableView.register(UINib.init(nibName: "IndustryAndLogoCell", bundle: nil), forCellReuseIdentifier: "IndustryAndLogoCell")
        tableView.register(UINib.init(nibName: "ImageSelectCell", bundle: nil), forCellReuseIdentifier: "ImageSelectCell")
        tableView.register(UINib.init(nibName: "CompanyProductCell", bundle: nil), forCellReuseIdentifier: "CompanyProductCell")
        tableView.register(UINib.init(nibName: "TagAndNameCell", bundle: nil), forCellReuseIdentifier: "TagAndNameCell")
        tableView.backgroundColor = UIColor.init(red: 246/255.0, green: 246/255.0, blue: 246/255.0, alpha: 1)
        
        tableView.tableFooterView = createFootView()
        tableView.estimatedRowHeight = 100
        
        let rightBarItem = UIBarButtonItem.init(title: "跳过", style: .plain, target: self, action: #selector(rightBarItemClick))
        self.navigationItem.rightBarButtonItem = rightBarItem
        
        companyDetail()
        companyScale()
    }
    func rightBarItemClick() -> Void {
        print("跳过")
        
    }
    
       //获得公司详情
    func companyDetail() -> Void {
        //获得公司详情
        print("companyId = \(self.companyId)")
        getCompanyDetail(dic: ["companyId":self.companyId], actionHandler: { (bassClass) in
            self.companyDetailModel = bassClass
            self.productArray = bassClass.productList!
            self.companyImageModelArray = bassClass.imageList!
            if self.companyImageModelArray.count > 0 {
                self.isHaveImage = true
            }
            self.companyImageArray.removeAll()
            for model in self.companyImageModelArray {
                self.companyImageArray.append(model.path!)
            }
            
            self.tableView.reloadData()
        }, fail: {
            
        })
    }
    // 获得公司规模
    func companyScale() -> Void {
        getCompanyScale(dic: ["none":""], actionHandler: { (bassClass) in
            self.scaleBassClass = bassClass
            print("self.scaleBassClass = \(self.scaleBassClass)")
        }, fail: {
            
        })
        
    }
    
    //设置QBImagePickerController
    func confineQBImagePickerController() -> Void {
        imagePickerController = QBImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsMultipleSelection = true
        imagePickerController.maximumNumberOfSelection = 6
        imagePickerController.showsNumberOfSelectedAssets = true
    }
    
    func createFootView() -> UIView {
        let footView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width , height: 60))
        let btn = UIButton(frame: CGRect.init(x: 20, y: 10, width: tableView.frame.size.width - 40, height: 40))
        btn.backgroundColor = UIColor.black
        btn.setTitle("保存", for: .normal)
        btn.setTitleColor(UIColor.mainColor, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        btn.addTarget(self, action: #selector(nextBtnClick), for: .touchUpInside)
        footView.addSubview(btn)
        return footView
    }
    func nextBtnClick() -> Void {
        print("保存")
        
        
        print("companyId = \(companyId),logo = \(logoImageStr),industryId = \(industryId) scaleId = \(scaleListModel?.id!) tel = \(phoneNumStr), address = 暂无  desc = \(descStr),images = \(self.companyImageArray)")
        //(地址暂时为空)
        
        
        let dicStr:NSDictionary = ["companyId":companyId,"logo":logoImageStr,"industryId":industryId!,"scaleId":(scaleListModel?.id)!,"tel":phoneNumStr,"address":"","desc":descStr,"images":companyImageArray]
        let jsonStr = JSON(dicStr)
        
        
        print("jsonStr.dictionaryValue = \(jsonStr.dictionaryValue)")
        
        completeCompanyMes(dic: jsonStr.dictionaryValue as NSDictionary, actionHandler: { (jsonStr) in
            
            
            if jsonStr["code"] == 0 {
                SVProgressHUD.showSuccess(withStatus: "\(jsonStr["msg"].stringValue)")
                //添加职位
            let vc = UIStoryboard(name: "UserCenter", bundle: nil).instantiateViewController(withIdentifier: "HRAddJobVC") as! HRAddJobVC
             vc.companyId = self.companyId
                
            self.navigationController?.pushViewController(vc, animated: true)
                
                
                
            }else{
                SVProgressHUD.showInfo(withStatus: jsonStr["msg"].stringValue)
                
            }
            
        }, fail: {
            
        })
        
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if section == 0 {
            return 2
        }else if section == 1{
            return 2
        }else if section == 2{
            
            return 3
        }else if section == 3{
            return 1
        }else if section == 4{
            if isHaveImage == false {
                return 1
            }else{
                return 2
            }
        }else if section == 5{
            return productArray.count + 1
        }else{
            return 0
        }
       
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "IndustryAndLogoCell") as! IndustryAndLogoCell
                cell.nameLabel.text = "公司简称"
               // cell.rightLabel.text = self.industryString
               // cell.rightLabel.text = self.companySimpleName
                cell.rightLabel.text = self.companyDetailModel?.shortName
                cell.logoBtn.sd_setBackgroundImage(with: NSURL.init(string: self.logoImageStr) as URL!, for: .normal)
                if self.logoImageStr != "" {
                    cell.logoBtn.setTitle("", for: .normal)
                }
                cell.logoBtnClickclosure = { (sender) in
                    self.uploadHeadImage()
                }
                return cell
            }else  {
                let cell = tableView.dequeueReusableCell(withIdentifier: "DefaultSelectCell") as! DefaultSelectCell
                cell.topLineLabel.isHidden = true
                cell.bottomLineLabel.isHidden = true
                cell.nameLabel.text = "公司全称"
               // cell.rightLabel.text = self.scaleListModel?.name
                cell.rightLabel.text = self.companyDetailModel?.name
                return cell
            }
        }else if indexPath.section == 1 {
            if indexPath.row == 0{
                let cell = tableView.dequeueReusableCell(withIdentifier: "DefaultSelectCell") as! DefaultSelectCell
                cell.topLineLabel.isHidden = true
                cell.bottomLineLabel.isHidden = true
                cell.nameLabel.text = "公司行业"
                cell.rightLabel.text = self.companyDetailModel?.companyIndustry?.name
                return cell
            }else{
                let cell = tableView.dequeueReusableCell(withIdentifier: "DefaultSelectCell") as! DefaultSelectCell
                cell.topLineLabel.isHidden = true
                cell.bottomLineLabel.isHidden = true
                cell.nameLabel.text = "公司规模"
                cell.rightLabel.text = self.companyDetailModel?.companyScale?.name
                return cell
            }
        }else if indexPath.section == 2{
            let cell = tableView.dequeueReusableCell(withIdentifier: "DefaultSelectCell") as! DefaultSelectCell
            if indexPath.row == 0 {
                cell.topLineLabel.isHidden = true
                cell.bottomLineLabel.isHidden = true
                cell.nameLabel.text = "公司电话"
                cell.rightLabel.text = self.companyDetailModel?.tel
            }else if indexPath.row == 2{
                cell.topLineLabel.isHidden = true
                cell.bottomLineLabel.isHidden = true
                cell.nameLabel.text = "公司简介"
                cell.rightLabel.text = self.companyDetailModel?.desc
            }else{
                cell.nameLabel.text = "公司地址"
                cell.rightLabel.text = self.companyDetailModel?.address
            }
            return cell
        }else if indexPath.section == 3 {
            //团队亮点
            let cell = tableView.dequeueReusableCell(withIdentifier: "TagAndNameCell") as! TagAndNameCell
            
            return cell
        }else if indexPath.section == 4 {
            //判断是否添加了图片
            if isHaveImage == false {
                //没有添加公司图片
                let cell = tableView.dequeueReusableCell(withIdentifier: "AddImageCell") as! AddImageCell
                cell.nameLabel.text = "添加公司图片"
                return cell
                 }else{
                //添加了公司图片
                if indexPath.row == 0 {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "ImageSelectCell") as! ImageSelectCell
                    
                    cell.imagePathArray = NSMutableArray.init(array: self.companyImageArray)
                    print("cell.imagePathArray = \(cell.imagePathArray)")
                    if isReflashCollection == false {
                        isReflashCollection = true
                        cell.collectionView.reloadData()
                    }
                    
                    //判断item是否大于1
                    if cell.collectionView.numberOfItems(inSection: 0) > 1 {
                         itemCount = cell.collectionView.numberOfItems(inSection: 0)
                    }
                  //图片点击
                    cell.imageBtnClickClosure = { (btn) in
                          print("tupian")
                    }
                    //添加按钮点击
                    cell.addBtnClickClosure = { (btn) in
                        print("添加")
                    self.present(self.imagePickerController, animated: true, completion: nil)
                    }
                    return cell
                }else{
                    let cell = tableView.dequeueReusableCell(withIdentifier: "AddImageCell") as! AddImageCell
                    cell.nameLabel.text = "添加公司图片"
                    return cell
                }
            }
        }else if indexPath.section == 5 {
            if productArray.count == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "AddImageCell") as! AddImageCell
                cell.nameLabel.text = "添加公司产品"
                return cell
            }else{
                if indexPath.row == productArray.count{
                    let cell = tableView.dequeueReusableCell(withIdentifier: "AddImageCell") as! AddImageCell
                    cell.nameLabel.text = "添加公司产品"
                    return cell
                }else{
                    let cell = tableView.dequeueReusableCell(withIdentifier: "CompanyProductCell") as! CompanyProductCell
                    let productModel:CompanyDetail2ProductList = productArray[indexPath.row]
                    
                    cell.headImage.sd_setBackgroundImage(with: NSURL.init(string: productModel.logo ?? "") as URL!, for: UIControlState.normal)
                    
                    cell.titleLabel.text = productModel.name
                    cell.introLabel.text = productModel.desc
                    
                    return cell
                }
            }
        }else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
            
            return cell!
        }
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                //公司简称
                let vc = TextViewVC()
                vc.placeholdText = "请输入公司简称"
                vc.navTitle = "公司简称"
                vc.textViewTypeEnum = .typeWorkContent
                vc.saveBtnClickClosure = { (deacStr) in
                    self.companySimpleName = deacStr
                    tableView.reloadData()
                }
                self.navigationController?.pushViewController(vc, animated: true)
            }else if indexPath.row == 1 {
                //公司全称
                let vc = TextViewVC()
                vc.placeholdText = "请输入公司全称"
                vc.navTitle = "公司全称"
                vc.textViewTypeEnum = .typeWorkContent
                vc.saveBtnClickClosure = { (deacStr) in
                    self.companyCompleteName = deacStr
                    tableView.reloadData()
                }
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }else if indexPath.section == 2 {
            if indexPath.row == 0 {
                //设置公司电话号码
                let vc = UIStoryboard(name: "LoginAndUserStoryboard", bundle: nil).instantiateViewController(withIdentifier: "PhoneNumVC") as! PhoneNumVC
                vc.placeholderStr = "请输入公司电话"
                vc.doneClosure = { (str) in
                    self.phoneNumStr = str
                    self.tableView.reloadData()
                }
                self.navigationController?.pushViewController(vc, animated: true)
            }else if indexPath.row == 2 {
                //公司简介
                let vc = TextViewVC()
                vc.placeholdText = "请简单描述公司"
                vc.navTitle = "公司简介"
                vc.textViewTypeEnum = .typeWorkContent
                vc.saveBtnClickClosure = { (deacStr) in
                    self.descStr = deacStr
                    tableView.reloadData()
                }
                self.navigationController?.pushViewController(vc, animated: true)
                
            }
        }else if indexPath.section == 4 {
            //判断是否有图片
            if isHaveImage == true {
                //有图片则需判断点击了哪一个row（图片展示的或添加图片的）
                if indexPath.row == 0 {
                    //点击了有图片的cell
                }else{
                    //点击了没有图片的cell（添加公司图片的cell）
                    self.present(imagePickerController, animated: true, completion: nil)
                }
            }else{
                //点击了添加图片的cell
                    self.present(imagePickerController, animated: true, completion: nil)
                
            }
            
        }else if indexPath.section == 5{
            if productArray.count == 0{
                let vc = UIStoryboard(name: "LoginAndUserStoryboard", bundle: nil).instantiateViewController(withIdentifier: "CompanyProductVC") as! CompanyProductVC
                vc.companyId = companyId
                vc.succeedReturnClosure = { (jsonStr) in
                    self.companyDetail()
                   
                }
                self.navigationController?.pushViewController(vc, animated: true)
            }else{
                if indexPath.row == productArray.count {
                    let vc = UIStoryboard(name: "LoginAndUserStoryboard", bundle: nil).instantiateViewController(withIdentifier: "CompanyProductVC") as! CompanyProductVC
                    vc.succeedReturnClosure = { (jsonStr) in
                        self.companyDetail()
                    }
                    vc.companyId = companyId
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
            
        }else if indexPath.section == 1 {
            if indexPath.row == 0 {
                //选择公司行业
                let vc = UIStoryboard(name: "LoginAndUserStoryboard", bundle: nil).instantiateViewController(withIdentifier: "IndustryChoseVC") as! IndustryChoseVC
                
                vc.sureBtnClickClosure = { (modelArray) in
                    self.industryModelArray = modelArray
                    for listModel in modelArray {
                        let model:CompanyIndustryListList! = listModel
                        self.industryString.append(model.name!)
                        self.industryId = "\(listModel.id!)"
                    }
                    print("self.industryString = \(self.industryString)")
                    print("self.industryId = \(self.industryId)")
                    self.tableView.reloadData()
                }
                
                self.navigationController?.pushViewController(vc, animated: true)
            }else if indexPath.row == 1 {
                var stringArray:[String] = []
                for scaleList in (self.scaleBassClass?.companyScale)! {
                    let model:CompanyScaleCompanyScale = scaleList 
                    stringArray.append(model.name!)
                }
                createActionSheet(title: "公司规模", message: "请选择公司规模", stringArray: stringArray, viewController: self, closure: { (index) in
                    print("选择了第\(index)个")
                    self.scaleListModel = self.scaleBassClass?.companyScale?[index]
                    self.tableView.reloadData()
                })
            
            }
            
            
        }
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
    //上传头像
    func uploadHeadImage() {
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

    //imagePickerControllerDelegate
    func qb_imagePickerControllerDidCancel(_ imagePickerController: QBImagePickerController!) {
        
        print("imagePickerController.selectedAssets =\(imagePickerController.selectedAssets)")
        //若无图片则清空集合
        if imagePickerController.selectedAssets.count == 0 {
            self.imageFileArray = []
             self.isReflashCollection = false
            tableView.reloadData()
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    func qb_imagePickerController(_ imagePickerController: QBImagePickerController!, didFinishPickingAssets assets: [Any]!) {
        var index = 0
        print("asstes.count=\(assets.count)")
        //因为assets有缓存，所以每次调用需清空数组
        self.imageFileArray = []
       // self.companyImageArray = []
        for asset in assets {
            print("asset=\(asset)")
            index = index + 1
        //    let imageAsset:PHAsset = asset as! PHAsset
        //    let size = CGSize(width: imageAsset.pixelWidth, height: imageAsset.pixelHeight)
            let size = CGSize(width: 100, height: 100)
            //获取图片
            //PHImageRequestOptionsDeliveryModeOpportunistic 当选用此项时，Photos会在你请求时给你提供一个或者多个结果，这就意味着resultHandler block可能会执行一次或多次，例如Photos会先给你一个低分辨率的图片让你暂时显示，然后加载出高质量的图片后再次给你。如果PHImageManager已经pre-cache了图片，那result handler便只会执行一次。另外，如果synchronous属性为NO,此选项是不起作用的。
            let option = PHImageRequestOptions()
            option.isSynchronous = true
            option.deliveryMode = .opportunistic
            
            PHImageManager.default().requestImage(for: asset as! PHAsset, targetSize: size, contentMode: PHImageContentMode.aspectFit, options: option, resultHandler: { (result, info) in
                print("result = \(result) info = \(info)")
                let image:UIImage = result!
                
                var imageData:Data? = UIImageJPEGRepresentation(image, 0.5)
                
                if imageData == nil {
                    imageData = UIImagePNGRepresentation(image)
                }
                
                let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0].appending("/companyImage\(index).jpg")
                print("path = \(path)")
                let url = NSURL.fileURL(withPath: path)
                do {
                    try imageData?.write(to: url)
                } catch {
                    print("error")
                }
                
                self.imageFileArray.add(url)
                if self.imageFileArray.count > 0 {
                    self.isHaveImage = true
                }
                self.isReflashCollection = false
                
                self.tableView.reloadData()
                
            })
        }
        print("self.imageFileArray.count=\(self.imageFileArray.count)")
        
        for imageUrl in self.imageFileArray {
            uploadImage(fileUrl: imageUrl as! URL, actionHandler: { (jsonStr) in
                
                print("jsonstr = \(jsonStr)")
                if jsonStr["code"] == 0 {
                    let imageUrlStr = jsonStr["url"].stringValue
                    self.companyImageArray.append(imageUrlStr)
                    self.isReflashCollection = false
                    self.tableView.reloadData()
                }
            }, fail: {
                
            })
        }

        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                return 150
            }else{
                return 70
            }
        }else if indexPath.section == 1 {
            return 70
        }else if indexPath.section == 2 {
            return 70
        }else if indexPath.section == 3 {
            return 70
        }else if indexPath.section == 4 {
            if isHaveImage == true {
                //需判断是哪个cell
                if indexPath.row == 0 {
                    //itemCount % 4 大于0 则不被4整除
                return CGFloat((itemCount % 4)>0 ? (itemCount/4 + 1) * 100 : itemCount/4 * 100)
                }
                return 50
            }
            return 50
            
        }else if indexPath.section == 5{
            //是否有产品
            if productArray.count > 0{
                if indexPath.row == productArray.count {
                    return 50
                }else{
                    return UITableViewAutomaticDimension
                }
            }else{
                return 50
            }
           
        }
        else{
            return UITableViewAutomaticDimension
        }
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        if section == 0 {
            return 30
        }else {
            return 10
        }
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat
    {
        return 10
    }
    func numberOfSections(in tableView: UITableView) -> Int
    {
      return 6
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
                self.logoImageStr = jsonStr["url"].string!
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
