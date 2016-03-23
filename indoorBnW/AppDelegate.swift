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
    
    //顯示訊息
    var statusBackOrFore:String="back" //fore, back
    var backScrollView:UIView!
    var scrollView:UIScrollView!
    var closeImageView:UIImageView!
    var usedY:CGFloat = 0
    var notificationCategory:String = ""
    
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
        
        //偵測背景前景
        let notificationCenter = NSNotificationCenter.defaultCenter()
        notificationCenter.addObserver(self, selector: "appMovedToBackground", name: UIApplicationWillResignActiveNotification, object: nil)
        notificationCenter.addObserver(self, selector: "appMoveToForeground", name: UIApplicationDidBecomeActiveNotification, object: nil)
        
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
//            print("準備建立msg資料夾")
            if !fmgr.fileExistsAtPath(NSHomeDirectory()+"/Documents/images/msg/") {
//                print("建立images/msg資料夾")
                try fmgr.createDirectoryAtPath(NSHomeDirectory()+"/Documents/images/msg/", withIntermediateDirectories: true, attributes: nil)
            } else {
//                print("msg資料夾已存在")
            }
        } catch let error as NSError {
            print(error)
//            print("建立msg資料夾失敗：\(error)")
        }
        
//        UIApplication.sharedApplication().applicationIconBadgeNumber = 0
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
//        print("WillResignActive")
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
//        print("DidEnterBackground")
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
//        print("WillEnterForeground")
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
//        print("這邊 DidBecomeActive")
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
//        print("WillTerminate")
    }
    
    func application(application: UIApplication, didReceiveLocalNotification notification: UILocalNotification)
    {
//        print("didReceiveLocalNotification \(statusBackOrFore)")
//        print("AppDelegate.swift: notification.category! = \(notification.category!)")
        if statusBackOrFore == "back" {
            notificationCategory = notification.category!
            performSelector(Selector("beforeShowMessageView"), withObject: nil, afterDelay: 1.0)
            
            Sup.User.IconBadgeNumber -= 1
            UIApplication.sharedApplication().applicationIconBadgeNumber -= 1
            UIApplication.sharedApplication().cancelLocalNotification(notification)
        }
    }

    //MARK: - 顯示訊息
    func beforeShowMessageView() {
        let messageUIView = MessageUIView(referenceView: self.window!, getValueString: notificationCategory)
        self.window!.addSubview(messageUIView)
    }

    func appMovedToBackground() {
//        print("App moved to background! 背景")
        statusBackOrFore = "back"
    }
    func appMoveToForeground() {
//        print("App moved to foreground! 前景")
        statusBackOrFore = "fore"
    }
}

