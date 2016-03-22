//
//  AZNotification.swift
//  AZNotificationDemo
//
//  Created by Mohammad Azam on 6/4/14.
//  Copyright (c) 2014 AzamSharp Consulting LLC. All rights reserved.
//

import Foundation
import UIKit

var targetView:UIViewController!
var usedY:CGFloat = 0

class AZNotification
{
    class func showNotificationWithTitle(titleString :String, var controller :UIViewController!, notificationType :AZNotificationType, messageTime:String)
    {
        targetView = controller
        if controller.navigationController != nil {
            controller = controller.navigationController
        }
        
        let azNotificationView = AZNotificationView(title: titleString, referenceView: controller.view, notificationType: .Success, msgTime: messageTime)
        
        

        controller.view.addSubview(azNotificationView)
        
        //通知Label加入click event
        //x UIWindow(frame: UIScreen.mainScreen().bounds).rootViewController
        //x UIApplication.sharedApplication().keyWindow?.subviews.last
//        let tapNotificationGesture = UITapGestureRecognizer(target: self, action: "notificationTapped")
//        azNotificationView.userInteractionEnabled = true
//        azNotificationView.addGestureRecognizer(tapNotificationGesture)
        
//        controller.prefersStatusBarHidden()
//        controller.view.bringSubviewToFront(azNotificationView)

//        let currentWindow = UIApplication.sharedApplication().keyWindow
//        currentWindow?.addSubview(azNotificationView)
//        currentWindow?.bringSubviewToFront(azNotificationView)
        
//        // Get the screen size
//        var screenSize:CGSize = UIScreen.mainScreen().bounds.size
//        // Use the larger value of the width and the height since the width should be larger in Landscape
//        // This is needed to support iOS 7 since iOS 8 changed how the screen bounds are calculated
//        var widthToUse:CGFloat = (screenSize.width > screenSize.height) ? screenSize.width : screenSize.height
//        // Use the remaining value (width or height) as the height
//        var heightToUse:CGFloat = (widthToUse == screenSize.width ? screenSize.height : screenSize.width)
//        // Create a new modal window, which will take up the entire space of the screen
//        var modalWindow:UIWindow = UIWindow(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
//        modalWindow.backgroundColor = UIColor.blackColor() //.colorWithAlphaComponent(0.66)
//        modalWindow.hidden = false
//        modalWindow.windowLevel = UIWindowLevelStatusBar+1
//        modalWindow.addSubview(azNotificationView)
//        // Create a -90 degree transform since the modal is always displayed in portrait for some reason
////        var newTransform:CGAffineTransform = CGAffineTransformMakeRotation(CGFloat(-M_PI / 2))
//        // Set the transform on the modal window
////        modalWindow.transform = newTransform
//        // Set the X and Y position of the modal window to 0
//        modalWindow.frame.origin.x = 0
//        modalWindow.frame.origin.y = 50
//        modalWindow.makeKeyAndVisible()
        
        azNotificationView.applyDynamics()
    }
    
    class func showNotificationWithTitle(title :String, controller :UIViewController, notificationType :AZNotificationType, shouldShowNotificationUnderNavigationBar :Bool)
    {
        let azNotificationView = AZNotificationView(title: title, referenceView: controller.view, notificationType: notificationType, showNotificationUnderNavigationBar: shouldShowNotificationUnderNavigationBar)
        
        azNotificationView.applyDynamics()
    }
 
//    func notificationTapped() {
//        print("AZNotification.swift notificationTapped")
//    }
    
}