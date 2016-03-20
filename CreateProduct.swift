//
//  CreateProduct.swift
//  indoorB&W2
//
//  Created by Bing on 2016/3/5.
//  Copyright © 2016年 Bing. All rights reserved.
//

import UIKit

class CreateProduct: UIViewController,UITextFieldDelegate,NSURLSessionDownloadDelegate,UIScrollViewDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate {
    
    var textFieldAry:[UITextField] = [UITextField]()
    var product:Product?
    var imageView:UIImageView = UIImageView()
    
    var bol:Bool = true
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()

        print("\(Sup.Supervisor.supervisor) 的 \(Sup.Supervisor.store) 商店" )
        
        let scorll = Sup.addScrollerView(self, frame: self.view.frame, contentSize:CGSizeMake(self.view.frame.size.width, 10000) )
        self.view.addSubview(scorll)
        
        let textFieldW:CGFloat = 250
        let textFieldH:CGFloat = 40
        let textFieldtext:[String] = ["商品名稱","商品簡介","價格"]
        for var i:CGFloat = 0;i < 3 ; i++ {
            textFieldAry.append(Sup.addTextField(self, frame: CGRectMake(self.view.frame.size.width/2-textFieldW/2, 45.0 * i + 5.0, textFieldW, textFieldH), placeholdString: textFieldtext[Int(i)]))
            scorll.addSubview(textFieldAry[Int(i)])
        }
        scorll.addSubview(Sup.addBtn(self, frame: CGRectMake(self.view.frame.size.width/2-textFieldW/2, textFieldAry[2].frame.origin.y + 45, textFieldW, textFieldH), str: "選擇圖片", tag: 0))
        let img:UIImage = UIImage()
        imageView = Sup.addImageView(CGRectMake(self.view.frame.size.width/2-textFieldW/2, textFieldAry[2].frame.origin.y + 90, textFieldW, textFieldW), img: img)
        scorll.addSubview(imageView)
        
        
        //送出
        scorll.addSubview(Sup.addBtn(self, frame: CGRectMake(self.view.frame.size.width/2-textFieldW/2, imageView.frame.origin.y + textFieldW + 10, textFieldW, textFieldH), str: "送出", tag: 1))
        scorll.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height+1)
    }
    func onBtnAction(sender:UIButton){
        switch sender.tag {
        case 0:
            Sup.PhotoLibrary(self)
            bol = false
        case 1:
            if textFieldAry[0].text == "" {
                Sup.showAlert(self, str: "請輸入商品名稱")
                return
            }
            Sup.mySQL(self, url: "http://bing0112.100hub.net/bing/CreateProduct.php", submitBody: "productBySupervisor=\(Sup.Supervisor.supervisor)&productByStore=\(Sup.Supervisor.storeID)&productName=\(textFieldAry[0].text!)&productType=分類&productInfo=\(textFieldAry[1].text!)&productPrice=\(textFieldAry[2].text!)&productImage=圖")
        default:
            break
        }
        
        
    }
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        bol = true
        imageView.image = Sup.resizeImage(image, newWidth: 250.0, newHeight: 250.0)
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //取得echo回來的值
    func URLSession(session: NSURLSession, downloadTask: NSURLSessionDownloadTask, didFinishDownloadingToURL location: NSURL) {
        let resp = String(data: NSData(contentsOfURL: location)!, encoding: NSUTF8StringEncoding)
        print("resp: \(resp!)")
        
        
        
        if resp! == ""{
            Sup.showAlert(self, str: "網路不穩")
            return
        }else if resp! == "商品名字重複"{
            Sup.showAlert(self, str: "商品重複")
            return
        }else if resp!.componentsSeparatedByString("::")[0] == "新增成功"{
            Sup.showAlert(self, str: "新增成功")
            for var i = 0 ; i < textFieldAry.count ;i++ {
                textFieldAry[i].text = ""
            }
            Sup.mySQL(product!, url: "http://bing0112.100hub.net/bing/product.php", submitBody: "productByStore=\(Sup.Supervisor.storeID)&productBySupervisor=\(Sup.Supervisor.supervisor)")
            //上傳成功後取得productID 
//            再把圖片丟上去
            
            Sup.Supervisor.productID = resp!.componentsSeparatedByString("::")[1]
            
            //上傳檔案呼叫此物件實體執行物件方法
            let uploadimage:UploadImage = UploadImage()
            uploadimage.myImageUploadRequest("http://bing0112.100hub.net/bing/productUploadImage.php", img: imageView.image!, fileName: Sup.Supervisor.productID)
            
        }
        
    }
    override func viewDidDisappear(animated: Bool) {
        if bol{
            for var i = 0 ; i < textFieldAry.count ;i++ {
                textFieldAry[i].text = ""
            }
            imageView.image = nil
        }
    }
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for var i = 0;i<textFieldAry.count;i++ {
            textFieldAry[i].resignFirstResponder()
        }
        
    }
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        for var i = 0;i<textFieldAry.count;i++ {
            textFieldAry[i].resignFirstResponder()
        }
    }
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        for var i = 0;i<textFieldAry.count;i++ {
            textFieldAry[i].resignFirstResponder()
        }
    }
    
}

