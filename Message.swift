//
//  SupervisorCreateMessage.swift
//  indoorBNWtestMessage
//
//  Created by LEO on 2016/3/9.
//  Copyright © 2016年 LEO. All rights reserved.
//

import UIKit

class Message: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, NSURLSessionDownloadDelegate, UITextFieldDelegate {
    let scrollviewBackColor = UIColor(red: 154/255.0, green: 208/255.0, blue: 248/255.0, alpha: 1)
    let textBackgroundColor = UIColor(red: 209/255.0, green: 235/255.0, blue: 254/255.0, alpha: 1)
    var json = []
    
    var uploadMode = ""
    
    let indicator=UIActivityIndicatorView()
    var getWhatData:String = ""
    var imageFileName:String = ""
    var messageGoPhoto:Bool!
    
    let viewStartY=CGFloat(64)
    var usedHeight:Int = 0
    //    var storeTableView:UITableView!
    var scrollView:UIScrollView!
    var segm:UISegmentedControl!
    var storeLabel:UILabel!
    var titleTextField:UITextField!
    var subtitleTextField:UITextField!
    var contentTextView:UITextView!
    var imageImageView:UIImageView!
    var uploadButton:UIButton!
    
    var msgActiView:UIView = UIView()
    var msgActi:UIActivityIndicatorView = UIActivityIndicatorView()
    
    //MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        print("viewDidLoad")
        
        messageGoPhoto = false
        
        init_Setting()
        loadElement()
        loadMessage()
    }
    override func viewWillAppear(animated: Bool) {
        print("viewWillAppear")
        storeLabel.text = Sup.Supervisor.store
//        loadMessage()
    }
    override func viewDidAppear(animated: Bool) {
        print("viewDidAppear")
        //        storeLabel.text = Sup.store
        //        loadMessage()
        messageGoPhoto = false
    }
//    override func viewWillDisappear(animated: Bool) {
//        json=[]
//        titleTextField.text = ""
//        subtitleTextField.text = ""
//        contentTextView.text = ""
//        imageImageView.image = nil
//    }
    override func viewDidDisappear(animated: Bool) {
        if messageGoPhoto == false {
            for vc:UIView in self.view.subviews {
                print("清空subviews")
                vc.removeFromSuperview()
            }
        }
    }
    
    //MARK: - didFinish
    func URLSession(session: NSURLSession, downloadTask: NSURLSessionDownloadTask, didFinishDownloadingToURL location: NSURL)
    {
        switch getWhatData
        {
        case "MessageLoad":
            print("MessageLoad")
            getWhatData = ""
            do {
                let resp = String(data: NSData(contentsOfURL: location)!, encoding: NSUTF8StringEncoding)
                if resp! == "[{}]" {
                    print("db沒有資料，新增資料")
                    uploadButton.setTitle("新增", forState: UIControlState.Normal)
                    uploadMode = "create"
                    
                } else {
                    print("db有資料，更新資料")
                    json = try NSJSONSerialization.JSONObjectWithData(NSData(contentsOfURL: location)!, options: NSJSONReadingOptions.MutableContainers) as! NSArray
                    //                        print(json)
                    titleTextField.text = json[0].objectForKey("messageTitle") as? String
                    subtitleTextField.text = json[0].objectForKey("messageSubtitle") as? String
                    contentTextView.text = json[0].objectForKey("messageContent") as? String
                    let imageName = (json[0].objectForKey("messageImage") as? String)!
                    let url = NSURL(string: "http://bing0112.100hub.net/bing/MessageImage/\(imageName)")
                    let tempData = NSData(contentsOfURL: url!)
                    if tempData != nil {
                        imageImageView.image = UIImage(data: tempData!)
                    }
                    
                    uploadButton.setTitle("更新", forState: UIControlState.Normal)
                    uploadMode = "update"
                }
                
            }catch {
                print("There is an error.")
            }
            
        case "uploadMessage":
            getWhatData = ""
            let resp = String(data: NSData(contentsOfURL: location)!, encoding: NSUTF8StringEncoding)
            print("upload resp= \(resp!)")
            uploadButton.setTitle("更新", forState: UIControlState.Normal)
            uploadMode = "update"
            
            if imageImageView.image != nil {
//                myImageUploadRequest() //上傳圖片
                UploadImage().myImageUploadRequest("http://bing0112.100hub.net/bing/MessageUploadImage.php", img: imageImageView.image!, fileName: "\(Sup.Supervisor.supervisor)-\(Sup.Supervisor.storeID)")
                //                print("imageImageView.image != nil")
            } else {
                //                print("imageImageView.image == nil")
            }
            Sup.showAlert(self, str: "上傳成功")
            
            //        case "MessageUploadImage":
            //            print("MessageUploadImage")
            //            getWhatData = ""
            //            let resp = String(data: NSData(contentsOfURL: location)!, encoding: NSUTF8StringEncoding)
            //            print("aaa image resp= \(resp!)")
            
        default:
            print("default")
        }
        
        msgActiView.hidden = true
        msgActi.stopAnimating()
    }
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject])
    {
        print("取完照片")
        let tempImg = info[UIImagePickerControllerOriginalImage] as? UIImage
        let resizeImg = Sup.resizeImage(tempImg!, newWidth: 200, newHeight: 200)
        imageImageView.image = resizeImg
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    //MARK: - Methods
    //下載訊息
    func loadMessage() {
        msgActiView = Sup.addView(self.view.frame)
        self.view.addSubview(msgActiView)
        msgActi = Sup.addActivityIndicatorView(self.view.frame)
        msgActi.startAnimating()
        self.view.addSubview(msgActi)
        
        getWhatData = "MessageLoad"
        //寫入資料至資料庫
        let url = NSURL(string: "http://bing0112.100hub.net/bing/MessageLoad.php")
        let request: NSMutableURLRequest = NSMutableURLRequest(URL: url!)
        
        let submitBody: String =
        "bySupervisor=\(Sup.Supervisor.supervisor)" +
        "&byStore=\(Sup.Supervisor.storeID)"
        print("loadMessage submitBody = \(submitBody)")
        
        request.HTTPMethod = "POST"
        request.HTTPBody = submitBody.dataUsingEncoding(NSUTF8StringEncoding)
        
        let sessionWithConfigure = NSURLSessionConfiguration.defaultSessionConfiguration()
        let session = NSURLSession(configuration: sessionWithConfigure, delegate: self, delegateQueue: NSOperationQueue.mainQueue())
        
        let dataTask = session.downloadTaskWithRequest(request)
        dataTask.resume()
    }
    func modifyMessage() {
        scrollViewTouch() //若沒有加這行，鍵盤隱藏之後，下面又多一個ScrollView
        
        msgActiView = Sup.addView(self.view.frame)
        self.view.addSubview(msgActiView)
        msgActi = Sup.addActivityIndicatorView(self.view.frame)
        msgActi.startAnimating()
        self.view.addSubview(msgActi)
        
        getWhatData = "uploadMessage"
        //寫入資料至資料庫
        let url = NSURL(string: "http://bing0112.100hub.net/bing/MessageUpload.php")
        let request: NSMutableURLRequest = NSMutableURLRequest(URL: url!)
        
        let submitBody: String =
        "mode=\(uploadMode)" +
            "&bySupervisor=\(Sup.Supervisor.supervisor)" +
            "&byStore=\(Sup.Supervisor.storeID)" +
            "&title=\(titleTextField.text!)" +
            "&subtitle=\(subtitleTextField.text!)" +
        "&content=\(contentTextView.text!)"
        
        //        print("xxx \(submitBody)")
        
        request.HTTPMethod = "POST"
        request.HTTPBody = submitBody.dataUsingEncoding(NSUTF8StringEncoding)
        
        let sessionWithConfigure = NSURLSessionConfiguration.defaultSessionConfiguration()
        let session = NSURLSession(configuration: sessionWithConfigure, delegate: self, delegateQueue: NSOperationQueue.mainQueue())
        
        let dataTask = session.downloadTaskWithRequest(request)
        dataTask.resume()
    }
    //選擇圖片
    func selectPhoto() {
//        messageGoPhoto = true //不清空畫面上的資料
        scrollViewTouch()
        
        let myPickerController = UIImagePickerController()
        myPickerController.delegate = self;
        myPickerController.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        
        self.presentViewController(myPickerController, animated: true, completion: nil)
    }
    
    //    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
    //        print("Should BeginEditing")
    //        return true
    //    }
    //    func textFieldShouldEndEditing(textField: UITextField) -> Bool {
    //        print("Should EndEditing")
    //        return true
    //    }
    //    func textFieldDidBeginEditing(textField: UITextField) {
    //        print("Did BeginEditing")
    //    }
    //    func textFieldDidEndEditing(textField: UITextField) {
    //        print("Did EndEditing")
    //    }
    
    func keyboardWillShow(notification:NSNotification) {
        let userInfo:NSDictionary = notification.userInfo!
        let keyboardFrame:NSValue = userInfo.valueForKey(UIKeyboardFrameEndUserInfoKey) as! NSValue
        let keyboardRectangle = keyboardFrame.CGRectValue()
        let keyboardHeight = keyboardRectangle.height
//print("keyboardHeight \(keyboardHeight)")
        
        var frame = scrollView.frame
        frame = CGRectMake(0, viewStartY, self.view.frame.width, self.view.frame.height - viewStartY - keyboardHeight)
        scrollView.frame = frame
    }
    func scrollViewTouch() {
        //print("scrollViewTouch \(scrollView.frame.origin.x)")
        titleTextField.resignFirstResponder()
        subtitleTextField.resignFirstResponder()
        contentTextView.resignFirstResponder()
        
        var frame = scrollView.frame
        //        frame = CGRectMake(scrollView.frame.origin.x, scrollView.frame.origin.y, self.view.frame.width, self.view.frame.height)
        frame = CGRectMake(0, viewStartY, self.view.frame.width, self.view.frame.height - viewStartY)
        scrollView.frame = frame
        //scroll to top
        //        self.scrollView.setContentOffset(CGPointMake(self.scrollView.contentOffset.x, -64), animated: true)
    }
    
    //MARK: - textField
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        //        print("xxx")
        if textField == titleTextField
        {
            subtitleTextField.becomeFirstResponder()
        }
        else if textField == subtitleTextField
        {
            contentTextView.becomeFirstResponder()
        }
        
        return true
    }
    
    //    func textFiledTouch(textField: UITextField) {
    //        print("textFiledTouch")
    //        var frame = scrollView.frame
    //        frame = CGRectMake(scrollView.frame.origin.x, scrollView.frame.origin.y, self.view.frame.width, self.view.frame.height-216)
    //        scrollView.frame = frame
    //    }
    
    //MARK: - init settings
    func init_Setting() {
        self.automaticallyAdjustsScrollViewInsets = false
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
    }
    func loadElement() {
        self.navigationItem.title = "訊息"
        self.view.backgroundColor = UIColor(red: 0, green: 0.5, blue: 1, alpha: 1)
        let corRadius:CGFloat = 5
        
        scrollView = UIScrollView(frame: CGRectMake(
            0, viewStartY, //x, y
            self.view.frame.width,
            self.view.frame.height*1.0 - viewStartY)) //w, h
//        scrollView.scrollEnabled = true
//        scrollView.autoresizesSubviews = true
//        scrollView.bounces = true
//        scrollView.contentSize = CGSizeMake(scrollView.frame.size.width, scrollView.frame.size.height)
//        scrollView.delegate = self
//        scrollView.userInteractionEnabled = true
        scrollView.backgroundColor = scrollviewBackColor
        self.view.addSubview(scrollView)
        
        usedHeight = 0+5
        
        //商店標題 Label
        let storeColumn:UILabel = UILabel(frame: CGRectMake(
            (self.view.frame.width - self.view.frame.width*0.8)/2, //x
            CGFloat(usedHeight), //y
            self.view.frame.width*0.8, 20)) //w, h
        storeColumn.text = "商店："
        scrollView.addSubview(storeColumn)
        //商店欄位 Label
        usedHeight += 20
        storeLabel = UILabel(frame: CGRectMake(
            (self.view.frame.width - self.view.frame.width*0.8)/2, //x
            CGFloat(usedHeight), //y
            self.view.frame.width*0.8, 35)) //w, h
        storeLabel.layer.cornerRadius = corRadius
        storeLabel.layer.masksToBounds = true
        storeLabel.backgroundColor = UIColor.lightGrayColor()
        //        let tapGesture = UITapGestureRecognizer(target: self, action: "showStoreOption")
        //        storeLabel.addGestureRecognizer(tapGesture)
        //        storeLabel.userInteractionEnabled = true
        scrollView.addSubview(storeLabel)
        usedHeight += Int(storeLabel.frame.size.height)
        
        //標題 Label
        let titleColumn:UILabel = UILabel(frame: CGRectMake(
            (self.view.frame.width - self.view.frame.width*0.8)/2, //x
            CGFloat(usedHeight), //y
            self.view.frame.width*0.8, 20)) //w, h
        titleColumn.text = "標題："
        scrollView.addSubview(titleColumn)
        //標題 TextField
        usedHeight += 20
        titleTextField = UITextField(frame: CGRectMake(
            (self.view.frame.width - self.view.frame.width*0.8)/2, //x
            CGFloat(usedHeight), //y
            self.view.frame.width*0.8, 35)) //w, h
        titleTextField.layer.cornerRadius = corRadius
        titleTextField.layer.masksToBounds = true
        titleTextField.backgroundColor = textBackgroundColor
        titleTextField.delegate = self
        scrollView.addSubview(titleTextField)
        usedHeight += Int(titleTextField.frame.size.height)
        
        //副標題 Label
        let subTitleColumn:UILabel = UILabel(frame: CGRectMake(
            (self.view.frame.width - self.view.frame.width*0.8)/2, //x
            CGFloat(usedHeight), //y
            self.view.frame.width*0.8, 20)) //w, h
        subTitleColumn.text = "副標題："
        scrollView.addSubview(subTitleColumn)
        //副標題 TextField
        usedHeight += 20
        subtitleTextField = UITextField(frame: CGRectMake(
            (self.view.frame.width - self.view.frame.width*0.8)/2, //x
            CGFloat(usedHeight), //y
            self.view.frame.width*0.8, 35)) //w, h
        subtitleTextField.layer.cornerRadius = corRadius
        subtitleTextField.layer.masksToBounds = true
        subtitleTextField.backgroundColor = textBackgroundColor
        subtitleTextField.delegate = self
        scrollView.addSubview(subtitleTextField)
        usedHeight += Int(subtitleTextField.frame.size.height)
        
        //內容 Label
        let contentColumn:UILabel = UILabel(frame: CGRectMake(
            (self.view.frame.width - self.view.frame.width*0.8)/2, //x
            CGFloat(usedHeight), //y
            self.view.frame.width*0.8, 20)) //w, h
        contentColumn.text = "內容："
        scrollView.addSubview(contentColumn)
        //內容 TextView
        usedHeight += 20
        contentTextView = UITextView(frame: CGRectMake(
            (self.view.frame.width - self.view.frame.width*0.8)/2, //x
            CGFloat(usedHeight), //y
            self.view.frame.width*0.8, 70)) //w, h
        contentTextView.layer.cornerRadius = corRadius
        contentTextView.layer.masksToBounds = true
        contentTextView.backgroundColor = textBackgroundColor
        contentTextView.font = UIFont(name: ".SFUIText-Regular", size: 17) //改變textview字型大小
        scrollView.addSubview(contentTextView)
        usedHeight += Int(contentTextView.frame.size.height)
        
        //圖片 Label
        let imageColumn:UILabel = UILabel(frame: CGRectMake(
            (self.view.frame.width - self.view.frame.width*0.8)/2, //x
            CGFloat(usedHeight), //y
            self.view.frame.width*0.8, 20)) //w, h
        imageColumn.text = "圖片："
        scrollView.addSubview(imageColumn)
        
        //圖片 ImageView
        usedHeight += 20
        let backImageView = UIImageView(frame: CGRectMake(
            (self.view.frame.width - self.view.frame.width*0.8)/2, //x
            CGFloat(usedHeight), //y
            self.view.frame.width*0.8, 200)) //w, h
        backImageView.layer.cornerRadius = corRadius
        backImageView.layer.masksToBounds = true
        //        backImageView.backgroundColor = UIColor.lightGrayColor()
        backImageView.image = UIImage(named: "uploadImage")
        backImageView.userInteractionEnabled = true
        scrollView.addSubview(backImageView)
        
        imageImageView = UIImageView(frame: CGRectMake(
            (self.view.frame.width - self.view.frame.width*0.8)/2, //x
            CGFloat(usedHeight), //y
            self.view.frame.width*0.8, 200)) //w, h
        imageImageView.layer.cornerRadius = corRadius
        imageImageView.layer.masksToBounds = true
//        imageImageView.backgroundColor = textBackgroundColor
        imageImageView.userInteractionEnabled = true
        scrollView.addSubview(imageImageView)
        usedHeight += Int(imageImageView.frame.size.height)
        
        //按鈕
        usedHeight += 10
        uploadButton = UIButton(frame: CGRectMake(
            (self.view.frame.width - self.view.frame.width*0.8)/2, //x
            CGFloat(usedHeight), //y
            self.view.frame.width*0.8, 35)) //w, h
        uploadButton.setTitle("建立", forState: .Normal)
        uploadButton.backgroundColor = UIColor.blueColor()
        uploadButton.layer.cornerRadius = corRadius
        uploadButton.layer.masksToBounds = true
        uploadButton.titleLabel?.font = UIFont(name: (uploadButton.titleLabel?.font?.fontName)!, size: 26)
        scrollView.addSubview(uploadButton)
        usedHeight += Int(uploadButton.frame.size.height)
        
        //設定contentsize
        scrollView.contentSize = CGSizeMake(scrollView.frame.size.width, CGFloat(usedHeight + 10))
        
        //加入event
        let tapGesture1 = UITapGestureRecognizer(target: self, action: "imageTouch")
        imageImageView.addGestureRecognizer(tapGesture1)
        
        let tapGesture2 = UITapGestureRecognizer(target: self, action: "scrollViewTouch")
        scrollView.addGestureRecognizer(tapGesture2)
        
        uploadButton.addTarget(self, action: "modifyMessage", forControlEvents: .TouchUpInside)
    }
    
    func imageTouch() {
        //takePicture
        //selectPhoto
        //cancel
        messageGoPhoto = true //不清空畫面上的資料
        
        let alertController = UIAlertController(title: "請選擇", message: nil, preferredStyle: UIAlertControllerStyle.Alert)
        
        alertController.addAction(UIAlertAction(title: "拍照", style: UIAlertActionStyle.Default, handler: { (UIAlertAction) -> Void in
            self.msgTakePicture()
        }))
        alertController.addAction(UIAlertAction(title: "選擇照片", style: UIAlertActionStyle.Default, handler: { (UIAlertAction) -> Void in
            self.selectPhoto()
        }))
        alertController.addAction(UIAlertAction(title: "取消", style: UIAlertActionStyle.Destructive,handler: nil))
        
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func msgTakePicture() {
        let ipc: UIImagePickerController = UIImagePickerController()
        //檢查是否支援相機
        let checkSourceType: Bool = UIImagePickerController.isSourceTypeAvailable(.Camera)
        let checkCameraRear: Bool = UIImagePickerController.isCameraDeviceAvailable(.Rear)
        if checkSourceType && checkCameraRear {
            ipc.sourceType = .Camera
            ipc.cameraDevice = .Rear
            ipc.cameraCaptureMode = .Photo
            //        ipc.wantsFullScreenLayout = YES;
            ipc.mediaTypes = UIImagePickerController.availableMediaTypesForSourceType(.Camera)!
            ipc.allowsEditing = true
            ipc.delegate = self
            self.presentViewController(ipc, animated: true, completion: { _ in })
            print("yyy")
        }
        print("hello")
    }
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?)
    {
        print("didFinishPickingImage")
        picker.dismissViewControllerAnimated(true) { () -> Void in
            //
        }
        
        if ((editingInfo![UIImagePickerControllerEditedImage]) != nil) {
            imageImageView.image = image
            imageImageView.image = editingInfo![UIImagePickerControllerEditedImage] as? UIImage
        }
        else {
//            imageImageView.image = (editingInfo![UIImagePickerControllerOriginalImage] as! String)
            imageImageView.image = editingInfo![UIImagePickerControllerOriginalImage] as? UIImage
        }
    }
}

//6plus 271
//6     258
//5s    253
//4s    253
