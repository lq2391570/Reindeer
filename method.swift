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
let TOKEN = "token"
let PHONENUM = "phone"
let PASSWORD = "password"
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
//创建一个actionSheet
func createActionSheet(title:String,message:String,stringArray:[String],viewController:UIViewController,closure:@escaping ((_ indexNum:Int) ->Void))
{
    let alert = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
    
    for str in stringArray {
   
        let ac = UIAlertAction(title: str, style: .default, handler: { (action) in
            //获得字符串索引
            let index = stringArray.index(of: str)
            
            closure (index!)
        })
        alert.addAction(ac)
        
    }
    let cancelAc = UIAlertAction(title: "返回", style: .cancel, handler: { (action) in
        
    })
    alert.addAction(cancelAc)

    viewController.present(alert, animated: true, completion: nil)
    
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
    class var mainColor: UIColor {
        return UIColor.init(hexColor: "f4cda2")
    }
    
}


//    - (NSDate *)dateByAddingDays:(NSInteger)days {
//    NSTimeInterval aTimeInterval = [self timeIntervalSinceReferenceDate] + 86400 * days;
//    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
//    return newDate;
//    }

    
//时间增加
func dateByAddingDays(days:NSInteger) -> NSDate {
    let date = NSDate()
    
    let aTimeInterval:TimeInterval = date.timeIntervalSinceReferenceDate + (86400*Double(days))
    let newDate = NSDate.init(timeIntervalSinceReferenceDate: aTimeInterval)
    
    return newDate
    
}



func typeForImageData(data:NSData) -> String? {
    var c = uint_fast8_t()
    
    data.getBytes(&c, length: 1)
    switch c {
    case 0xFF:
        return "image/jpeg"
    case 0x89:
        return "image/png"
    case 0x47:
        return "image/gif"
    case 0x4D:
        return "image/tiff"
        
    default:
        break
    }
    return nil
}
//延迟执行

typealias Task = (_ cancel : Bool) -> Void

func delay(_ time: TimeInterval, task: @escaping ()->()) ->  Task? {
    
    func dispatch_later(block: @escaping ()->()) {
        let t = DispatchTime.now() + time
        DispatchQueue.main.asyncAfter(deadline: t, execute: block)
    }
    var closure: (()->Void)? = task
    var result: Task?
    
    let delayedClosure: Task = {
        cancel in
        if let internalClosure = closure {
            if (cancel == false) {
                DispatchQueue.main.async(execute: internalClosure)
            }
        }
        closure = nil
        result = nil
    }
    
    result = delayedClosure
    
    dispatch_later {
        if let delayedClosure = result {
            delayedClosure(false)
        }
    }
    return result
}

func cancel(_ task: Task?) {
    task?(true)
}

//时间转化为时间戳
func dateTransformUnixStr(date:Date) ->String
{
    let timeInterval:TimeInterval = date.timeIntervalSince1970*1000
    let timeString:String = String(format: "%0.f",timeInterval)
    print("timeString = \(timeString)")
    return timeString
}
//时间戳转化为时间(格式自定义)
func unixTransformtimeStr(unixStr:NSNumber,dateStyle:String) ->String
{
    let unixTimeStamp:Double = Double.init(unixStr)/1000
    let interval:TimeInterval = unixTimeStamp
    let date:Date = Date.init(timeIntervalSince1970: interval)
    let formatter = DateFormatter()
    formatter.locale = NSLocale.current
    formatter.dateFormat = dateStyle
    let dateStr = formatter.string(from: date)
    return dateStr
    
}


//创建底部Btn(保存按钮)
func createBottomBtn(supView:UIView,title:String,actionHander:(_ sender:UIButton) -> Void) -> UIView {
    let view = UIView(frame: CGRect.init(x: 0, y: 0, width: supView.frame.size.width, height: 60))
    view.backgroundColor = UIColor.clear
    let btn = UIButton(type: .custom)
    btn.frame = CGRect.init(x: 20, y: 10, width: supView.frame.size.width - 40, height: 40)
    btn.backgroundColor = UIColor.black
    btn.setTitle(title, for: .normal)
  
    btn.setTitleColor(UIColor.mainColor, for: .normal)
    view.addSubview(btn)
    actionHander(btn)
    
    return view
}

//时间转化（时间的字符串转化为时间戳）
func timeStrTransformUnix(timeStr:String) ->String
{
    let inputFormatter = DateFormatter()
    inputFormatter.dateFormat = "yyyyMMddHHmm"
    let inputDate:Date = inputFormatter.date(from: timeStr)!
    return dateTransformUnixStr(date: inputDate)
}





