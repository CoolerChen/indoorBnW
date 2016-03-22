//
//  AZNotificationView.swift
//  AZNotificationDemo
//
//  Created by Mohammad Azam on 6/4/14.
//  Copyright (c) 2014 AzamSharp Consulting LLC. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

let notificationViewHeight :CGFloat = 70
//var myPlayer:AVAudioPlayer!
var labelRect:CGRect?
var titleLabel:UILabel?
var backScrollView:UIView!   //顯示訊息
var scrollView:UIScrollView! //顯示訊息
var closeImageView:UIImageView! //顯示訊息
var aznvMessageTime:String=""

enum AZNotificationType
{
    case Success,Error,Warning,Message
}

enum NotificationColors :String
{
    case Success = "17BF30",
    Error = "BF1525",
    Warning = "BF3E12",
    Message = "7F7978"
}

class AZNotificationView : UIView
{
    var title = ""
    var referenceView = UIView()
    var showNotificationUnderNavigationBar = false
    var animator = UIDynamicAnimator()
    var gravity = UIGravityBehavior()
    var collision = UICollisionBehavior()
    var itemBehavior = UIDynamicItemBehavior()
    var notificationType = AZNotificationType.Success
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    init(title :String, referenceView :UIView, notificationType :AZNotificationType, msgTime :String)
    {
        aznvMessageTime = msgTime
        self.title = title
        self.referenceView = referenceView
        self.notificationType = notificationType
        super.init(frame: CGRectMake(0, 0, referenceView.bounds.size.width, notificationViewHeight))
        setup()
    }
    
    init(title :String, referenceView :UIView, notificationType :AZNotificationType, showNotificationUnderNavigationBar :Bool)
    {
        self.title = title
        self.referenceView = referenceView
        self.notificationType = notificationType
        self.showNotificationUnderNavigationBar = showNotificationUnderNavigationBar
        super.init(frame: CGRectMake(0, 0, referenceView.bounds.size.width, notificationViewHeight))
        setup()
    }
    
    func setup()
    {
        let screenBounds = UIScreen.mainScreen().bounds
        self.frame = CGRectMake(0, showNotificationUnderNavigationBar == true ? 1 : -1 * notificationViewHeight, screenBounds.size.width, notificationViewHeight)
        
        setupNotificationType()
        
        labelRect = CGRectMake(10,10, screenBounds.size.width, notificationViewHeight)
        
        titleLabel = UILabel(frame: labelRect!)
        titleLabel?.text = title
        titleLabel?.font = UIFont(name: "HelveticaNeue-Light", size: 17)
        titleLabel?.textColor = UIColor.whiteColor()
        
        addSubview(titleLabel!)
        
//        let tapNotificationGesture = UITapGestureRecognizer(target: self, action: "notificationTapped")
        let tapNotificationGesture = UITapGestureRecognizer(target: self, action: "beforeNotificationTapped")
        self.addGestureRecognizer(tapNotificationGesture)
    }
    
    func setupNotificationType()
    {
        switch notificationType
        {
        case .Success:
            backgroundColor = UIColor(fromHexString: NotificationColors.Success.rawValue)
            
        case .Error:
            backgroundColor = UIColor(fromHexString: NotificationColors.Error.rawValue)
            
        case .Warning:
            backgroundColor = UIColor(fromHexString: NotificationColors.Warning.rawValue)
            
        case .Message:
            backgroundColor = UIColor(fromHexString: NotificationColors.Message.rawValue)
            
        }
    }
    
    func applyDynamics()
    {
//        let boundaryYAxis :CGFloat = showNotificationUnderNavigationBar == true ? 2 : 1
//        animator = UIDynamicAnimator(referenceView: referenceView)
//        gravity = UIGravityBehavior(items:[self])
//        collision = UICollisionBehavior(items: [self])
//        itemBehavior = UIDynamicItemBehavior(items: [self])
//        
//        itemBehavior.elasticity = 0
//
//        collision.addBoundaryWithIdentifier("AZNotificationBoundary", fromPoint: CGPointMake(0, self.bounds.size.height * boundaryYAxis), toPoint: CGPointMake(referenceView.bounds.size.width,self.bounds.size.height * boundaryYAxis))
//        
//        animator.addBehavior(gravity)
//        animator.addBehavior(collision)
//        animator.addBehavior(itemBehavior)
        
        UIView.transitionWithView(referenceView, duration: 0.5, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
            self.frame.origin.y = 0
//            self.layer.zPosition = -1
            }, completion: { (finished: Bool) -> Void in
                //
        })
        
        //播放音效
        //UILocalNotificationDefaultSoundName
        AudioServicesPlaySystemSound(1002)
        
        //隱藏狀態列
        NSTimer.scheduledTimerWithTimeInterval(0.2, target: self, selector: "hideStatusbar", userInfo: nil, repeats: false)
        
        //隱藏通知
        NSTimer.scheduledTimerWithTimeInterval(6.0, target: self, selector: "hideNotification", userInfo: nil, repeats: false)
    }
    func hideNotification()
    {
        animator.removeBehavior(gravity)
        gravity = UIGravityBehavior(items: [self])
        gravity.gravityDirection = CGVectorMake(0, -1)
        animator.addBehavior(gravity)
        
        //顯示狀態列
        NSTimer.scheduledTimerWithTimeInterval(0.2, target: self, selector: "showStatusbar", userInfo: nil, repeats: false)
    }
    func hideStatusbar()
    {
        UIApplication.sharedApplication().statusBarHidden = true
    }
    func showStatusbar()
    {
        UIApplication.sharedApplication().statusBarHidden = false
    }
    
    func beforeNotificationTapped() {
//        showStatusbar()
//        self.hidden = true
//        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
//        appDelegate.showMessageView(aznvMessageTime)
        notificationTapped()
    }
    //MARK: - 顯示訊息
    func notificationTapped() {
        showStatusbar()
        self.hidden = true
        
//        print("=================== AZNotificationView.swift notificationTapped")
//        if json.count > 0 {
//            print("json.count 大於0")
//        } else {
//            print("json[] 沒有資料")
//            return
//        }
        let scrollviewBackColor:UIColor = UIColor(red: 0.85, green: 0.85, blue: 0.58, alpha: 1)
        let txtBackgroundColor:UIColor = UIColor(red: 250/255.0, green: 243/255.0, blue: 203/255.0, alpha: 1)
        
        let db = SQLiteDB.sharedInstance()
        let data = db.query("select * from messagelocal where messageTime='\(aznvMessageTime)' limit 1 ")
        
        backScrollView?.hidden = false
        
        //外ScrollView
        if backScrollView == nil {
            let screenW = UIScreen.mainScreen().bounds.size.width
            let screenH = UIScreen.mainScreen().bounds.size.height
            
            backScrollView = UIScrollView(frame: CGRectMake(0, 0, //x, y
                screenW, screenH*1.0)) //w, h
            backScrollView?.backgroundColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1)
            //            msgView?.transform = CGAffineTransformMakeScale(0.1, 0.1)
            
            self.window?.addSubview(backScrollView!)
        }
        
        let viewW = (backScrollView?.frame.width)!
        let viewH = (backScrollView?.frame.height)!
        let interval:CGFloat = 10
        let corRadius:CGFloat = 5
        
        if scrollView != nil {
            (scrollView as UIView).removeFromSuperview()
        }
        if closeImageView != nil {
            closeImageView.removeFromSuperview()
        }
        
        //內ScrollView
        let viewStartY:CGFloat = 20
        scrollView = UIScrollView(frame: CGRectMake(
            (viewW - viewW*0.9)/2, //x
            (( viewH-viewStartY ) - ( viewH-viewStartY )*0.85)/2 + viewStartY, //y
            viewW*0.9,
            ( viewH-viewStartY )*0.85)) //w, h
        scrollView.backgroundColor = UIColor(red: 0.85, green: 0.85, blue: 0.58, alpha: 1)
        scrollView.layer.cornerRadius = 10
        scrollView.layer.masksToBounds = true
        self.window?.addSubview(scrollView)
        usedY = 20 //scrollView.frame.origin.y + 20
        
        scrollView.hidden = false
        
        //商店
        if data.count > 0 {
            if (data[0]["messageStore"] as! String) != "" {
                let storeLabel = UILabel(frame: CGRectMake(
                    (scrollView.frame.width - scrollView.frame.width*0.9)/2, //x
                    usedY, //y
                    scrollView.frame.width*0.9, 35)) //w, h
                storeLabel.backgroundColor = txtBackgroundColor
                storeLabel.layer.cornerRadius = corRadius
                storeLabel.layer.masksToBounds = true
                storeLabel.text = data[0]["messageStore"] as! String
                scrollView.addSubview(storeLabel)
                usedY += storeLabel.frame.height + interval
            }
        }
        
        //標題
        let titleLabel = UILabel(frame: CGRectMake(
            (scrollView.frame.width - scrollView.frame.width*0.9)/2, //x
            usedY, //y
            scrollView.frame.width*0.9, 35)) //w, h
        titleLabel.backgroundColor = txtBackgroundColor
//        titleLabel.text = json[0].objectForKey("messageTitle") as? String
        titleLabel.text = data.count>0 ? data[0]["messageTitle"] as! String : ""
//print("標題: \(json[0].objectForKey("messageTitle") as? String)")
        scrollView.addSubview(titleLabel)
        usedY += titleLabel.frame.height + interval
        
        //副標題
        let subtitleLabel = UILabel(frame: CGRectMake(
            titleLabel.frame.origin.x, //x
            usedY, //y
            scrollView.frame.width*0.9, 35)) //w, h
        subtitleLabel.backgroundColor = txtBackgroundColor
//        subtitleLabel.text = json[0].objectForKey("messageSubtitle") as? String
        subtitleLabel.text = data.count>0 ? data[0]["messageSubtitle"] as! String : ""
        scrollView.addSubview(subtitleLabel)
        usedY += subtitleLabel.frame.height + interval
        
        //內容
        let contentTextView = UITextView(frame: CGRectMake(
            titleLabel.frame.origin.x, //x
            usedY, //y
            scrollView.frame.width*0.9, 70)) //w, h
        contentTextView.backgroundColor = txtBackgroundColor
        contentTextView.font = UIFont(name: ".SFUIText-Regular", size: 17) //改變textview字型大小
//        contentTextView.text = json[0].objectForKey("messageContent") as? String
        contentTextView.text = data.count>0 ? data[0]["messageContent"] as! String : ""
        contentTextView.selectable = false
        scrollView.addSubview(contentTextView)
        usedY += contentTextView.frame.height + interval
        
        //圖片
        let imageImageView = UIImageView(frame: CGRectMake(
            (scrollView.frame.width - scrollView.frame.width*0.9)/2, //x
            usedY, //y
            scrollView.frame.width*0.9, 200)) //w, h
        imageImageView.backgroundColor = txtBackgroundColor
        imageImageView.userInteractionEnabled = false
        
//        let imageName = json[0].objectForKey("messageImage") as? String
//        let tempData = NSData(contentsOfURL: NSURL(string: "http://bing0112.100hub.net/bing/MessageImage/\(imageName!)")!)
//        if tempData != nil {
//            imageImageView.image = UIImage(data: tempData!)
//        } else {
//            imageImageView.backgroundColor = UIColor.redColor()
//        }
        let imageName = data.count>0 ? data[0]["messageImage"] as! String : ""
        //        print(imageName)
        if imageName != "" {
            //            let tempData = NSData(contentsOfURL: NSURL(string: "http://bing0112.100hub.net/bing/MessageImage/\(imageName)")!)
            let tempData = NSData(contentsOfFile: NSHomeDirectory() + "/Documents/images/msg/" + imageName)
            if tempData != nil {
                imageImageView.image = UIImage(data: tempData!)
            }
        }
        scrollView.addSubview(imageImageView)
        usedY += imageImageView.frame.height + interval + 200
        
        //ScrollView ContentSize
        scrollView.contentSize = CGSizeMake(scrollView.frame.width, usedY)
        
//        json = [] //顯示訊息後清空，避免重複顯示
        
        scrollView.transform = CGAffineTransformMakeScale(0.1, 0.1)
        UIView.transitionWithView(scrollView, duration: 0.35, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
            scrollView.transform = CGAffineTransformMakeScale(1.1, 1.1);
            
            }, completion: { (finished: Bool) -> Void in
                //
                UIView.transitionWithView(scrollView, duration: 0.3, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
                    scrollView.transform = CGAffineTransformMakeScale(1.0, 1.0);
                    
                    }, completion: { (finished: Bool) -> Void in
                        //
//                        print("showMessage.swift 縮小訊息比例1.0")
                        //關閉訊息圖案XX
                        let closeW:CGFloat = 35
                        closeImageView = UIImageView(frame: CGRectMake(
                            (viewW - viewW*0.1/2) - closeW/2 - 2, //x
                            (( viewH-viewStartY ) - ( viewH-viewStartY )*0.85)/2 + viewStartY - closeW/2 + 2, //y
                            35, 35)) //w, h
                        //        print("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ \(closeImageView.frame.origin.x) \(closeImageView.frame.origin.y)")
                        closeImageView.userInteractionEnabled = true
                        closeImageView.layer.cornerRadius = corRadius
                        closeImageView.layer.masksToBounds = true
                        closeImageView.image = UIImage(named: "close")
                        self.window?.addSubview(closeImageView)
                        //加入event
                        let closeimgTapGesture1 = UITapGestureRecognizer(target: self, action: "viewTouch:")
                        closeImageView.addGestureRecognizer(closeimgTapGesture1)
                        
//                        let closeW:CGFloat = 35
//                        closeImageView = UIImageView(frame: CGRectMake(
//                            (viewW - viewW*0.1/2) - closeW/2 - 2, //x
//                            (( viewH-viewStartY ) - ( viewH-viewStartY )*0.85)/2 + viewStartY - closeW/2 + 2, //y
//                            35, 35)) //w, h
//                        //        print("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ \(closeImageView.frame.origin.x) \(closeImageView.frame.origin.y)")
//                        closeImageView.userInteractionEnabled = true
//                        closeImageView.layer.cornerRadius = corRadius
//                        closeImageView.layer.masksToBounds = true
//                        closeImageView.image = UIImage(named: "close")
//                        backScrollView.addSubview(closeImageView)
//                        //加入event
//                        let closeimgTapGesture1 = UITapGestureRecognizer(target: self, action: "viewTouch:")
//                        closeImageView.addGestureRecognizer(closeimgTapGesture1)

                })
//                print("showMessage.swift 放大訊息比例1.1")
        })
        
        //add event
        let tapGesture = UITapGestureRecognizer(target: self, action: "viewTouch:")
        backScrollView?.addGestureRecognizer(tapGesture)
    }
    
    func viewTouch(sender: UITapGestureRecognizer) {
        scrollView.hidden = true
        backScrollView.hidden = true
        closeImageView.hidden = true
    }
}
