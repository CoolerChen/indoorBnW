//
//  beacon.swift
//  Becon Test
//
//  Created by Alphanso Tech on 04/12/15.
//  Copyright © 2015 Alphanso Tech. All rights reserved.
//

import UIKit
import CoreLocation

let defaults=NSUserDefaults.standardUserDefaults()
let db = SQLiteDB.sharedInstance()
var getWhatData = ""
var jsons = []
var json = []
//var backScrollView:UIScrollView!
var isShow = false
var beaconRegion1:CLBeaconRegion!
var beaconRegion2:CLBeaconRegion!

extension Setting: CLLocationManagerDelegate, NSURLSessionDelegate, NSURLSessionDownloadDelegate {
    
    func setupBeacon() {
        locationManager.delegate = self
        
        // Enter Your iBeacon UUID
        let uuid = NSUUID(UUIDString: "F34A1A1F-500F-48FB-AFAA-9584D641D7B1")!
        let uuid2 = NSUUID(UUIDString: "F34A1A1F-500F-48FB-AFAA-9584D641D7B2")!
        
        // Use identifier like your company name or website
        let identifier = "com.appcoda.beacondemo"
        let identifier2 = "com.appcoda.beacondemo2"
        
        let Major:CLBeaconMajorValue = 1
        let Minor:CLBeaconMinorValue = 1
        let Major2:CLBeaconMajorValue = 1
        let Minor2:CLBeaconMinorValue = 2
        
        //第一個beaconRegion
        beaconRegion1 = CLBeaconRegion(proximityUUID: uuid, major: Major, minor: Minor, identifier: identifier)
//        beaconRegion1 = CLBeaconRegion(proximityUUID: uuid, identifier: identifier)
        // called delegate when Enter iBeacon Range
        beaconRegion1.notifyOnEntry = true
        // called delegate when Exit iBeacon Range
        beaconRegion1.notifyOnExit = true
        // ci: Notify whenever app enters or leaves a beacon region.
        beaconRegion1.notifyEntryStateOnDisplay = true
        
//        //第二個beaconRegion
        beaconRegion2 = CLBeaconRegion(proximityUUID: uuid2, major: Major2, minor: Minor2, identifier: identifier2)
        // called delegate when Enter iBeacon Range
        beaconRegion2.notifyOnEntry = true
        // called delegate when Exit iBeacon Range
        beaconRegion2.notifyOnExit = true
        // ci: Notify whenever app enters or leaves a beacon region.
        beaconRegion2.notifyEntryStateOnDisplay = true
        
        
        // Requests permission to use location services
        locationManager.requestAlwaysAuthorization()
        // Starts monitoring the specified iBeacon Region
        locationManager.startMonitoringForRegion(beaconRegion1)
        locationManager.startMonitoringForRegion(beaconRegion2)
        // ci: In order to make sure that iOS doesn’t stop location updates when the app is idle for some time and is in background, we should set this property as false.
        locationManager.pausesLocationUpdatesAutomatically = false
        
//        locationManager2.requestAlwaysAuthorization()
//        locationManager2.startMonitoringForRegion(beaconRegion2)
//        locationManager2.pausesLocationUpdatesAutomatically = false
    }
    
    func simpleAlert (title:String,message:String) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default,handler: nil))
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    
    //MARK: - CLLocationManager
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        
        switch status {
            
        case .AuthorizedAlways:
            // Starts the generation of updates that report the user’s current location.
            locationManager.startUpdatingLocation()
//            locationManager2.startUpdatingLocation()
            
        case .Restricted:
            
            // Your app is not authorized to use location services.
            
            simpleAlert("Permission Error", message: "Need Location Service Permission To Access Beacon")
            
            
        case .Denied:
            
            // The user explicitly denied the use of location services for this app or location services are currently disabled in Settings.
            
            simpleAlert("Permission Error", message: "Need Location Service Permission To Access Beacon")
            
        default:
            // handle .NotDetermined here
            
            // The user has not yet made a choice regarding whether this app can use location services.
            break
        }
    }
    
    func locationManager(manager: CLLocationManager, didStartMonitoringForRegion region: CLRegion) {
        
        // Tells the delegate that a iBeacon Area is being monitored
        
//        if region == beaconRegion1 {
//            locationManager.requestStateForRegion(region)
//        }
//        else if region == beaconRegion2 {
//            locationManager.requestStateForRegion(region)
//        }
//        if (region as! CLBeaconRegion).proximityUUID.UUIDString == "F34A1A1F-500F-48FB-AFAA-9584D641D7B1" {
            locationManager.requestStateForRegion(region)
//        } else if (region as! CLBeaconRegion).proximityUUID.UUIDString == "F34A1A1F-500F-48FB-AFAA-9584D641D7B2" {
//            locationManager2.requestStateForRegion(region)
//        }
    }
    
    func locationManager(manager: CLLocationManager, didEnterRegion region: CLRegion)
    {
        //        locationManager
//        print("which region : \(region.description)")
        
        // Tells the delegate that the user entered in iBeacon range or area.
        
        //        simpleAlert("Welcom", message: "Welcome to our store")
        //        getMessageData()
        
        /* This method called because
        beaconRegion.notifyOnEntry = true
        in setupBeacon() function
        */
        //
        let bgTask: UIBackgroundTaskIdentifier = UIApplication.sharedApplication().beginBackgroundTaskWithExpirationHandler({() -> Void in
            UIApplication.sharedApplication().endBackgroundTask(UIBackgroundTaskInvalid)
            print("beacon.swift: run bgTask")
            //            print("UIApplication.sharedApplication().endBackgroundTask(UIBackgroundTaskInvalid)")
        })
        if bgTask == UIBackgroundTaskInvalid {
            NSLog("beacon.swift: This application does not support background mode")
        }
        else {
            NSLog("beacon.swift: Application will continue to run in background")
        }
    }
    
    func locationManager(manager: CLLocationManager, didExitRegion region: CLRegion) {
        
        // Tells the delegate that the user exit the iBeacon range or area.
        
        //        simpleAlert("Good Bye", message: "Have a nice day")
        //        getMessageData()
        
        /* This method called because
        
        beaconRegion.notifyOnExit = true
        
        in setupBeacon() function
        */
        
    }
    
    func locationManager(manager: CLLocationManager, didDetermineState state: CLRegionState, forRegion region: CLRegion)
    {
        switch  state
        {
        case .Inside:
            //The user is inside the iBeacon range.
            locationManager.startRangingBeaconsInRegion(region as! CLBeaconRegion)
            break
            
        case .Outside:
            //The user is outside the iBeacon range.
            locationManager.stopRangingBeaconsInRegion(region as! CLBeaconRegion)
            break
            
        default :
            // it is unknown whether the user is inside or outside of the iBeacon range.
            break
        }
    }
    
    func locationManager(manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], inRegion region: CLBeaconRegion)
    {
        //==================== Tells the delegate that one or more beacons are in range. ====================
        let foundBeacons = beacons
        
        if foundBeacons.count > 0 {
            if let closestBeacon = foundBeacons[0] as? CLBeacon
            {
                if region.proximityUUID.UUIDString == "F34A1A1F-500F-48FB-AFAA-9584D641D7B1"
                {
                    var proximityMessage: String!
                    if lastStage1 != closestBeacon.proximity {
                        lastStage1 = closestBeacon.proximity
                        
                        switch  lastStage1 {
                            
                            case .Immediate:
                                proximityMessage = "Very close"
                                print("beacon.swift: Very close.1 ==========")
                                self.view.backgroundColor = UIColor.greenColor()
                                showNotificationWhenEnter()
                                
                            case .Near:
                                proximityMessage = "Near"
                                self.view.backgroundColor = UIColor.lightGrayColor()
                                print("beacon.swift: Near.1")
                                
                            case .Far:
                                proximityMessage = "Far"
                                self.view.backgroundColor = UIColor.blackColor()
                                print("beacon.swift: Far.1")
                            
                            default:
                                proximityMessage = "Where's the beacon?"
                                self.view.backgroundColor = UIColor.redColor()
                                print("beacon.swift: Where's the beacon.1")
                        }
                    }
                }
                else if region.proximityUUID.UUIDString == "F34A1A1F-500F-48FB-AFAA-9584D641D7B2"
                {
                    var proximityMessage: String!
                    if lastStage2 != closestBeacon.proximity {
                        lastStage2 = closestBeacon.proximity
                        
                        switch  lastStage2 {
                            
                            case .Immediate:
                                proximityMessage = "Very close"
                                
                                print("beacon.swift: Very close.2 ==========")
                                self.view.backgroundColor = UIColor.greenColor()
                                showNotificationWhenCloseProduct()
                                
                            case .Near:
                                proximityMessage = "Near"
                                self.view.backgroundColor = UIColor.lightGrayColor()
                                print("beacon.swift: Near.2")
                                
                            case .Far:
                                proximityMessage = "Far"
                                self.view.backgroundColor = UIColor.blackColor()
                                print("beacon.swift: Far.2")
                                
                            default:
                                proximityMessage = "Where's the beacon?"
                                self.view.backgroundColor = UIColor.redColor()
                                print("beacon.swift: Where's the beacon.2")
                        }
                    }
                }
                
            }
        }
    }
    
    //MARK: - NSURLSessionDownloadDelegate
    func URLSession(session: NSURLSession, downloadTask: NSURLSessionDownloadTask, didFinishDownloadingToURL location: NSURL)
    {
//print("beacon.swift: *** didFinishDownloadingToURL ***")
        switch getWhatData
        {
        case "getMessageData":
            getWhatData = ""
            do {
                let resp = String(data: NSData(contentsOfURL: location)!, encoding: NSUTF8StringEncoding)
                if resp! == "[{}]" {
//                    print("    db沒有資料")
                    
                } else {
//                    print("    db有資料，序列化")
                    json = try NSJSONSerialization.JSONObjectWithData(NSData(contentsOfURL: location)!, options: NSJSONReadingOptions.MutableContainers) as! NSArray
                    
                    let prepareTime     = json[0].objectForKey("messageType")! //訊息識別用
                    let prepareStore    = json[0].objectForKey("messageStore")! //商店名稱
                    let prepareTitle    = json[0].objectForKey("messageTitle")!
                    let prepareSubtitle = json[0].objectForKey("messageSubtitle")!
                    let prepareContent  = json[0].objectForKey("messageContent")!
                    let prepareImage    = prepareTime.stringByReplacingOccurrencesOfString(":", withString: "-") + ".jpg"
                    let imgUrl          = "http://bing0112.100hub.net/bing/MessageImage/"+String((json[0].objectForKey("messageImage"))!)
                    //更新手機sqlite資料庫
                    db.execute("update messagelocal set messageStore='\(prepareStore)', messageTitle='\(prepareTitle)', messageSubtitle='\(prepareSubtitle)', messageContent='\(prepareContent)', messageImage='\(prepareImage)' where messageTime='\(prepareTime)' ")
//                    db.execute("Insert into messagelocal(messageTime, messageStore, messageTitle, messageSubtitle, messageContent, messageImage, addFavorite) values('\(prepareTime)','\(prepareStore)','\(prepareTitle)','\(prepareSubtitle)','\(prepareContent)','\(prepareImage)','no') ")
                    print("beacon.swift: _ _ _ SQLiteDB 更新 _ _ _")
                    
                    //圖片寫入Document
                    let imgData = NSData(contentsOfURL: NSURL(string: imgUrl)!)
                    if imgData != nil {
                        let path = NSHomeDirectory() + "/Documents/images/msg/\(prepareImage)"
                        imgData?.writeToFile(path, atomically: false)
                    }
                }
                
            }catch let error as NSError {
                print("beacon.swift: There is an error. \(error)")
            }
            
        default:
            print("beacon.swift: default")
        }
    }
    
    //MARK: - Notification
    //偵測到iBeacon訊息，建立本地推播 取得線上資料
    func showNotificationWhenEnter() {
//        print("showNotificationWhenVeryClose")
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd_HH:mm:ss"
        let msgTime = dateFormatter.stringFromDate(NSDate())
        
        getMessageData(msgTime)
        let notificationString = "歡迎光臨 家樂福！\n點擊查看今日優惠"
        
        //本地推播
        let localNotification:UILocalNotification = UILocalNotification()
        localNotification.alertAction = "開啟"
        localNotification.alertBody = notificationString
//        localNotification.category = "EnterMarket"
        localNotification.category = msgTime
        localNotification.soundName = UILocalNotificationDefaultSoundName; //聲音
        //localNotification.soundName = "sound.caf";
        Sup.User.IconBadgeNumber += 1
        localNotification.applicationIconBadgeNumber = Sup.User.IconBadgeNumber
        localNotification.fireDate = NSDate(timeIntervalSinceNow: 0)
        UIApplication.sharedApplication().scheduleLocalNotification(localNotification)
        
        //先在sqlite建立初始資料，在didFinish下載完成後再update
        db.execute("Insert into messagelocal(messageTime, messageStore, messageTitle, messageSubtitle, messageContent, messageImage, addFavorite) values('\(msgTime)','','','','','','no') ")
        
        //App在前景才顯示前景通知
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        if appDelegate.statusBackOrFore == "fore" {
            AZNotification.showNotificationWithTitle(notificationString, controller: self, notificationType: AZNotificationType.Success, messageTime: msgTime)
        }
    }
    func showNotificationWhenCloseProduct() {
//        print("showNotificationWhenVeryClose")
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd_HH:mm:ss"
        let msgTime = dateFormatter.stringFromDate(NSDate())
        
        getMessageData2(msgTime)
        let notificationString = "果粉專賣店：\nMacbook Pro Retina 現正特價中"
        
        //本地推播
        let localNotification:UILocalNotification = UILocalNotification()
        localNotification.alertAction = "開啟"
        localNotification.alertBody = notificationString
//        localNotification.category = "CloseProduct"
        localNotification.category = msgTime
        localNotification.soundName = UILocalNotificationDefaultSoundName; //聲音
        //localNotification.soundName = "sound.caf";
        localNotification.fireDate = NSDate(timeIntervalSinceNow: 0)
        Sup.User.IconBadgeNumber += 1
        localNotification.applicationIconBadgeNumber = Sup.User.IconBadgeNumber
        UIApplication.sharedApplication().scheduleLocalNotification(localNotification)
        
        //先在sqlite建立初始資料，在didFinish下載完成後再update
        db.execute("Insert into messagelocal(messageTime, messageStore, messageTitle, messageSubtitle, messageContent, messageImage, addFavorite) values('\(msgTime)','','','','','','no') ")
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        if appDelegate.statusBackOrFore == "fore" {
            AZNotification.showNotificationWithTitle(notificationString, controller: self, notificationType: AZNotificationType.Success, messageTime: msgTime)
        }
    }
    
    func getMessageData(msgTime:String) {
//        print("=== 進入門口")
        
        getWhatData = "getMessageData"
        //寫入資料至資料庫
        let url = NSURL(string: "http://bing0112.100hub.net/bing/MessageLoad.php")
        let request: NSMutableURLRequest = NSMutableURLRequest(URL: url!)
        
        //"returnMessageType=EnterMarket" +
        let submitBody: String =
        "returnMessageType=\(msgTime)" +
        "&bySupervisor=Leo" +
        "&byStore=Leo-001"
//        print("下載訊息 => http://bing0112.100hub.net/bing/MessageLoad.php?\(submitBody)")
        
        request.HTTPMethod = "POST"
        request.HTTPBody = submitBody.dataUsingEncoding(NSUTF8StringEncoding)
        
        let sessionWithConfigure = NSURLSessionConfiguration.defaultSessionConfiguration()
        let session = NSURLSession(configuration: sessionWithConfigure, delegate: self, delegateQueue: NSOperationQueue.mainQueue())
        
        let dataTask = session.downloadTaskWithRequest(request)
        dataTask.resume()
//        print("beacon.swift: end ===== ")
    }
    
    func getMessageData2(msgTime:String) {
//        print("=== 靠近商品")
        
        getWhatData = "getMessageData"
        //寫入資料至資料庫
        let url = NSURL(string: "http://bing0112.100hub.net/bing/MessageLoad.php")
        let request: NSMutableURLRequest = NSMutableURLRequest(URL: url!)
        
        //"returnMessageType=CloseProductA" +
        let submitBody: String =
        "returnMessageType=\(msgTime)" +
        "&bySupervisor=Bing" +
        "&byStore=Bing-021"
//        print("下載訊息 => http://bing0112.100hub.net/bing/MessageLoad.php?\(submitBody)")
        
        request.HTTPMethod = "POST"
        request.HTTPBody = submitBody.dataUsingEncoding(NSUTF8StringEncoding)
        
        let sessionWithConfigure = NSURLSessionConfiguration.defaultSessionConfiguration()
        let session = NSURLSession(configuration: sessionWithConfigure, delegate: self, delegateQueue: NSOperationQueue.mainQueue())
        
        let dataTask = session.downloadTaskWithRequest(request)
        dataTask.resume()
    }
    
    func getJsonCount() -> Int {
        return json.count
    }
    
}

