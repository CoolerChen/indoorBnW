//
//  EditProduct.swift
//  indoorB&W2
//
//  Created by Bing on 2016/3/11.
//  Copyright © 2016年 Bing. All rights reserved.
//

import UIKit

class EditProduct: UIViewController,UITextFieldDelegate,NSURLSessionDownloadDelegate ,UINavigationControllerDelegate,UIImagePickerControllerDelegate {
    var textFieldAry:[UITextField] = [UITextField]()
//    var productDic:Dictionary<String,String>!
    var product:Product?
    var imageView:UIImageView = UIImageView()
    var productGoEdit:Bool!
    var productGoPhoto:Bool!
    var acti:UIActivityIndicatorView = UIActivityIndicatorView()
    var actiView:UIView = UIView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()

        let textFieldW:CGFloat = 250
        let textFieldH:CGFloat = 40
        let textFieldtext:[String] = ["商品名稱","商品簡介","價格"]
        let Fieldtext:[String] = [Sup.Supervisor.productDic["productName"]!,Sup.Supervisor.productDic["productInfo"]!,Sup.Supervisor.productDic["productPrice"]!]
        for var i:CGFloat = 0;i < 3 ; i++ {
            textFieldAry.append(Sup.addTextField(self, frame: CGRectMake(self.view.frame.size.width/2-textFieldW/2, 45.0 * i + 80.0, textFieldW, textFieldH), placeholdString: textFieldtext[Int(i)]))
            self.view.addSubview(textFieldAry[Int(i)])
            textFieldAry[Int(i)].text = Fieldtext[Int(i)]
        }
        let img:UIImage = UIImage()
        //imageView = Sup.addImageView(CGRectMake(self.view.frame.size.width/2-textFieldW/2, (textFieldAry.last?.frame.origin.y)! + 55, textFieldW, textFieldW), img: img)
        imageView = Sup.addMyImageView(CGRectMake(self.view.frame.size.width/2-textFieldW/2, (textFieldAry.last?.frame.origin.y)! + 55, textFieldW, textFieldW), Taraget: self, img: img)
        self.view.addSubview(imageView)
        
        //選擇圖片
        //self.view.addSubview(Sup.addBtn(self, frame: CGRectMake(self.view.frame.size.width/2-textFieldW/2, imageView.frame.origin.y + textFieldW + 10, textFieldW, textFieldH), str: "選擇圖片", tag: 1))
        
        //送出
        self.view.addSubview(Sup.addBtn(self, frame: CGRectMake(self.view.frame.size.width/2-textFieldW/2, imageView.frame.origin.y + textFieldW + 60, textFieldW, textFieldH), str: "送出", tag: 2))
        //刪除
        self.view.addSubview(Sup.addBtn(self, frame: CGRectMake(self.view.frame.size.width/2-textFieldW/2, imageView.frame.origin.y + textFieldW + 110, textFieldW, textFieldH), str: "刪除", tag: 3))
        productGoPhoto = false
        
    }
    func onBtnAction(sender:UIButton){
        actiView = Sup.addView(self.view.frame)
        self.view.addSubview(actiView)
        acti = Sup.addActivityIndicatorView(self.view.frame)
        acti.startAnimating()
        self.view.addSubview(acti)
//        if sender.tag == 1{//選擇圖片
//            Sup.PhotoLibrary(self)
//            productGoPhoto = true
//        }else
        if sender.tag == 2{//送出
            //改變圖片資料
            Sup.mySQL(self, url: "http://bing0112.100hub.net/bing/EditProduct.php", submitBody: "productBySupervisor=\(Sup.Supervisor.productDic["productBySupervisor"]!)&productByStore=\(Sup.Supervisor.productDic["productByStore"]!)&productName=\(textFieldAry[0].text!)&productType=熱褲&productInfo=\(textFieldAry[1].text!)&productPrice=\(textFieldAry[2].text!)&productImage=\(Sup.Supervisor.productID).jpg&oldProductName=\(Sup.Supervisor.productDic["productName"]!)")
            //上傳圖片
            let uploadimage:UploadImage = UploadImage()
            uploadimage.myImageUploadRequest("http://bing0112.100hub.net/bing/productUploadImage.php", img: imageView.image!, fileName: Sup.Supervisor.productID)
            
            
        }else if sender.tag == 3 {//刪除
            let alertController = UIAlertController(title: "確定刪除？", message: nil, preferredStyle: UIAlertControllerStyle.Alert)
            let agreeAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) { (UIAlertAction) -> Void in
                Sup.mySQL(self, url: "http://bing0112.100hub.net/bing/deleteProduct.php", submitBody: "productBySupervisor=\(Sup.Supervisor.productDic["productBySupervisor"]!)&productByStore=\(Sup.Supervisor.productDic["productByStore"]!)&productName=\(Sup.Supervisor.productDic["productName"]!)")
            }
            let calAction = UIAlertAction(title: "NO", style: UIAlertActionStyle.Cancel, handler: nil)
            alertController.addAction(agreeAction)
            alertController.addAction(calAction)
            self.presentViewController(alertController, animated: true, completion: nil)
        }
    }
    //圖片被按下
    func handleLongPressFrom(longPressRecognizer:UILongPressGestureRecognizer){
        if longPressRecognizer.state == UIGestureRecognizerState.Began{
            
        }else if longPressRecognizer.state == UIGestureRecognizerState.Changed{
            
        }else if longPressRecognizer.state == UIGestureRecognizerState.Ended || longPressRecognizer.state == UIGestureRecognizerState.Cancelled{
            Sup.PhotoLibrary(self)
            productGoPhoto = true
        }
    }
    //取得echo回來的值
    func URLSession(session: NSURLSession, downloadTask: NSURLSessionDownloadTask, didFinishDownloadingToURL location: NSURL) {
        let resp = String(data: NSData(contentsOfURL: location)!, encoding: NSUTF8StringEncoding)
        print("resp: \(resp!)")
        if resp! == "修改成功"{
            Sup.showAlert(self, str: "修改成功")
            Sup.mySQL(product!, url: "http://bing0112.100hub.net/bing/product.php", submitBody: "productByStore=\(Sup.Supervisor.productDic["productByStore"]!)&productBySupervisor=\(Sup.Supervisor.productDic["productBySupervisor"]!)")
        }else if resp! == "刪除成功"{
            let alertController = UIAlertController(title: "刪除成功", message: nil, preferredStyle: UIAlertControllerStyle.Alert)
            let agreeAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: { (UIAlertAction) -> Void in
                self.navigationController?.popToViewController(self.product!, animated: true)
            })
            alertController.addAction(agreeAction)
            self.presentViewController(alertController, animated: true, completion: nil)
            Sup.mySQL(product!, url: "http://bing0112.100hub.net/bing/product.php", submitBody: "productByStore=\(Sup.Supervisor.productDic["productByStore"]!)&productBySupervisor=\(Sup.Supervisor.productDic["productBySupervisor"]!)")
        }else {
            Sup.showAlert(self, str: "網路不穩")
        }
        actiView.hidden = true
        acti.stopAnimating()
    }
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        
        imageView.image = Sup.resizeImage(image, newWidth: 250.0, newHeight: 250.0)
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    override func viewDidAppear(animated: Bool) {
        //print("\(productDic)")
        
        if (productGoEdit == true) {
            //此段要包在product進來才做
            let Fieldtext:[String] = [Sup.Supervisor.productDic["productName"]!,Sup.Supervisor.productDic["productInfo"]!,Sup.Supervisor.productDic["productPrice"]!,Sup.Supervisor.productDic["productImage"]!]
            for var i = 0;i<textFieldAry.count;i++ {
                textFieldAry[Int(i)].text = Fieldtext[Int(i)]
            }
            imageView.image = Sup.downloadimage("http://bing0112.100hub.net/bing/ProductImage/\(Sup.Supervisor.productDic["productID"]!).jpg")
            productGoEdit = false
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    override func viewDidDisappear(animated: Bool) {
        //去取照片不用進來
        if productGoPhoto == false {
            for var i = 0;i<textFieldAry.count;i++ {
                textFieldAry[Int(i)].text = ""
            }
            imageView.image = nil

        }
    }
    //鍵盤中return那個案件
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        //收回鍵盤
        textField.resignFirstResponder()
        return true
    }
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for var i = 0 ; i < textFieldAry.count ;i++ {
            textFieldAry[i].resignFirstResponder()
        }
        
    }
}
