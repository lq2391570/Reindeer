//
//  method.swift
//  WerwolfKill
//
//  Created by shiliuhua on 16/12/9.
//  Copyright © 2016年 shiliuhua. All rights reserved.
//

import Foundation
import UIKit

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


