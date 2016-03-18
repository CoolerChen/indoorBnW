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
var getWhatData = ""
var jsons = []
var json = []
var backScrollView:UIScrollView!
var isShow = false
var beaconRegion1:CLBeaconRegion!
var beaconRegion2:CLBeaconRegion!

extension Setting: CLLocationManagerDelegate, NSURLSessionDelegate, NSURLSessionDownloadDelegate {
    
    func setupBeacon() {
//        let notificationCenter = NSNotificationCenter.defaultCenter()
//        notificationCenter.addObserver(self, selector: "appMovedToBackground", name: UIApplicationWillResignActiveNotification, object: nil)
//        notificationCenter.addObserver(self, selector: "appMoveToForeground", name: UIApplicationDidBecomeActiveNotification, object: nil)
        
        print("setupBeacon")
        locationManager.delegate = self
//        locationManager2.delegate = self
        
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
    
    func simpleAlert (title:String,message:String) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default,handler: nil))
        
        self.presentViewController(alertController, animated: true, completion: nil)
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
            
//            if region == beaconRegion1 {
//                locationManager.startRangingBeaconsInRegion(region as! CLBeaconRegion)
//            }
//            else if region == beaconRegion2 {
//                locationManager.startRangingBeaconsInRegion(region as! CLBeaconRegion)
//            }
            
//            if (region as! CLBeaconRegion).proximityUUID.UUIDString == "F34A1A1F-500F-48FB-AFAA-9584D641D7B1" {
                locationManager.startRangingBeaconsInRegion(region as! CLBeaconRegion)
//                print("beacon.swift: startRanging1")
//            } else if (region as! CLBeaconRegion).proximityUUID.UUIDString == "F34A1A1F-500F-48FB-AFAA-9584D641D7B2" {
//                locationManager2.startRangingBeaconsInRegion(region as! CLBeaconRegion)
//                print("beacon.swift: startRanging2")
//            }
            print("beacon.swift: startRanging")
            
            break
            
        case .Outside:
            //The user is outside the iBeacon range.
            
//            if region == beaconRegion1 {
//                locationManager.stopRangingBeaconsInRegion(region as! CLBeaconRegion)
//            }
//            else if region == beaconRegion2 {
//                locationManager.stopRangingBeaconsInRegion(region as! CLBeaconRegion)
//            }
            
//            print("region uuid: \((region as! CLBeaconRegion).proximityUUID.UUIDString)")
//            if (region as! CLBeaconRegion).proximityUUID.UUIDString == "F34A1A1F-500F-48FB-AFAA-9584D641D7B1" {
                locationManager.stopRangingBeaconsInRegion(region as! CLBeaconRegion)
//                print("beacon.swift: stopRanging1")
//            } else if (region as! CLBeaconRegion).proximityUUID.UUIDString == "F34A1A1F-500F-48FB-AFAA-9584D641D7B2" {
//                locationManager2.stopRangingBeaconsInRegion(region as! CLBeaconRegion)
//                print("beacon.swift: stopRanging2")
//            }
            print("beacon.swift: stopRanging")
            
            break
            
        default :
            // it is unknown whether the user is inside or outside of the iBeacon range.
            break
        }
    }
    
    func locationManager(manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], inRegion region: CLBeaconRegion)
    {
        //1.
//        if region.proximityUUID.UUIDString == "F34A1A1F-500F-48FB-AFAA-9584D641D7B1"
//        {
//            let foundBeacons = beacons
//            if foundBeacons.count > 0 {
//                if let closestBeacon = foundBeacons[0] as? CLBeacon {
//                    var proximityMessage: String!
//                    if lastStage != closestBeacon.proximity {
//                        lastStage = closestBeacon.proximity
//                        switch lastStage {
//                            case .Immediate:
//                                proximityMessage = "Very close"
//                                print("beacon.swift: Very close1 ==========")
//                                self.view.backgroundColor = UIColor.greenColor()
//                                showNotificationWhenEnter()
//                            case .Near:
//                                proximityMessage = "Near"
//                                print("beacon.swift: Near1")
//                            
//                            case .Far:
//                                proximityMessage = "Far"
//                            default:
//                                proximityMessage = "Where's the beacon?"
//                        }
//                    }
//                }
//            }
//        }
//        else if region.proximityUUID.UUIDString == "F34A1A1F-500F-48FB-AFAA-9584D641D7B2"
//        {
//            let foundBeacons = beacons
//            if foundBeacons.count > 0 {
//                if let closestBeacon = foundBeacons[0] as? CLBeacon {
//                    var proximityMessage: String!
//                    if lastStage2 != closestBeacon.proximity {
//                        lastStage2 = closestBeacon.proximity
//                        switch lastStage2 {
//                        case .Immediate:
//                            proximityMessage = "Very close"
//                            print("beacon.swift: Very close2 ==========")
//                            self.view.backgroundColor = UIColor.greenColor()
//                            showNotificationWhenCloseProduct()
//                        case .Near:
//                            proximityMessage = "Near"
//                            print("beacon.swift: Near2")
//                        case .Far:
//                            proximityMessage = "Far"
//                        default:
//                            proximityMessage = "Where's the beacon?"
//                        }
//                    }
//                }
//            }
//        }
        
        //2.
        //==================== Tells the delegate that one or more beacons are in range. ====================
        let foundBeacons = beacons
        
        if foundBeacons.count > 0 {
            if let closestBeacon = foundBeacons[0] as? CLBeacon
            {
//                print(closestBeacon.accuracy*100)
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
    
    func showNotificationWhenEnter() {
//        print("showNotificationWhenVeryClose")
        let localNotification:UILocalNotification = UILocalNotification()
        localNotification.alertAction = "開啟"
        localNotification.alertBody = "indoorBnW，歡迎光臨!"
        localNotification.category = "EnterMarket"
        localNotification.soundName = UILocalNotificationDefaultSoundName; //聲音
        //localNotification.soundName = "sound.caf";
        Sup.User.IconBadgeNumber += 1
        localNotification.applicationIconBadgeNumber = Sup.User.IconBadgeNumber
        localNotification.fireDate = NSDate(timeIntervalSinceNow: 0)
        UIApplication.sharedApplication().scheduleLocalNotification(localNotification)
        
        if getWhatData != "getMessageData" {
            getMessageData()
            print("showNotificationWhenEnter ----------")
        } else {
            print("-----------------------------------1")
        }
    }
    func showNotificationWhenCloseProduct() {
//        print("showNotificationWhenVeryClose")
        let localNotification:UILocalNotification = UILocalNotification()
        localNotification.alertAction = "開啟"
        localNotification.alertBody = "indoorBnW，商品大特價!"
        localNotification.category = "CloseProduct"
        localNotification.soundName = UILocalNotificationDefaultSoundName; //聲音
        //localNotification.soundName = "sound.caf";
        localNotification.fireDate = NSDate(timeIntervalSinceNow: 0)
        Sup.User.IconBadgeNumber += 1
        localNotification.applicationIconBadgeNumber = Sup.User.IconBadgeNumber
        UIApplication.sharedApplication().scheduleLocalNotification(localNotification)
        
        if getWhatData != "getMessageData" {
            getMessageData2()
            print("showNotificationWhenCloseProduct ----------")
        } else {
            print("-------------------------------------------")
        }
        
    }
    
    func getMessageData() {
//        print("=== 進入門口")
        
        getWhatData = "getMessageData"
        //寫入資料至資料庫
        let url = NSURL(string: "http://bing0112.100hub.net/bing/MessageLoad.php")
        let request: NSMutableURLRequest = NSMutableURLRequest(URL: url!)
        
        let submitBody: String =
        "returnMessageType=EnterMarket" +
        "&bySupervisor=Leo" +
        "&byStore=Leo-001"
        print("下載訊息 => http://bing0112.100hub.net/bing/MessageLoad.php?\(submitBody)")
        
        request.HTTPMethod = "POST"
        request.HTTPBody = submitBody.dataUsingEncoding(NSUTF8StringEncoding)
        
        let sessionWithConfigure = NSURLSessionConfiguration.defaultSessionConfiguration()
        let session = NSURLSession(configuration: sessionWithConfigure, delegate: self, delegateQueue: NSOperationQueue.mainQueue())
        
        let dataTask = session.downloadTaskWithRequest(request)
        dataTask.resume()
//        print("beacon.swift: end ===== ")
    }
    
    func getMessageData2() {
//        print("=== 靠近商品")
        
        getWhatData = "getMessageData"
        //寫入資料至資料庫
        let url = NSURL(string: "http://bing0112.100hub.net/bing/MessageLoad.php")
        let request: NSMutableURLRequest = NSMutableURLRequest(URL: url!)
        
        let submitBody: String =
        "returnMessageType=CloseProductA" +
        "&bySupervisor=Leo" +
        "&byStore=Leo-004"
        print("下載訊息 => http://bing0112.100hub.net/bing/MessageLoad.php?\(submitBody)")
        
        request.HTTPMethod = "POST"
        request.HTTPBody = submitBody.dataUsingEncoding(NSUTF8StringEncoding)
        
        let sessionWithConfigure = NSURLSessionConfiguration.defaultSessionConfiguration()
        let session = NSURLSession(configuration: sessionWithConfigure, delegate: self, delegateQueue: NSOperationQueue.mainQueue())
        
        let dataTask = session.downloadTaskWithRequest(request)
        dataTask.resume()
        print("beacon.swift: end ===== ")
    }
    
    func URLSession(session: NSURLSession, downloadTask: NSURLSessionDownloadTask, didFinishDownloadingToURL location: NSURL)
    {
//        print("beacon.swift: *** didFinishDownloadingToURL ***")
        switch getWhatData
        {
        case "getMessageData":
//            print("    didfinish getMessageData")
            getWhatData = ""
            do {
                let resp = String(data: NSData(contentsOfURL: location)!, encoding: NSUTF8StringEncoding)
                if resp! == "[{}]" {
//                    print("    db沒有資料")
                    
                } else {
//                    print("    db有資料")
                    json = try NSJSONSerialization.JSONObjectWithData(NSData(contentsOfURL: location)!, options: NSJSONReadingOptions.MutableContainers) as! NSArray
                    
//                    print("=-=-=-=-=-=-=-=-= json[0].objectForKey(messageType) = \(json[0].objectForKey("messageType")!)")
                    
                    
                    //test
                    let dateFormatter = NSDateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd_HH:mm:ss"
            //        dateFormatter.dateStyle = NSDateFormatterStyle.ShortStyle
            //        dateFormatter.timeStyle = NSDateFormatterStyle.ShortStyle
                    let prepareTime = dateFormatter.stringFromDate(NSDate())
                    
                    let prepareStore    = json[0].objectForKey("messageStore")!
                    let prepareTitle    = json[0].objectForKey("messageTitle")!
                    let prepareSubtitle = json[0].objectForKey("messageSubtitle")!
                    let prepareContent  = json[0].objectForKey("messageContent")!
                    let prepareImage    = prepareTime.stringByReplacingOccurrencesOfString(":", withString: "-") + ".jpg"
                    
                    //寫入手機sqlite資料庫
                    let db = SQLiteDB.sharedInstance()
                    let data = db.query("Insert into messagelocal(messageTime, messageStore, messageTitle, messageSubtitle, messageContent, messageImage) values('\(prepareTime)','\(prepareStore)','\(prepareTitle)','\(prepareSubtitle)','\(prepareContent)','\(prepareImage)') ")
//                    print("_ _ _SQLiteDB query test _ _ _")
//                    print("=-=-=-=-=-=-=-=-=-= \(data) =-=-=-=-=-=-=-=-=-=")
                    print("Insert into messagelocal(messageTime, messageStore, messageTitle, messageSubtitle, messageContent, messageImage) values('\(prepareTime)','\(prepareStore)','\(prepareTitle)','\(prepareSubtitle)','\(prepareContent)','\(prepareImage)') ")
                    
//                    let asdf:UIScrollView = UIScrollView(frame: CGRectMake(0,0,100,100))
                }
                
            }catch let error as NSError {
                print("beacon.swift: There is an error. \(error)")
            }
            
        default:
            print("beacon.swift: default")
        }
    }
    
    func getJsonCount() -> Int {
        return json.count
    }
    
}

