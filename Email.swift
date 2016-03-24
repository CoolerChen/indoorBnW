//
//  Email.swift
//  indoorB&W2
//
//  Created by Bing on 2016/3/13.
//  Copyright © 2016年 Bing. All rights reserved.
//

import UIKit
import MessageUI

class Email: UIViewController ,UITextFieldDelegate,UITextViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,MFMailComposeViewControllerDelegate,NSURLSessionDownloadDelegate,UIScrollViewDelegate{
    
    var textField:UITextField = UITextField()
    var imageView:UIImageView = UIImageView()
    var textView:UITextView = UITextView()
    var json = []
    var m_image:UIImage?
    var emailAry:[String] = []
    var acti:UIActivityIndicatorView = UIActivityIndicatorView()
    var actiView:UIView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
        self.navigationItem.title = "Email"
        
        let scrollerView = Sup.addScrollerView(self, frame: CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height), contentSize: CGSizeMake(self.view.frame.size.width, 10000))
        self.view.addSubview(scrollerView)
        
        
        let textFieldW:CGFloat = 350
        let textFieldH:CGFloat = 40
        textField = Sup.addTextField(self, frame: CGRectMake(self.view.frame.size.width*0.1/2, 20, self.view.frame.size.width*0.9, textFieldH), placeholdString: "標題")
        
        let lab:UILabel = Sup.addLabel(CGRectMake(10, textView.frame.origin.y + 65, 200, 30), str: "內文：")
        scrollerView.addSubview(lab)
        
        //imageView = Sup.addImageView(CGRectMake(self.view.frame.size.width/2-textFieldW/2, textView.frame.origin.y + textFieldW + 160, textFieldW, textFieldW), img:img )
        imageView = Sup.addMyImageView(CGRectMake(self.view.frame.size.width*0.1/2, textView.frame.origin.y + self.view.frame.size.width*0.9 + 160, self.view.frame.size.width*0.9, self.view.frame.size.width*0.9), Taraget: self)
        textView = Sup.addTextView(self, frame: CGRectMake(self.view.frame.size.width*0.1/2, lab.frame.origin.y + 40, self.view.frame.size.width*0.9, self.view.frame.size.width*0.9))
        scrollerView.addSubview(textView)
        //scrollerView.addSubview(Sup.addBtn(self, frame:  CGRectMake(self.view.frame.size.width/2-textFieldW/2, textView.frame.origin.y + textFieldW + 10, textFieldW, textFieldH), str: "選擇圖片", tag: 0))
        scrollerView.addSubview(Sup.addBtn(self, frame:  CGRectMake(self.view.frame.size.width*0.1/2, imageView.frame.origin.y + textFieldW + 10, self.view.frame.size.width*0.9, textFieldH), str: "確認", tag: 1))
        scrollerView.addSubview(textField)
        scrollerView.addSubview(imageView)
        
        scrollerView.contentSize = CGSizeMake(self.view.frame.size.width, imageView.frame.origin.y + textFieldW + 80)
        scrollerView.backgroundColor = UIColor.blackColor()
    }
    func onBtnAction(sender:UIButton){
        switch sender.tag {
        case 1:
            if textField.text == ""{
                Sup.showAlert(self, str: "請輸入標題")
                return
            }
            actiView = Sup.addView(self.view.frame)
            self.view.addSubview(actiView)
            acti = Sup.addActivityIndicatorView(self.view.frame)
            acti.startAnimating()
            self.view.addSubview(acti)
            //先抓user email的資料後再開email
            Sup.mySQL(self, url: "http://bing0112.100hub.net/bing/userEmailJSON.php", submitBody: "")
            
        default :
            break
        }
    }
    //圖片被按下
    func handleLongPressFrom(longPressRecognizer:UILongPressGestureRecognizer){
        if longPressRecognizer.state == UIGestureRecognizerState.Began{
            
        }else if longPressRecognizer.state == UIGestureRecognizerState.Changed{
            
        }else if longPressRecognizer.state == UIGestureRecognizerState.Ended || longPressRecognizer.state == UIGestureRecognizerState.Cancelled{
            Sup.PhotoLibrary(self)
        }
    }
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        
        imageView.image = image
        m_image = image
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        self.dismissViewControllerAnimated(true, completion: nil)
        print(result.rawValue)
        switch result.rawValue {
        case 0:
            Sup.showAlert(self, str: "刪除成功")
        case 1:
            Sup.showAlert(self, str: "儲存成功")
        case 2:
            Sup.showAlert(self, str: "傳送成功")
        default :
            break
        }
    }
    func email(){
        let mailController:MFMailComposeViewController = MFMailComposeViewController()
        mailController.mailComposeDelegate = self
        mailController.setSubject(textField.text!)
        mailController.title = textField.text!
        mailController.setMessageBody(textView.text, isHTML: false)
        
        //可以送圖
        if m_image != nil {
            print("有圖")
            let imageData:NSData = UIImagePNGRepresentation(m_image!)! //png圖片檔 pic是UIimage 轉成nsdata
            mailController.addAttachmentData(imageData, mimeType: "", fileName: "img.png")
        }
        
        mailController.setToRecipients(emailAry)
        if !MFMailComposeViewController.canSendMail(){
            print("無法使用")
            return
        }
        self.presentViewController(mailController, animated: true, completion: nil)
    }
    func URLSession(session: NSURLSession, downloadTask: NSURLSessionDownloadTask, didFinishDownloadingToURL location: NSURL) {
        //let resp = String(data: NSData(contentsOfURL: location)!, encoding: NSUTF8StringEncoding)
        do{
            json = try NSJSONSerialization.JSONObjectWithData(NSData(contentsOfURL: location)!, options: NSJSONReadingOptions.MutableContainers) as! NSArray
            //print(json)
        }catch{
            print("解json失敗")
        }
        //跑回圈把json的email丟進陣列
        for ary in json {
            emailAry.append(ary.objectForKey("userEmail") as! String)
        }
        actiView.hidden = true
        acti.stopAnimating()
        email()
    }
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        textField.resignFirstResponder()
    }
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        textField.resignFirstResponder()
        textView.resignFirstResponder()
    }
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        textField.resignFirstResponder()
        textView.resignFirstResponder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
