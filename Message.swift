//
//  SupervisorCreateMessage.swift
//  indoorBNWtestMessage
//
//  Created by LEO on 2016/3/9.
//  Copyright © 2016年 LEO. All rights reserved.
//

import UIKit

class Message: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, NSURLSessionDownloadDelegate, UITextFieldDelegate {
    var json = []
    
    var uploadMode = ""
    
    let indicator=UIActivityIndicatorView()
    var getWhatData:String = ""
    var imageFileName:String = ""
    
    var usedHeight:Int = 0
    var m_checkStr:String = String() //切換鈕
    //    var storeTableView:UITableView!
    var scrollView:UIScrollView!
    var segm:UISegmentedControl!
    var storeLabel:UILabel!
    var titleTextField:UITextField!
    var subtitleTextField:UITextField!
    var contentTextView:UITextView!
    var imageImageView:UIImageView!
    var uploadButton:UIButton!
    
    //MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        print("viewDidLoad")
        
        init_Setting()
        loadElement()
        //        loadMessage()
    }
    override func viewWillAppear(animated: Bool) {
        print("viewWillAppear")
        storeLabel.text = Sup.Supervisor.store
        loadMessage()
    }
    override func viewDidAppear(animated: Bool) {
        print("viewDidAppear")
        //        storeLabel.text = Sup.store
        //        loadMessage()
    }
    override func viewWillDisappear(animated: Bool) {
        json=[]
        titleTextField.text = ""
        subtitleTextField.text = ""
        contentTextView.text = ""
        imageImageView.image = nil
    }
    
    //    func onSegmAction(sender:UISegmentedControl)
    //    {
    //        switch sender.selectedSegmentIndex {
    //        case 0:
    //            m_checkStr = "member"
    //        case 1:
    //            m_checkStr = "normal"
    //        default :
    //            break
    //        }
    //    }
    
    
    //    //MARK: - TableView
    //    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    //        //
    //        return 1
    //    }
    //    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    //        //
    //        return 3
    //    }
    //    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    //        //        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
    //        let cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "Cell")
    //
    //        cell.textLabel?.text = "test"
    //
    //        return cell
    //    }
    //    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    //        return 40
    //    }
    
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
        //        let resp = String(data: NSData(contentsOfURL: location)!, encoding: NSUTF8StringEncoding)
        //        if resp! == "OK" {
        //
        //        }
    }
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject])
    {
        let tempImg = info[UIImagePickerControllerOriginalImage] as? UIImage
        let resizeImg = Sup.resizeImage(tempImg!, newWidth: 200, newHeight: 200)
        imageImageView.image = resizeImg
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    //MARK: - Methods
    //下載訊息
    func loadMessage() {
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
    //選擇圖片
    func selectPhoto() {
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
        print("keyboardHeight \(keyboardHeight)")
        
        var frame = scrollView.frame
        frame = CGRectMake(0, 0, self.view.frame.width, self.view.frame.height - keyboardHeight)
        scrollView.frame = frame
    }
    func scrollViewTouch() {
        //print("scrollViewTouch \(scrollView.frame.origin.x)")
        titleTextField.resignFirstResponder()
        subtitleTextField.resignFirstResponder()
        contentTextView.resignFirstResponder()
        
        var frame = scrollView.frame
        //        frame = CGRectMake(scrollView.frame.origin.x, scrollView.frame.origin.y, self.view.frame.width, self.view.frame.height)
        frame = CGRectMake(0, 0, self.view.frame.width, self.view.frame.height)
        scrollView.frame = frame
        //scroll to top
        //        self.scrollView.setContentOffset(CGPointMake(self.scrollView.contentOffset.x, -64), animated: true)
    }
    
//    //MARK: - upload image
//    func myImageUploadRequest()
//    {
//        getWhatData = "MessageUploadImage"
//        
//        let myUrl = NSURL(string: "http://bing0112.100hub.net/bing/MessageUploadImage.php")
////        let myUrl = NSURL(string: "http://sashihara.100hub.net/vip/img/imgUpload.php")
//        
//        let request = NSMutableURLRequest(URL:myUrl!)
//        request.HTTPMethod = "POST"
//        
//        let param = [
//            "firstName" : "leo",
//            "lastName"  : "leo",
//            "userId"    : "0"
//        ]
//        
//        let boundary = generateBoundaryString()
//        
//        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
//        
//        let imageData = UIImageJPEGRepresentation(imageImageView.image!, 1)
//        
//        if(imageData==nil)  { return; }
//        
//        request.HTTPBody = createBodyWithParameters(param, filePathKey: "file", imageDataKey: imageData!, boundary: boundary)
//        
//        indicator.hidden = false
//        indicator.startAnimating();
//        
//        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
//            data, response, error in
//            
//            if error != nil {
//                print("Message: error=\(error)")
//                return
//            }
//            
//            dispatch_async(dispatch_get_main_queue(),{
//                self.indicator.stopAnimating()
//                self.indicator.hidden = true
//            });
//        }
//        task.resume()
//    }
//    func createBodyWithParameters(parameters: [String: String]?, filePathKey: String?, imageDataKey: NSData, boundary: String) -> NSData {
//        var body = NSMutableData()
//        
//        if parameters != nil {
//            for (key, value) in parameters! {
//                body.appendString("--\(boundary)\r\n")
//                body.appendString("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
//                body.appendString("\(value)\r\n")
//            }
//        }
//        
//        let filename = "\(Sup.Supervisor.supervisor)-\(Sup.Supervisor.storeID).jpg"
//        
//        let mimetype = "image/jpg"
//        
//        body.appendString("--\(boundary)\r\n")
//        body.appendString("Content-Disposition: form-data; name=\"\(filePathKey!)\"; filename=\"\(filename)\"\r\n")
//        body.appendString("Content-Type: \(mimetype)\r\n\r\n")
//        body.appendData(imageDataKey)
//        body.appendString("\r\n")
//        
//        body.appendString("--\(boundary)--\r\n")
//        
//        return body
//    }
//    func generateBoundaryString() -> String {
//        return "Boundary-\(NSUUID().UUIDString)"
//    }
    
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
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        
        
    }
    func loadElement() {
        self.view.backgroundColor = UIColor(red: 0, green: 0.5, blue: 1, alpha: 1)
        self.navigationItem.title = "訊息"
        
        scrollView = UIScrollView(frame: CGRectMake(0, 0, //x, y
            self.view.frame.width, self.view.frame.height*1.0)) //w, h
        //        scrollView.scrollEnabled = true
        //        scrollView.autoresizesSubviews = true
        //        scrollView.bounces = true
        //        scrollView.contentSize = CGSizeMake(scrollView.frame.size.width, scrollView.frame.size.height)
        //        scrollView.delegate = self
        //        scrollView.userInteractionEnabled = true
        scrollView.backgroundColor = UIColor(red: 0.85, green: 0.85, blue: 0.58, alpha: 1)
        self.view.addSubview(scrollView)
        
        usedHeight = 0+5
        
        //        //訊息種類 SegmentedControl
        //        segm = UISegmentedControl(items: ["會員訊息","一般訊息"])
        //        segm.frame = CGRectMake(
        //            self.view.frame.size.width/2-100, CGFloat(usedHeight + 10), //x, y
        //            100 * 2, 30) //w, h
        //        segm.selectedSegmentIndex = 0
        //        segm.addTarget(self, action: "onSegmAction:", forControlEvents: .ValueChanged)
        //        segm.tintColor = UIColor.blackColor()
        //        scrollView.addSubview(segm)
        //        usedHeight += Int(segm.frame.size.height+15)
        
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
        //        storeLabel.text = Sup.store
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
        titleTextField.backgroundColor = UIColor.whiteColor()
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
        subtitleTextField.backgroundColor = UIColor.whiteColor()
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
        contentTextView.backgroundColor = UIColor.whiteColor()
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
        //        backImageView.backgroundColor = UIColor.lightGrayColor()
        backImageView.image = UIImage(named: "uploadImage")
        backImageView.userInteractionEnabled = true
        scrollView.addSubview(backImageView)
        
        imageImageView = UIImageView(frame: CGRectMake(
            (self.view.frame.width - self.view.frame.width*0.8)/2, //x
            CGFloat(usedHeight), //y
            self.view.frame.width*0.8, 200)) //w, h
        //        imageImageView.backgroundColor = UIColor.lightGrayColor()
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
        scrollView.addSubview(uploadButton)
        usedHeight += Int(uploadButton.frame.size.height)
        scrollView.contentSize = CGSizeMake(scrollView.frame.size.width, CGFloat(usedHeight + 20)) //設定contentsize
        
        //加入event
        let tapGesture1 = UITapGestureRecognizer(target: self, action: "selectPhoto")
        imageImageView.addGestureRecognizer(tapGesture1)
        
        let tapGesture2 = UITapGestureRecognizer(target: self, action: "scrollViewTouch")
        scrollView.addGestureRecognizer(tapGesture2)
        
        uploadButton.addTarget(self, action: "modifyMessage", forControlEvents: .TouchUpInside)
        
        //TextField
        //        titleTextField.addTarget(self, action: "textFiledTouch:", forControlEvents: .EditingDidBegin)
        //        subtitleTextField.addTarget(self, action: "textFiledTouch:", forControlEvents: .EditingDidBegin)
        
        //        myTextField.addTarget(self, action: "myTargetFunction:", forControlEvents: UIControlEvents.TouchDown)
        
        //隱藏的TableView模擬下選單
        //        storeTableView = UITableView(frame: CGRectMake(
        //            (self.view.frame.width - self.view.frame.width*0.8)/2, //x
        //            storeLabel.frame.origin.y + storeLabel.frame.size.height, //y
        //            self.view.frame.width*0.8, 120))
        //        storeTableView.delegate = self
        //        storeTableView.dataSource = self
        //        storeTableView.backgroundColor = UIColor(red: 1, green: 0, blue: 0, alpha: 1)
        //        self.view.addSubview(storeTableView)
        //        storeTableView.hidden = true
    }
    
    func modifyMessage() {
        scrollViewTouch() //若沒有加這行，鍵盤隱藏之後，下面又多一個ScrollView
        
        getWhatData = "uploadMessage"
        //寫入資料至資料庫
        let url = NSURL(string: "http://bing0112.100hub.net/bing/MessageUpload.php")
        let request: NSMutableURLRequest = NSMutableURLRequest(URL: url!)
        
        let submitBody: String =
        "mode=\(uploadMode)" +
            "&bySupervisor=\(Sup.Supervisor.supervisor)" +
            "&byStore=\(storeLabel.text!)" +
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
        
        //        if imageImageView.image == nil {
        //            print("nil")
        //        } else {
        //            print("not nil")
        //        }
    }
}

//MARK: - extension
//extension NSMutableData {
//    func appendString(string: String) {
//        let data = string.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
//        appendData(data!)
//    }
//}
//extension UITextView {
//    func increaseFontSize () {
//        self.font =  UIFont(name: "", size: self.frame.size.height / 4)!
//    }
//}

//6plus 271
//6     258
//5s    253
//4s    253
