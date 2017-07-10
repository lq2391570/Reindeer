//
//  QRCodeVC.swift
//  Reindeer
//
//  Created by shiliuhua on 16/12/21.
//  Copyright © 2016年 shiliuhua. All rights reserved.
//

import UIKit
import AVFoundation
import AudioToolbox
import SVProgressHUD
class QRCodeVC: BaseViewVC,AVCaptureMetadataOutputObjectsDelegate {

    var session:AVCaptureSession!
  
    var layer:AVCaptureVideoPreviewLayer!
  
    //扫描动画
    var scanImageView:UIImageView!
    // 是否扫描完成
    var isComplete = false
    //声音
    var player : AVAudioPlayer?

    //透明背景
    @IBOutlet var bigbackgroundView: QRClearView!
    //qrView
    @IBOutlet var QRView: UIView!
    
//扫出的串码
    var scanCode = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "二维码扫描"
    // Do any additional setup after loading the view.
       
      
    }
    override func viewDidLayoutSubviews() {
        //设置扫码透明范围的尺寸
        print("QRView.frame=\(QRView.frame)")
        bigbackgroundView.smlRect = QRView.frame
      //    startQR(smlFrame: QRView.frame)
       
        
        scanAnimation()
    }
    @IBAction func qrbtnClick(_ sender: UIButton) {
        
       
    }
    //扫描动画
    func scanAnimation() -> Void {
        if isComplete == false {
            
            isComplete = true
            scanImageView = UIImageView.init(frame: CGRect.init(x: 0, y: 0, width: QRView.frame.size.width, height: 5))
            scanImageView.image = #imageLiteral(resourceName: "st_scanLine.png")
            QRView.addSubview(scanImageView)
            
            startQR(smlFrame: QRView.frame)
            UIView.beginAnimations("QRAnimation", context: nil)
            UIView.setAnimationDuration(2)
            UIView.setAnimationRepeatCount(MAXFLOAT)
            UIView.setAnimationCurve(.easeInOut)
            self.scanImageView.frame = CGRect(x: 0, y: self.QRView.frame.size.height-5, width: self.QRView.frame.size.width, height: 5)
            UIView.commitAnimations()
        
        }
    }
    
    //开始扫描
    func startQR(smlFrame:CGRect)  {
        //获取摄像设备
        let device = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        //初始化链接对象
        session = AVCaptureSession()
       
        //创建输入流
        let videoInput: AVCaptureDeviceInput?
        do {
            videoInput = try AVCaptureDeviceInput(device: device)
        } catch {
            print("没有设备")
            return
        }
        // 将 input 加入到 session 中
        if (session.canAddInput(videoInput)) {
            session.addInput(videoInput)
            
        } else {
            scanningNotPossible()
        }
        //创建输出流
        let output = AVCaptureMetadataOutput()
        //设置代理
        output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        //设置扫码的尺寸
        print("smlFrame=\(smlFrame)")
        
        // MARK:rectOfInterest方法坐标的x和y互换，默认CGRectMake(0, 0, 1, 1)在屏幕右上角
        
         output.rectOfInterest = CGRect(x: smlFrame.origin.y/ScreenHeight, y: smlFrame.origin.x/ScreenWidth, width: smlFrame.size.height/ScreenHeight, height: smlFrame.size.width/ScreenWidth)
        
        //高质量采集率
        session.sessionPreset = AVCaptureSessionPresetHigh
        
        session.addOutput(output)
        
        //设置扫码支持的编码格式（如下设置条形码和二维码兼容）
        output.metadataObjectTypes=[AVMetadataObjectTypeQRCode,AVMetadataObjectTypeEAN13Code,AVMetadataObjectTypeEAN8Code,AVMetadataObjectTypeCode128Code]
        layer = AVCaptureVideoPreviewLayer(session: session)
        layer.borderColor=UIColor.black.cgColor
        layer.borderWidth=1
        layer.videoGravity = AVLayerVideoGravityResizeAspectFill
        //设置相机框的大小
        layer.frame=CGRect.init(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        self.view.layer.insertSublayer(layer, at: 0)
        
        //开始捕获
        session.startRunning()

    }
    
    //代理实现
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [Any]!, from connection: AVCaptureConnection!) {
        print("来到代理方法")
        var zhQRCode:String? = nil
        for metadata in metadataObjects {
            if (metadata as! AVMetadataObject).type == AVMetadataObjectTypeQRCode {
                zhQRCode = (metadata as! AVMetadataMachineReadableCodeObject).stringValue
                break
            }
        }
        //动画停止
        scanImageView.layer.removeAllAnimations()
        
        //播放滴滴声
        
        playDiDiMusic()
        
        print("QR Code -- \(zhQRCode)")
         session.stopRunning()
        //判断扫出来的是什么
        if zhQRCode?.contains("xunlu") == true {
            let index = zhQRCode?.index((zhQRCode?.startIndex)!, offsetBy: 6)
            
            let qrCode = zhQRCode?.substring(from:index!)
            scanCode = zhQRCode!
            print("qrCode = \(qrCode)")
            
            scanLoginFirst(succeedClosure: { 
                let vc = QRCodeSecondVC()
                //   vc.webStr = zhQRCode!
                vc.scanCode = self.scanCode
                vc.cancelBtnClickClosure = {
                    _ = self.navigationController?.popViewController(animated: true)
                }
            self.present(vc, animated: true, completion: nil)
            })
            
         
        }
        
    }
    //扫码登录第一步
    func scanLoginFirst(succeedClosure:(() ->())?) -> Void {
        scanCodeFirst(dic: ["token":GetUser(key: TOKEN),"code":scanCode], actionHander: { (jsonStr) in
            if jsonStr["code"] == 0 {
                succeedClosure!()
            }else{
                SVProgressHUD.showInfo(withStatus: jsonStr["msg"].stringValue)
            }
        }) {
            
        }
    }

    //播放滴滴声
    func playDiDiMusic(){
       let mainBundle = Bundle.main.path(forResource: "st_noticeMusic", ofType: "wav")
        let fileUrl = NSURL(fileURLWithPath: mainBundle!)
        do{
            player = try AVAudioPlayer(contentsOf: fileUrl as URL)
        } catch {
            return
        }
        player?.prepareToPlay()
        player?.play()
        
    }
    func scanningNotPossible() {
        // 告知用户该设备无法进行条码扫描
        let alert = UIAlertController(title: "Can't Scan.", message: "Let's try a device equipped with a camera.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
        session = nil
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
