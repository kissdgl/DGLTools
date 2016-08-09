//
//  QRCodeManager.swift
//
//  Created by 丁贵林 on 16/8/6.
//  Copyright © 2016年 丁贵林. All rights reserved.
//

import UIKit
import AVFoundation

class QRCodeManager: NSObject {
    
    //将类设计成单例
    static let shareInstance = QRCodeManager()
    
    //定义属性
    var session : AVCaptureSession?
    var previewLayer : AVCaptureVideoPreviewLayer?

}

//MARK: - 封装生成二维码功能
extension QRCodeManager {
    
    func generateQRCode(inputMsg : String, ftImage : UIImage?, qrCodeSize : CGFloat) -> UIImage? {
        
        //1创建过滤器(滤镜) : CIQRCodeGenerator --> 创建二维码的过滤器
        let filter = CIFilter(name: "CIQRCodeGenerator")!
        
        //2给滤镜设置内容(KVC)
        let inputData = inputMsg.dataUsingEncoding(NSUTF8StringEncoding)
        filter.setValue(inputData, forKeyPath: "inputMessage")
        
        //3.设置容错率
        filter.setValue("H", forKeyPath: "inputCorrectionLevel")
        
        //4.获取生成的二维码图片
        guard let outputImage = filter.outputImage else {
            return nil
        }
        
        //5.生成高清图片
        let hdImage = createHDImage(outputImage, ratio: qrCodeSize / outputImage.extent.width)
        
        //6.判断是否有前景图片
        guard let ftImage = ftImage else {
            return hdImage
        }
        //7.获取有前景图片的二维码
        return createImageWithFtImage(hdImage, ftImage: ftImage)
    }
    
    func createHDImage(ciImage : CIImage, ratio : CGFloat) -> UIImage {
        
        //1.放大图片
        let transform = CGAffineTransformMakeScale(ratio, ratio)
        let newCIImage = ciImage.imageByApplyingTransform(transform)
        
        //2.创建UIImage对象并返回
        return UIImage(CIImage: newCIImage)
    }
    
    func createImageWithFtImage(hdImage : UIImage, ftImage : UIImage) -> UIImage {
        
        //0.获取高清图片的尺寸
        let size = hdImage.size
        
        //1.开启位图上下文
        UIGraphicsBeginImageContext(size)
        
        //2.画高清图
        hdImage.drawInRect(CGRect(origin: CGPointZero, size: size))
        
        //3.画小图
        let w : CGFloat = 60
        let h : CGFloat = 60
        let x : CGFloat = (size.width - w) * 0.5
        let y : CGFloat = (size.height - h) * 0.5
        ftImage.drawInRect(CGRectMake(x, y, w, h))
        
        //4.获取图片 从图形上下文
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        
        //5.关闭上下文
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
}


//MARK: - 识别二维码的功能
extension QRCodeManager {
    
    func detectorQRCode(image : UIImage) -> [String] {
        
        //1.将UIImage转成CIImage
        let ciImage = CIImage(image: image)
        
        //3.创建探测器
        let detector = CIDetector(ofType: CIDetectorTypeQRCode, context: nil, options: nil)
        
        //4.弹出ciImage中所有的二维码
        let resultArray = detector.featuresInImage(ciImage!)
        
        //5.遍历数据 拿到所有二维码
        var tempArray = [String]()
        
        for feature in resultArray {
            let qrCodeFeature = feature as! CIQRCodeFeature
            tempArray.append(qrCodeFeature.messageString)
        }
        
        return tempArray
    }
    
}

//MARK: - 扫描二维码
extension QRCodeManager {
    
    func startScanning(target : AVCaptureMetadataOutputObjectsDelegate?, inView : UIView) {
    
        //1.创建输入(摄像头)
        let device = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        
        guard let input = try? AVCaptureDeviceInput(device: device) else {
            print("获取摄像头异常")
            return
        }
        
        //2.创建输出(Metadata)
        let output = AVCaptureMetadataOutput()
        output.setMetadataObjectsDelegate(target, queue: dispatch_get_main_queue())
        
        //3.创建会话,联系输入和输出
        let session = AVCaptureSession()
        session.addInput(input)
        session.addOutput(output)
        output.metadataObjectTypes = [AVMetadataObjectTypeQRCode]
        self.session = session
        
        
        //4.添加预览图片
        let layer = AVCaptureVideoPreviewLayer(session: session)
        layer.frame = inView.bounds
        inView.layer.insertSublayer(layer, atIndex: 0)
        
        //5执行扫描区域
        //x/y/w/h -->比例
        let screenSize = UIScreen.mainScreen().bounds.size
        let x : CGFloat = (screenSize.height - 240) * 0.5 / screenSize.height
        let y : CGFloat = (screenSize.width - 240) * 0.5 / screenSize.width
        let w : CGFloat = 240 / screenSize.height
        let h : CGFloat = 240 / screenSize.width
        output.rectOfInterest = CGRectMake(x, y, w, h)
        
        //6.开始扫描
        session.startRunning()
    }
    
    func stopScanning() {
        session?.stopRunning()
        previewLayer?.removeFromSuperlayer()
    }
    
}