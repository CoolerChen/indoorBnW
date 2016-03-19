//
//  UserQRCode.swift
//  indoorBnW
//
//  Created by Bing on 2016/3/19.
//  Copyright © 2016年 LEO. All rights reserved.
//

import UIKit
import AVFoundation

class UserQRCode: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    var captureSession: AVCaptureSession!
    var previewLayer: AVCaptureVideoPreviewLayer!
    var browseProduct:BrowseProduct?
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.whiteColor()
        
        captureSession = AVCaptureSession()
        
        let videoCaptureDevice = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        let videoInput: AVCaptureDeviceInput
        
        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            return
        }
        
        if (captureSession.canAddInput(videoInput)) {
            captureSession.addInput(videoInput)
        } else {
            failed();
            return;
        }
        
        let metadataOutput = AVCaptureMetadataOutput()
        
        if (captureSession.canAddOutput(metadataOutput)) {
            captureSession.addOutput(metadataOutput)
            
            metadataOutput.setMetadataObjectsDelegate(self, queue: dispatch_get_main_queue())
            metadataOutput.metadataObjectTypes = [AVMetadataObjectTypeQRCode]
        } else {
            failed()
            return
        }
        
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession);
        previewLayer.frame = CGRectMake(0, 100, self.view.frame.size.width, 400)
        previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
        view.layer.addSublayer(previewLayer);
        
        captureSession.startRunning();
    }
    
    func failed() {
        let ac = UIAlertController(title: "Scanning not supported", message: "Your device does not support scanning a code from an item. Please use a device with a camera.", preferredStyle: .Alert)
        ac.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
        presentViewController(ac, animated: true, completion: nil)
        captureSession = nil
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.title = "掃描QRCode"
        
        if (captureSession?.running == false) {
            captureSession.startRunning();
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        if (captureSession?.running == true) {
            captureSession.stopRunning();
        }
    }
    
    func captureOutput(captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [AnyObject]!, fromConnection connection: AVCaptureConnection!) {
        captureSession.stopRunning()
        
        if let metadataObject = metadataObjects.first {
            let readableObject = metadataObject as! AVMetadataMachineReadableCodeObject;
            
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            foundCode(readableObject.stringValue);
        }
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func foundCode(code: String) {
        //取得後會做的方法
        //在這邊這定storeID與跳轉頁面
        
        if browseProduct == nil{
            browseProduct = BrowseProduct()
        }
        Sup.Supervisor.storeDic["storeName"] = code.componentsSeparatedByString("::")[1].urlDecoded()
        Sup.Supervisor.storeDic["storeSlogan"] = code.componentsSeparatedByString("::")[2].urlDecoded()
        Sup.Supervisor.storeDic["storeLogo"] = code.componentsSeparatedByString("::")[3].urlDecoded()
        Sup.Supervisor.storeDic["storeCategory"] = code.componentsSeparatedByString("::")[4].urlDecoded()
        Sup.User.storeID = code.componentsSeparatedByString("::")[0]
        self.navigationController?.pushViewController(browseProduct!, animated: true)
        browseProduct?.downloadProduct()
        
        //從QRCode跳轉過去會沒有detail
        //畫面回來取消QRCode 
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return .Portrait
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
   
}
