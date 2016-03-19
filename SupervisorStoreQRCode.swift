//
//  SupervisorStoreQRCode.swift
//  indoorBnW
//
//  Created by Bing on 2016/3/19.
//  Copyright © 2016年 LEO. All rights reserved.
//

import UIKit

class SupervisorStoreQRCode: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.blackColor()
    }
    override func viewDidAppear(animated: Bool) {
        setQRCode()
        self.navigationItem.title = "\(Sup.Supervisor.storeDic["storeName"]!)的QRCode"
        print(Sup.Supervisor.storeDic["storeID"]!)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    //設定顯示QRCode
    func setQRCode(){
        var qrcodeImage:CIImage
        let imgQRCode:UIImageView = UIImageView()
        imgQRCode.frame = CGRectMake(self.view.frame.size.width/2-125, self.view.frame.size.height/2-125, 250, 250)
        
        
        let textField:UITextField = UITextField()
        textField.text = Sup.Supervisor.storeDic["storeID"]!
        
        let data = textField.text!.dataUsingEncoding(NSISOLatin1StringEncoding, allowLossyConversion: false)
        
        let filter = CIFilter(name: "CIQRCodeGenerator")
        
        filter!.setValue(data, forKey: "inputMessage")
        filter!.setValue("Q", forKey: "inputCorrectionLevel")
        
        qrcodeImage = filter!.outputImage!
        
        let transformedImage = qrcodeImage.imageByApplyingTransform(CGAffineTransformMakeScale(imgQRCode.frame.size.width / qrcodeImage.extent.size.width, imgQRCode.frame.size.height / qrcodeImage.extent.size.height))
        
        imgQRCode.image = UIImage(CIImage: transformedImage)
        
        self.view.addSubview(imgQRCode)
        
    }

}
