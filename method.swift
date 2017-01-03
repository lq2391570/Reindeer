//
//  method.swift
//  WerwolfKill
//
//  Created by shiliuhua on 16/12/9.
//  Copyright © 2016年 shiliuhua. All rights reserved.
//

import Foundation
import UIKit
import SVProgressHUD


var ScreenWidth = UIScreen.main.bounds.size.width
var ScreenHeight = UIScreen.main.bounds.size.height


//Userdefault(存)
func SetUser(value:String,key:String) -> Void {
    return UserDefaults.standard.set(value, forKey: key)
}
//Userdefault(取)
func GetUser(key:String) -> String {
//    if (UserDefaults.standard.value(forKey: key) != nil) {
//        return UserDefaults.standard.value(forKey: key) as! String
//    }else{
//        return ""
//    }
    
    let value :String
    value = (UserDefaults.standard.value(forKey: key) as! String?) ?? ""
    return value
    
}

//创建一个alertView
func createAlert(title:String?,message:String?,viewControll:ViewController,closure:@escaping ()->Void){
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    let ac1 = UIAlertAction(title: "确定", style: .default, handler:{ action in
        closure()
    })
    
    alert.addAction(ac1)
    viewControll.present(alert, animated: true, completion: nil)
}
//创建一个带一个输入框的alertView
func createAlertWithTextField(title:String?,message:String?,viewControll:UIViewController,closure:@escaping (_ text:String?)->Void){
    let alert=UIAlertController(title: title, message: message, preferredStyle: .alert)
    let ac1 = UIAlertAction(title: "确定", style: .default, handler:{ action in
           closure(alert.textFields?[0].text)
    })
    
    let ac2 = UIAlertAction(title: "取消", style: .cancel, handler: { action in
        
    })
    
    alert.addTextField(configurationHandler: { text in
        
    })
    
    alert.addAction(ac1)
    alert.addAction(ac2)
     viewControll.present(alert, animated: true, completion: nil)
    
}

//func colorWithHexColorString(hexColorString:String) -> UIColor{
//    if hexColorString.characters.count < 6 { //长度不合法
//        return UIColor.black
//    }
//    var tempString = hexColorString.lowercased()
//    if tempString.hasPrefix("0x") { //检测开头是0x
//      tempString = tempString.substring(from: tempString.index(tempString.startIndex, offsetBy: 2))
//    }else if tempString.hasPrefix("#"){//检测开头是#
//        tempString = tempString.substring(from: tempString.index(tempString.startIndex, offsetBy: 1))
//    }
//    if tempString.characters.count != 6 {
//        return UIColor.black
//    }
//    //分解三种颜色的值
//    let range1 = tempString.startIndex..<tempString.index(tempString.startIndex, offsetBy: 2)
//    let range2 = tempString.index(tempString.startIndex, offsetBy: 2)..<tempString.index(tempString.startIndex, offsetBy: 2)
//    let range3 = tempString.index(tempString.startIndex, offsetBy: 4)..<tempString.index(tempString.startIndex, offsetBy: 2)
//    
//    let rString = tempString.substring(with: range1)
//    let gString = tempString.substring(with: range2)
//    let bString = tempString.substring(with: range3)
//    
//    
//    
//    
//    
//    
//    
//}
extension UIColor {
    
    /// 用十六进制颜色创建UIColor
    ///
    /// - Parameter hexColor: 十六进制颜色 (0F0F0F)
    convenience init(hexColor: String) {
        
        // 存储转换后的数值
        var red:UInt32 = 0, green:UInt32 = 0, blue:UInt32 = 0
            let range1 = hexColor.startIndex..<hexColor.index(hexColor.startIndex, offsetBy: 2)
            let range2 = hexColor.index(hexColor.startIndex, offsetBy: 2)..<hexColor.index(hexColor.startIndex, offsetBy: 4)
            let range3 = hexColor.index(hexColor.startIndex, offsetBy: 4)..<hexColor.index(hexColor.startIndex, offsetBy: 6)
        
            let rString = hexColor.substring(with: range1)
            let gString = hexColor.substring(with: range2)
            let bString = hexColor.substring(with: range3)
        // 分别转换进行转换
        Scanner(string: rString).scanHexInt32(&red)
        
        Scanner(string: gString).scanHexInt32(&green)
        
        Scanner(string: bString).scanHexInt32(&blue)
        
        self.init(red: CGFloat(red)/255.0, green: CGFloat(green)/255.0, blue: CGFloat(blue)/255.0, alpha: 1.0)
    }
}

