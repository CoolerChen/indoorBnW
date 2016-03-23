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
        
        azNotificationView.applyDynamics()
    }
    
    class func showNotificationWithTitle(title :String, controller :UIViewController, notificationType :AZNotificationType, shouldShowNotificationUnderNavigationBar :Bool)
    {
        let azNotificationView = AZNotificationView(title: title, referenceView: controller.view, notificationType: notificationType, showNotificationUnderNavigationBar: shouldShowNotificationUnderNavigationBar)
        
        azNotificationView.applyDynamics()
    }
}