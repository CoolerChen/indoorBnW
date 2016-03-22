//
//  Equipment.swift
//  indoorB&W2
//
//  Created by Bing on 2016/3/11.
//  Copyright © 2016年 Bing. All rights reserved.
//

import UIKit

class Sup {
    static var userOrSupervisor:String = "user"
    static var login:Login?
    
    enum Status { //列舉
        case Done
        case Edit
        case QRCode
    }
    struct Supervisor { //結構
        static var supervisor:String = ""
        static var store:String = ""
        static var storeID:String = ""
        static var product:String = ""
        static var clickMode:Int = 0//判斷要去瀏覽還是去訊息
        static var productID:String = ""
        static var storeDic:Dictionary<String,String> = Dictionary<String,String>()
        static var productDic:Dictionary<String,String> = Dictionary<String,String>()
        
    }
    struct User {
        static var user:String = ""
        static var IconBadgeNumber:Int = 0 //Icon通知數字
        static var storeDic:Dictionary<String,String> = Dictionary<String,String>()
        static var storeName:String = ""
        static var storeID:String = ""
    }
    //新增Btn
    static func addBtn(VC:UIViewController,frame:CGRect,str:String,tag:Int) -> UIButton{
        let btn:UIButton = UIButton()
        btn.backgroundColor = UIColor(red: 0.36, green: 0.68, blue: 1, alpha: 0.7)
        btn.backgroundColor = UIColor(red: 0.14, green: 0.51, blue: 0.9, alpha: 0.7)
        btn.frame = frame
        btn.addTarget(VC, action: Selector("onBtnAction:"), forControlEvents: UIControlEvents.TouchUpInside)
        btn.setTitle(str, forState: UIControlState.Normal)
        btn.tag = tag
        
        btn.layer.cornerRadius = 10;
        btn.layer.masksToBounds = true;
        
        return btn
    }
    //新增textFile
    static func addTextField(VC:UITextFieldDelegate,frame:CGRect,placeholdString:String) -> UITextField{
        let textField:UITextField = UITextField()
        textField.frame = frame
        textField.text = ""
        textField.placeholder = placeholdString
        textField.font = UIFont.systemFontOfSize(textField.frame.size.height * 0.88)
        textField.textAlignment = NSTextAlignment.Center
        textField.textColor = UIColor.blackColor()
        textField.backgroundColor = UIColor.whiteColor()
        textField.borderStyle = UITextBorderStyle.RoundedRect //圓角
        textField.keyboardType = UIKeyboardType.Default  //預設的基本鍵盤
        textField.keyboardAppearance = UIKeyboardAppearance.Default  //鍵盤外觀
        textField.clearButtonMode = UITextFieldViewMode.WhileEditing //編輯時出現清除按鈕
        textField.adjustsFontSizeToFitWidth = true
        textField.delegate = VC//回傳delegate
        return textField
    }
    //彈跳視窗
    static func showAlert(VC:UIViewController,str:String){
        let alertController = MyAlert(title: str, message: nil, preferredStyle: UIAlertControllerStyle.Alert)
        let cancelAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: nil)
        alertController.addAction(cancelAction)
        VC.presentViewController(alertController, animated: true, completion: nil)
    }
    //http連線
    static func mySQL(VC:NSURLSessionDownloadDelegate,url:String,submitBody:String){
        let url:NSURL = NSURL(string: url)!
        let request: NSMutableURLRequest = NSMutableURLRequest(URL: url)
        let subBody = submitBody
        request.HTTPMethod = "POST"
        request.HTTPBody = subBody.dataUsingEncoding(NSUTF8StringEncoding)
        let conf: NSURLSessionConfiguration = NSURLSessionConfiguration.defaultSessionConfiguration()
        let session = NSURLSession(configuration: conf, delegate: VC, delegateQueue: NSOperationQueue.mainQueue())
        let dataTask = session.downloadTaskWithRequest(request)
        dataTask.resume()
    }
    //新增textView
    static func addTextView(VC:UITextViewDelegate,frame:CGRect) -> UITextView{
        let textView:UITextView = UITextView()
        textView.frame = frame
        textView.font = UIFont.systemFontOfSize(23)
        textView.layer.cornerRadius = 10
        textView.textAlignment = NSTextAlignment.Left
        textView.editable = true
        textView.clipsToBounds = true
        textView.delegate = VC
//        textView.layer.borderColor = UIColor.blueColor().CGColor
//        textView.layer.borderWidth = 4.5
        return textView
    }
    //新增ImageView
    static func addImageView(frame:CGRect) -> UIImageView {
        let imageView:UIImageView = UIImageView()
        imageView.frame = frame
        imageView.image = UIImage(named: "ibeacon.png")
        return imageView
    }
    //取得相簿  要有protocol<UINavigationControllerDelegate,UIImagePickerControllerDelegate>
    //static func tackPhoto(ViewController:UIViewController,delegeat: protocol<UINavigationControllerDelegate,UIImagePickerControllerDelegate>){
    static func PhotoLibrary(VC:UIViewController){
        var m_picker: UIImagePickerController
        m_picker = UIImagePickerController()
        if UIImagePickerController.isSourceTypeAvailable(.PhotoLibrary) {
            m_picker.sourceType = .PhotoLibrary
            m_picker.allowsEditing = true//allowsEditing允許編輯
            m_picker.delegate = VC as? protocol<UINavigationControllerDelegate,UIImagePickerControllerDelegate>
            VC.presentViewController(m_picker, animated: true, completion: { _ in })
        }
        else {
            Sup.showAlert(VC , str: "沒有相簿")
        }
    }
    //新增ScrollerView
    static func addScrollerView(VC:UIScrollViewDelegate,frame:CGRect,contentSize:CGSize) -> UIScrollView{
        let scrollerView:UIScrollView = UIScrollView()
        scrollerView.frame = frame
        scrollerView.contentSize = contentSize
        scrollerView.backgroundColor = UIColor.whiteColor()
        scrollerView.showsHorizontalScrollIndicator = false //水平的滾動指示
        scrollerView.showsVerticalScrollIndicator = true //垂直的滾動指示
        scrollerView.delegate = VC
//        scrollerView.maximumZoomScale = 5.0  //最大變焦倍數
//        scrollerView.minimumZoomScale = 1.0  //最小變焦倍數
        return scrollerView
    }
    static func addLabel(frame:CGRect,str:String) -> UILabel {
        let lab:UILabel = UILabel()
        lab.text = str
        lab.frame = frame
        lab.font = UIFont.boldSystemFontOfSize(18)
        lab.adjustsFontSizeToFitWidth = true
        lab.textColor = UIColor.whiteColor()
        return lab
    }
    //下載頭像
    static func downloadimage(url:String) -> UIImage {
        var img:UIImage = UIImage()
        let url = NSURL(string: url)
        if NSData(contentsOfURL: url!) != nil{
            img = UIImage(data: NSData(contentsOfURL: url!)!)!
        }
        return img
    }
    //改變圖片大小
    static func resizeImage(image: UIImage, newWidth: CGFloat, newHeight: CGFloat) -> UIImage {
        let scale = newWidth / image.size.width
        let newHeight = image.size.height * scale
        UIGraphicsBeginImageContext(CGSizeMake(newWidth, newHeight))
        image.drawInRect(CGRectMake(0, 0, newWidth, newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
    static func addMyImageView(frame:CGRect,Taraget:UIViewController) -> MyImageView2{
        let imageView:MyImageView2 = MyImageView2(frame: frame)
        imageView.setTarget(Taraget)
        imageView.image = UIImage(named: "ibeacon.png")
        imageView.userInteractionEnabled = true
        //imageView.backgroundColor = UIColor.lightGrayColor()
        return imageView
    }
    static func addActivityIndicatorView(frame:CGRect) -> UIActivityIndicatorView{
        let inter:UIActivityIndicatorView = UIActivityIndicatorView()
        inter.frame = frame
        inter.transform = CGAffineTransformMakeScale(7.0, 7.0)
        inter.color = UIColor.whiteColor()
        return inter
    }
    static func addView(frame:CGRect) -> UIView{
        let view:UIView = UIView()
        view.backgroundColor = UIColor.blackColor()
        view.alpha = 0.5
        view.frame = frame
        return view
    }
    
}
