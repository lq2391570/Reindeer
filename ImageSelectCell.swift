//
//  ImageSelectCell.swift
//  Reindeer
//
//  Created by shiliuhua on 17/2/13.
//  Copyright © 2017年 shiliuhua. All rights reserved.
//

import UIKit

class ImageSelectCell: UITableViewCell,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {

    @IBOutlet var collectionView: UICollectionView!
    
    var imagePathArray:[String] = []
    //点击添加按钮闭包
    var addBtnClickClosure:((_ btn:UIButton) -> ())?
    //点击图片按钮闭包
    var imageBtnClickClosure:((UIButton) -> ())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 15
        layout.minimumLineSpacing = 15
        //缩进
        layout.sectionInset = UIEdgeInsetsMake(15, 15, 15, 15)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.collectionViewLayout = layout
        collectionView.register(UINib.init(nibName: "ImageCollectionCell", bundle: nil), forCellWithReuseIdentifier: "ImageCollectionCell")
        print("collectionView.contentSize=\(collectionView.contentSize)")
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        let size = CGSize(width: 70, height: 70)
        return size
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return imagePathArray.count + 1
       
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCollectionCell", for: indexPath) as! ImageCollectionCell
       
        cell.imageBtn.tag = indexPath.row
        cell.imageBtn.removeTarget(self, action: #selector(imageBtnClick(btn:)), for: .touchUpInside)
        cell.imageBtn.removeTarget(self, action: #selector(addImageBtnClick(btn:)), for: .touchUpInside)
        cell.imageBtn.setBackgroundImage(UIImage.init(named: "上传照片_38.png"), for: .normal)
        
        if indexPath.row != imagePathArray.count {
//        cell.imageBtn.setBackgroundImage(UIImage.init(data: imagePathArray.object(at: indexPath.row) as! Data), for: .normal)
     //   cell.imageBtn.setBackgroundImage(UIImage.init(contentsOfFile: imagePathArray.object(at: indexPath.row) as! String), for: .normal)
       //  cell.imageBtn.sd_setBackgroundImage(with: imagePathArray.object(at: indexPath.row) as! URL, for: .normal)
            
            
       // cell.imageBtn.sd_setBackgroundImage(with: URL.init(string: imagePathArray.object(at: indexPath.row) as! String), for: .normal)
            
           // cell.imageBtn.sd_setBackgroundImage(with: URL.init(string: imagePathArray[indexPath.row]), for: .normal)
            
            cell.imageBtn.sd_setBackgroundImage(with: URL.init(string: imagePathArray[indexPath.row]), for: .normal)
            
            print("imagePath = \(imagePathArray[indexPath.row])")
            
        cell.imageBtn.addTarget(self, action: #selector(imageBtnClick(btn:)), for: .touchUpInside)
        }else{
        cell.imageBtn.addTarget(self, action: #selector(addImageBtnClick(btn:)), for: .touchUpInside)
        }
        
        return cell
    }
    
    //图片按钮点击
    func imageBtnClick(btn:UIButton) -> Void {
        //图片按钮点击
        print("图片点击")
        if (imageBtnClickClosure != nil) {
            imageBtnClickClosure! (btn)
        }
    }
    //添加按钮点击
    func addImageBtnClick(btn:UIButton) -> Void {
        //添加按钮点击
        print("添加按钮点击")
        if (addBtnClickClosure != nil) {
            addBtnClickClosure!(btn)
        }
        
    }
    
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
