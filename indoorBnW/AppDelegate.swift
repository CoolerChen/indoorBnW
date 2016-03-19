//
//  AppDelegate.swift
//  indoorBnW
//
//  Created by LEO on 2016/3/16.
//  Copyright © 2016年 LEO. All rights reserved.
//

import UIKit
//import sqlite3

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
//    var mainVC:Login?
    var mainVC:Setting?
    var navController:UINavigationController?
    
//    var user:User?
    var setting:Setting?
    
    var backScrollView:UIView!
    var scrollView:UIScrollView!
    var usedY:CGFloat = 0
    
    var mydb:COpaquePointer=nil

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        mainVC = Setting()
//        mainVC?.refreshWithFrame(window!.frame)
        
        //navController 的生成是  先把畫面丟給navController  再掛載navController
        //navController 內可以有多個畫面資料 但顯示出來的畫面只會有一個 .view
        navController = UINavigationController()
        navController?.pushViewController(mainVC!, animated: false)
        //window?.rootViewController = mainVC
        //window?.addSubview(navController!.view)
        window?.rootViewController = navController
        //不掛載mainVC  把mainVC丟給navController 再掛載navController
        //window?.addSubview(mainVC!.view)
        window?.makeKeyAndVisible()
        
        //設定beacon通知
        application.registerUserNotificationSettings(UIUserNotificationSettings (forTypes: [UIUserNotificationType.Sound, UIUserNotificationType.Alert, UIUserNotificationType.Badge], categories: nil))
        
        //設定資料庫
        let fmgr: NSFileManager = NSFileManager()
        let src: String = NSBundle.mainBundle().pathForResource("messagelocal", ofType: "db")!
        let dst: String = "\(NSHomeDirectory())/Documents/messagelocal.db"
            //首次執行
        if !fmgr.fileExistsAtPath(dst) {
            do {
                try fmgr.copyItemAtPath(src, toPath: dst)
            } catch let error as NSError {
                print(error)
            }
        }
            //建立連線
        if sqlite3_open(dst, &mydb) != SQLITE_OK {
            print("sql is not connect")
        }
        
        //建立images/msg資料夾
        do {
            print("準備建立msg資料夾")
            if !fmgr.fileExistsAtPath(NSHomeDirectory()+"/Documents/images/msg/") {
                print("建立images/msg資料夾")
                try fmgr.createDirectoryAtPath(NSHomeDirectory()+"/Documents/images/msg/", withIntermediateDirectories: true, attributes: nil)
            } else {
                print("msg資料夾已存在")
            }
        } catch let error as NSError {
            print("建立msg資料夾失敗：\(error)")
        }
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        
        if setting == nil {
            setting = Setting()
        }
        if setting?.getJsonCount() > 0 {
            print("AppDelegate: 有message資料 執行showMessageView")
            showMessageView()
        }
        
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    //MARK: - 顯示訊息
    func showMessageView() {
        backScrollView?.hidden = false
        
        
        if backScrollView == nil {
//        if backScrollView != nil {
//            backScrollView = nil
//        }
            let screenW = UIScreen.mainScreen().bounds.size.width
            let screenH = UIScreen.mainScreen().bounds.size.height
            
            //            msgView = UIView(frame: CGRectMake(0, 0, screenW, screenH-0))
            //            msgView!.backgroundColor = UIColor(red: 0.4, green: 0.4, blue: 0.4, alpha: 1)
            
            backScrollView = UIScrollView(frame: CGRectMake(0, 0, //x, y
                screenW, screenH*1.0)) //w, h
            backScrollView?.backgroundColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1)
            //            msgView?.transform = CGAffineTransformMakeScale(0.1, 0.1)
            
            self.window?.addSubview(backScrollView!)
        }
        
        
        let viewW = (backScrollView?.frame.width)!
        let viewH = (backScrollView?.frame.height)!
        
        

        if scrollView != nil {
            print("bb")
            (scrollView as UIView).removeFromSuperview()
        }
        
        //內ScrollView
        let viewStartY:CGFloat = 0
        
//        if scrollView == nil {
//            print("aa")
//        if scrollView != nil {
//            scrollView = nil
//        }
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
//        }
        
        scrollView.hidden = false
        
        //remove scrollview's subview
//        if scrollView.subviews.count == 0 {
//            print("0")
//        } else {
//            print("X0")
//        }
//        print("subviews count:\(scrollView.subviews.count)")
//        for v: UIView in scrollView.subviews {
//            if v.isKindOfClass(UIImageView) {
//                
//            } else {
//                v.removeFromSuperview()
//            }
//        }
        
        //標題
        let titleLabel = UILabel(frame: CGRectMake(
            (scrollView.frame.width - scrollView.frame.width*0.9)/2, //x
            usedY, //y
            scrollView.frame.width*0.9, 35)) //w, h
        titleLabel.backgroundColor = UIColor.lightGrayColor()
        titleLabel.text = json[0].objectForKey("messageTitle") as? String
print("標題: \(json[0].objectForKey("messageTitle") as? String)")
        scrollView.addSubview(titleLabel)
        usedY += titleLabel.frame.height + 20
        
        //副標題
        let subtitleLabel = UILabel(frame: CGRectMake(
            titleLabel.frame.origin.x, //x
            usedY, //y
            scrollView.frame.width*0.9, 35)) //w, h
        subtitleLabel.backgroundColor = UIColor.lightGrayColor()
        subtitleLabel.text = json[0].objectForKey("messageSubtitle") as? String
        scrollView.addSubview(subtitleLabel)
        usedY += subtitleLabel.frame.height + 20
        
        //內容
        let contentTextView = UITextView(frame: CGRectMake(
            titleLabel.frame.origin.x, //x
            usedY, //y
            scrollView.frame.width*0.9, 70)) //w, h
        contentTextView.backgroundColor = UIColor.lightGrayColor()
        contentTextView.font = UIFont(name: ".SFUIText-Regular", size: 17) //改變textview字型大小
        contentTextView.text = json[0].objectForKey("messageContent") as? String
        contentTextView.selectable = false
        scrollView.addSubview(contentTextView)
        usedY += contentTextView.frame.height + 20
        
        //圖片
        let imageImageView = UIImageView(frame: CGRectMake(
            (scrollView.frame.width - scrollView.frame.width*0.9)/2, //x
            usedY, //y
            scrollView.frame.width*0.9, 200)) //w, h
        imageImageView.backgroundColor = UIColor.lightGrayColor()
        imageImageView.userInteractionEnabled = false
        
        let imageName = json[0].objectForKey("messageImage") as? String
        let tempData = NSData(contentsOfURL: NSURL(string: "http://bing0112.100hub.net/bing/MessageImage/\(imageName!)")!)
        if tempData != nil {
            imageImageView.image = UIImage(data: tempData!)
        } else {
            imageImageView.backgroundColor = UIColor.redColor()
        }
        scrollView.addSubview(imageImageView)
        usedY += imageImageView.frame.height + 20 + 200
        
        //ScrollView ContentSize
        scrollView.contentSize = CGSizeMake(scrollView.frame.width, usedY)
        
        
//        print("AppDelegate: json = \(json)")
        json = [] //顯示訊息後清空，避免重複顯示
        Sup.User.IconBadgeNumber -= 1
//        UIApplication.sharedApplication().applicationIconBadgeNumber -= 1
//        UIApplication.sharedApplication().cancelAllLocalNotifications()
        
        
        scrollView.transform = CGAffineTransformMakeScale(0.1, 0.1)
        UIView.transitionWithView(scrollView, duration: 0.35, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
            self.scrollView.transform = CGAffineTransformMakeScale(1.1, 1.1);
            
            }, completion: { (finished: Bool) -> Void in
                //
                UIView.transitionWithView(self.scrollView, duration: 0.3, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
                    self.scrollView.transform = CGAffineTransformMakeScale(1.0, 1.0);
                    
                    }, completion: { (finished: Bool) -> Void in
                        //
//                        print("showMessage.swift 縮小訊息比例1.0")
                })
//                print("showMessage.swift 放大訊息比例1.1")
        })
        
        //add event
        let tapGesture = UITapGestureRecognizer(target: self, action: "viewTouch:")
        backScrollView?.addGestureRecognizer(tapGesture)
    }
    
    func viewTouch(sender: UITapGestureRecognizer) {
//        print("viewTouch \(sender)")
        
        scrollView.hidden = true
//        scrollView = nil
        backScrollView.hidden = true
//        backScrollView = nil
        
    }
    
    func application(application: UIApplication, didReceiveLocalNotification notification: UILocalNotification) {
        print("zzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz")
//        print(notification.category!)
        switch notification.category! {
            case "EnterMarket":
                print("EnterMarket")
            
            case "CloseProduct":
                print("CloseProduct")
            
            
            default:
                print("default")
        }
        
        UIApplication.sharedApplication().cancelLocalNotification(notification)
    }

}

