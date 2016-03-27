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
var titleTextView:UITextView?
var backScrollView:UIScrollView!   //顯示訊息
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
        
        labelRect = CGRectMake(10,15, screenBounds.size.width, notificationViewHeight)
        
        titleTextView = UITextView(frame: labelRect!)
        titleTextView?.text = title
        titleTextView?.font = UIFont(name: "HelveticaNeue-Light", size: 17)
        titleTextView?.textColor = UIColor.whiteColor()
        titleTextView?.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0)
        titleTextView?.editable = false
        titleTextView?.selectable = false
        
        addSubview(titleTextView!)
        
//        let tapNotificationGesture = UITapGestureRecognizer(target: self, action: "notificationTapped")
        let tapNotificationGesture = UITapGestureRecognizer(target: self, action: "beforeNotificationTapped")
        self.addGestureRecognizer(tapNotificationGesture)
    }
    
    func setupNotificationType()
    {
        switch notificationType
        {
        case .Success:
//            backgroundColor = UIColor(fromHexString: NotificationColors.Success.rawValue)
            backgroundColor = UIColor(red: 64/255.0, green: 194/255.0, blue: 66/255.0, alpha: 0.95)
            
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
//        NSTimer.scheduledTimerWithTimeInterval(0.2, target: self, selector: "hideStatusbar", userInfo: nil, repeats: false)
        
        //隱藏通知
        NSTimer.scheduledTimerWithTimeInterval(8.0, target: self, selector: "hideNotification", userInfo: nil, repeats: false)
    }
    func hideNotification()
    {
        animator.removeBehavior(gravity)
        gravity = UIGravityBehavior(items: [self])
        gravity.gravityDirection = CGVectorMake(0, -1)
        animator.addBehavior(gravity)
        
        //顯示狀態列
//        NSTimer.scheduledTimerWithTimeInterval(0.2, target: self, selector: "showStatusbar", userInfo: nil, repeats: false)
    }
//    func hideStatusbar()
//    {
//        UIApplication.sharedApplication().statusBarHidden = true
//    }
//    func showStatusbar()
//    {
//        UIApplication.sharedApplication().statusBarHidden = false
//    }
    
    func beforeNotificationTapped() {
//        showStatusbar()
        self.hidden = true
        
        let messageUIView = MessageUIView(referenceView: referenceView, getValueString: aznvMessageTime)
        referenceView.addSubview(messageUIView)
    }
    
}
