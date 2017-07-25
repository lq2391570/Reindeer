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
import JCAlertView
//import NIMSDK
import MJRefresh


var ScreenWidth = UIScreen.main.bounds.size.width
var ScreenHeight = UIScreen.main.bounds.size.height
let TOKEN = "token"
let PHONENUM = "phone"
let PASSWORD = "password"
let COMPANYID = "companyId"
let HRPOSITION = "HRPosition"
//网易云Token
let NETTOKEN = "netToken"
//user信息
let USERMES = "USERMES"


//let ViewBorderRadius

//设置圆角
func ViewBorderRadius(view:UIView,radius:CGFloat,width:CGFloat?,color:UIColor?)
{
    view.layer.cornerRadius = radius
    view.layer.masksToBounds = true
    if width != nil {
        view.layer.borderWidth = width!
    }
    if color != nil {
        view.layer.borderColor = color!.cgColor
    }
    
}

//旋转

func overturnReturnImage(view:UIView,degress:CGFloat) -> Void {
    view.layer.transform = CATransform3DMakeRotation(radians(degress: degress), 0, 0, 1);
}
func radians(degress:CGFloat) -> CGFloat {
    return (degress * 3.14159265) / 180.0;
}


//Userdefault(存)
func SetUser(value:Any,key:String) -> Void {
    UserDefaults.standard.set(value, forKey: key)
    UserDefaults.standard.synchronize()
}
//Userdefault(取)
func GetUser(key:String) -> Any {
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
func createAlert(title:String?,message:String?,viewControll:UIViewController,closure:@escaping ()->Void){
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    let ac1 = UIAlertAction(title: "确定", style: .default, handler:{ action in
        closure()
    })
    alert.addAction(ac1)
    let ac2 = UIAlertAction(title: "取消", style: .cancel) { (action) in
        
    }
    alert.addAction(ac2)
    viewControll.present(alert, animated: true, completion: nil)
}
//创建一个alertView(一个按钮)
func createAlertOneBtn(title:String?,message:String?,btnStr:String?,viewControll:UIViewController,closure:(()->Void)?){
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    let ac1 = UIAlertAction(title: btnStr, style: .default, handler:{ action in
        if closure != nil {
             closure!()
        }
       
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

//时间转化为时间戳(13位)
func dateTransformUnixStr(date:Date) ->String
{
    let timeInterval:TimeInterval = date.timeIntervalSince1970*1000
    let timeString:String = String(format: "%0.f",timeInterval)
    print("timeString = \(timeString)")
    return timeString
}
////时间转化为时间戳(10位)
//func dateTransformUnixStr(date:Date) ->String
//{
//    let timeInterval:TimeInterval = date.timeIntervalSince1970*1000
//    let timeString:String = String(format: "%0.f",timeInterval)
//    print("timeString = \(timeString)")
//    return timeString
//}
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
    let view = UIView(frame: CGRect.init(x: 0, y: 0, width: ScreenWidth, height: 60))
    view.backgroundColor = UIColor.init(red: 246/255.0, green: 246/255.0, blue: 246/255.0, alpha: 1)
    
    let btn = UIButton(type: .custom)
  //  btn.frame = CGRect.init(x: 20, y: 10, width: view.frame.size.width - 40 , height: 40)
  //  btn.center = CGPoint.init(x: view.center.x, y: v)
    btn.backgroundColor = UIColor.black
    btn.setTitle(title, for: .normal)
  
    btn.setTitleColor(UIColor.mainColor, for: .normal)
    
    view.addSubview(btn)
    actionHander(btn)
    print("view.frame.size.width=\(view.frame.size.width)")
    print("ScreenWidth = \(ScreenWidth)")
    btn.snp.makeConstraints { (make) in
        make.left.equalTo(view.snp.left).offset(20)
        make.right.equalTo(view.snp.right).offset(-20)
       make.height.equalTo(40)
    }
    
    
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
//创建一个自定义pickView
func createLQPickView(dataArray1:[String],dataArray2:[String]?,numOfComponents:Int,title:String?,sureBtnClickClosure:((UIButton,_ selectNum1:Int?,_ selectNum2:Int?) -> ())?,cancelBtnClickClosure:((UIButton) -> ())?) -> JCAlertView
{
     let customView = LQPickCustomView.newInstance()
        customView?.dataArray1.removeAll()
        let customAlert = JCAlertView.init(customView: customView, dismissWhenTouchedBackground: false)
        customView?.dataArray1 = dataArray1
        customView?.dataArray2 = dataArray2 ?? ["无"]
        customView?.numOfComponents = numOfComponents
        customAlert?.center = CGPoint.init(x: ScreenWidth/2, y: ScreenHeight - (customView?.frame.size.height)!/2-20)
        customView?.titleLabel.text = title
        customView?.cancelbtnClickClosure = cancelBtnClickClosure
//        customView.cancelbtnClickClosure = { (btn) in
//            customAlert?.dismiss(completion: nil)
//        }
        customView?.sureBtnClickclosure = sureBtnClickClosure
//        customView.sureBtnClickclosure = { (btn,selectNum1,selectNum2) in
//            customAlert?.dismiss(completion: nil)
//        }
        customAlert?.show()
    return customAlert!
    
}
//下拉刷新及上拉更多
func setUpMJHeader(refreshingClosure:(() ->())?) -> MJRefreshGifHeader {
    let header = MJRefreshGifHeader { 
         refreshingClosure!()
    }
    header?.lastUpdatedTimeLabel.isHidden = true
    header?.stateLabel.isHidden = true
    var gifImageArray:[UIImage] = []
    for index in 0...29 {
        let str = "roll\(index).png"
        print("str = \(str)")
        gifImageArray.append(UIImage.init(named: str)!)
    }
    header?.setImages(gifImageArray, duration: 0.5, for: .refreshing)
    return header!
}
func setUpMJFooter(refreshingClosure:(() ->())?) -> MJRefreshAutoNormalFooter {
    let footer = MJRefreshAutoNormalFooter { 
        refreshingClosure!()
    }
    
    return footer!
}




