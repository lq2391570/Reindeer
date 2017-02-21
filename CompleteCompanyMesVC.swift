//
//  CompleteCompanyMesVC.swift
//  Reindeer
//
//  Created by shiliuhua on 17/2/10.
//  Copyright © 2017年 shiliuhua. All rights reserved.
//

import UIKit
import QBImagePickerController


class CompleteCompanyMesVC: UIViewController,UITableViewDelegate,UITableViewDataSource,QBImagePickerControllerDelegate {

    @IBOutlet var tableView: UITableView!
    
    
    
    
    var imagePickerController:QBImagePickerController!
    
    //是否添加了图片
    var isHaveImage = false
    //collectionView的item个数(根据item个数判断是否有图片)
    var itemCount:Int = 0
    //图片地址Array
    var imageFileArray:NSMutableArray = []
    //公司产品Array
    var productArray:[CompanyDetailProductList] = []
    //公司详情model
    var companyDetailModel:CompanyDetailBaseClass?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.barTintColor=UIColor.black
        //消除毛玻璃效果
        self.navigationController?.navigationBar.isTranslucent = false;
        self.title = "完善公司信息"
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
        
        tableView.tableFooterView = createFootView()
        tableView.estimatedRowHeight = 100
        companyDetail()
        
    }
    //获得公司详情
    func companyDetail() -> Void {
        //获得公司详情
        getCompanyDetail(dic: ["companyId":1], actionHandler: { (bassClass) in
            self.companyDetailModel = bassClass
            self.productArray = bassClass.productList!
            self.tableView.reloadData()
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
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if section == 0 {
            return 2
        }else if section == 1{
            return 3
        }else if section == 2{
            if isHaveImage == false {
                return 1
            }else{
                return 2
            }
        }else if section == 3{
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
                cell.nameLabel.text = "公司行业"
                return cell
            }else  {
                let cell = tableView.dequeueReusableCell(withIdentifier: "DefaultSelectCell") as! DefaultSelectCell
                cell.topLineLabel.isHidden = true
                cell.bottomLineLabel.isHidden = true
                cell.nameLabel.text = "公司规模"
                return cell
            }
        }else if indexPath.section == 1{
            let cell = tableView.dequeueReusableCell(withIdentifier: "DefaultSelectCell") as! DefaultSelectCell
            if indexPath.row == 0 {
                cell.topLineLabel.isHidden = true
                cell.bottomLineLabel.isHidden = true
                cell.nameLabel.text = "公司电话"
            }else if indexPath.row == 2{
                cell.topLineLabel.isHidden = true
                cell.bottomLineLabel.isHidden = true
                cell.nameLabel.text = "公司简介"
            }else{
                cell.nameLabel.text = "公司地址"
            }
            return cell
        }else if indexPath.section == 2 {
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
                    cell.imagePathArray = self.imageFileArray
                    print("cell.imagePathArray.count = \(cell.imagePathArray.count)")
                    cell.collectionView.reloadData()
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
        }else if indexPath.section == 3 {
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
                    let productModel:CompanyDetailProductList = productArray[indexPath.row]
                    
                    cell.headImage.sd_setBackgroundImage(with: NSURL.init(string: productModel.logo!) as URL!, for: UIControlState.normal)
                    
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
        if indexPath.section == 1 {
            if indexPath.row == 0 {
                //设置公司电话号码
                let vc = UIStoryboard(name: "LoginAndUserStoryboard", bundle: nil).instantiateViewController(withIdentifier: "PhoneNumVC") as! PhoneNumVC
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }else if indexPath.section == 2 {
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
            
        }else if indexPath.section == 3{
            if productArray.count == 0{
                let vc = UIStoryboard(name: "LoginAndUserStoryboard", bundle: nil).instantiateViewController(withIdentifier: "CompanyProductVC") as! CompanyProductVC
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
                    
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
            
        }
    }
    //imagePickerControllerDelegate
    func qb_imagePickerControllerDidCancel(_ imagePickerController: QBImagePickerController!) {
        self.dismiss(animated: true, completion: nil)
    }
    func qb_imagePickerController(_ imagePickerController: QBImagePickerController!, didFinishPickingAssets assets: [Any]!) {
        var index = 0
        print("asstes.count=\(assets.count)")
        //因为assets有缓存，所以每次调用需清空数组
        self.imageFileArray = []
        
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
                let imageData:Data = UIImagePNGRepresentation(image)!
                self.imageFileArray.add(imageData)
                if self.imageFileArray.count > 0 {
                    self.isHaveImage = true
                }
                 self.tableView.reloadData()
            })
        }
        print("self.imageFileArray.count=\(self.imageFileArray.count)")
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
            if isHaveImage == true {
                //需判断是哪个cell
                if indexPath.row == 0 {
                    //itemCount % 4 大于0 则不被4整除
                return CGFloat((itemCount % 4)>0 ? (itemCount/4 + 1) * 100 : itemCount/4 * 100)
                }
                return 50
            }
            return 50
            
        }else if indexPath.section == 3{
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
      return 4
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
