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
        
        // Enter Your iBeacon UUID
        let uuid = NSUUID(UUIDString: "F34A1A1F-500F-48FB-AFAA-9584D641D7B1")!
        
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
        beaconRegion2 = CLBeaconRegion(proximityUUID: uuid, major: Major2, minor: Minor2, identifier: identifier2)
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
    }
    
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        
        switch status {
            
        case .AuthorizedAlways:
            // Starts the generation of updates that report the user’s current location.
            locationManager.startUpdatingLocation()
            
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
        locationManager.requestStateForRegion(region)
    }
    
    func locationManager(manager: CLLocationManager, didEnterRegion region: CLRegion)
    {
        //        locationManager
        print("which region : \(region.description)")
        
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
            locationManager.startRangingBeaconsInRegion(region as! CLBeaconRegion)
            
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
            locationManager.stopRangingBeaconsInRegion(region as! CLBeaconRegion)
            
            print("beacon.swift: stopRanging")
            
            break
            
        default :
            // it is unknown whether the user is inside or outside of the iBeacon range.
            break
        }
    }
    
    func locationManager(manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], inRegion region: CLBeaconRegion)
    {
        // Tells the delegate that one or more beacons are in range.
        let foundBeacons = beacons
        
        if foundBeacons.count > 0 {
            
            if let closestBeacon = foundBeacons[0] as? CLBeacon
            {
//                print("regionUUID: \(region.proximityUUID)")
//                print(closestBeacon.accuracy*100)
                var proximityMessage: String!
                if lastStage != closestBeacon.proximity {
                    
                    lastStage = closestBeacon.proximity
                    
                    switch  lastStage {
                        
                    case .Immediate:
                        proximityMessage = "Very close"
//                        if region == beaconRegion1 {
//                            print("beacon.swift: Very close1")
//                            self.view.backgroundColor = UIColor.greenColor()
//                            showNotificationWhenEnter()
//                        } else if region == beaconRegion2 {
//                            print("beacon.swift: Very close2")
//                            self.view.backgroundColor = UIColor.greenColor()
//                            showNotificationWhenCloseProduct()
//                        }
                        if region.minor == 1 {
                            print("beacon.swift: Very close1 ==========")
                            self.view.backgroundColor = UIColor.greenColor()
                            showNotificationWhenEnter()
                        } else if region.minor == 2 {
                            print("beacon.swift: Very close2 ==========")
                            self.view.backgroundColor = UIColor.greenColor()
                            showNotificationWhenCloseProduct()
                        }
                        
                        
                    case .Near:
                        proximityMessage = "Near"
                        if region == beaconRegion1 {
                            self.view.backgroundColor = UIColor.grayColor()
                            print("beacon.swift: Near")
                        }
                        
                        
                    case .Far:
                        proximityMessage = "Far"
                        if region == beaconRegion1 {
                            self.view.backgroundColor = UIColor.blackColor()
                            print("beacon.swift: Far")
                        }
                        
                        
                    default:
                        proximityMessage = "Where's the beacon?"
                        if region == beaconRegion1 {
                            self.view.backgroundColor = UIColor.redColor()
                            print("beacon.swift: Where's the beacon")
                        }
                        
                        
                    }
                    //                    var makeString = "Beacon Details:\n"
                    //                    makeString += "UUID = \(closestBeacon.proximityUUID.UUIDString)\n"
                    //                    makeString += "Identifier = \(region.identifier)\n"
                    //                    makeString += "Major Value = \(closestBeacon.major.intValue)\n"
                    //                    makeString += "Minor Value = \(closestBeacon.minor.intValue)\n"
                    //                    makeString += "Distance From iBeacon = \(proximityMessage)"
                    
                    //                    self.beaconStatus.text = makeString
                }
            }
        }
    }
    
    func showNotificationWhenEnter() {
        //        print("showNotificationWhenVeryClose")
        let localNotification:UILocalNotification = UILocalNotification()
        localNotification.alertAction = "Testing"
        localNotification.alertBody = "indoorBnW，歡迎光臨!"
        localNotification.category = "XXX"
        localNotification.soundName = UILocalNotificationDefaultSoundName; //聲音
        //localNotification.soundName = "sound.caf";
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
        localNotification.alertAction = "Testing"
        localNotification.alertBody = "indoorBnW，商品大特價!"
        localNotification.category = "XXX"
        localNotification.soundName = UILocalNotificationDefaultSoundName; //聲音
        //localNotification.soundName = "sound.caf";
        localNotification.fireDate = NSDate(timeIntervalSinceNow: 0)
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
        "bySupervisor=Leo" +
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
        "bySupervisor=Leo" +
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
                    print("    db沒有資料")
                    
                } else {
                    print("    db有資料")
                    json = try NSJSONSerialization.JSONObjectWithData(NSData(contentsOfURL: location)!, options: NSJSONReadingOptions.MutableContainers) as! NSArray
                    
                    print("=== json.count= \(json.count) ===========================")
                    //                    showData()
                }
                
            }catch {
                print("beacon.swift: There is an error.")
            }
            
        default:
            print("beacon.swift: default")
        }
    }
//    func showData() {
//        print("beacon.swift: showData")
//        //        print("enter")
//        //        if !isShow {
//        //            print("exit")
//        //            return
//        //        }
//        if backScrollView == nil {
//            print("beacon.swift: showData - set backScrollView")
//            backScrollView = UIScrollView(frame: CGRectMake(0, 0, //x, y
//                self.view.frame.width, self.view.frame.height*1.0)) //w, h
//            backScrollView.backgroundColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1)
//            self.view.addSubview(backScrollView)
//            
//            //            backScrollView.alpha = 0.0
//            backScrollView.transform = CGAffineTransformMakeScale(0.1, 0.1);
//            //            backScrollView.hidden = true
//            
//            //內ScrollView
//            let scrollView = UIScrollView(frame: CGRectMake(
//                (self.view.frame.width - self.view.frame.width*0.9)/2, //x
//                ((self.view.frame.height-64) - (self.view.frame.height-64)*0.85)/2 + 64, //y
//                self.view.frame.width*0.9, (self.view.frame.height-64)*0.85)) //w, h
//            scrollView.backgroundColor = UIColor(red: 0.85, green: 0.85, blue: 0.58, alpha: 1)
//            scrollView.layer.cornerRadius = 10
//            scrollView.layer.masksToBounds = true
//            backScrollView.addSubview(scrollView)
//            
//            //標題
//            let titleLabel = UILabel(frame: CGRectMake(
//                (scrollView.frame.width - scrollView.frame.width*0.9)/2, //x
//                10, //y
//                scrollView.frame.width*0.9, 35)) //w, h
//            titleLabel.backgroundColor = UIColor.lightGrayColor()
//            titleLabel.text = json[0].objectForKey("messageTitle") as? String
//            scrollView.addSubview(titleLabel)
//            
//            //副標題
//            let subtitleLabel = UILabel(frame: CGRectMake(
//                (scrollView.frame.width - scrollView.frame.width*0.9)/2, //x
//                55, //y
//                scrollView.frame.width*0.9, 35)) //w, h
//            subtitleLabel.backgroundColor = UIColor.lightGrayColor()
//            subtitleLabel.text = json[0].objectForKey("messageSubtitle") as? String
//            scrollView.addSubview(subtitleLabel)
//            
//            //內容
//            let contentTextView = UITextView(frame: CGRectMake(
//                (scrollView.frame.width - scrollView.frame.width*0.9)/2, //x
//                100, //y
//                scrollView.frame.width*0.9, 70)) //w, h
//            contentTextView.backgroundColor = UIColor.lightGrayColor()
//            contentTextView.font = UIFont(name: ".SFUIText-Regular", size: 17) //改變textview字型大小
//            contentTextView.text = json[0].objectForKey("messageContent") as? String
//            scrollView.addSubview(contentTextView)
//            
//            let imageImageView = UIImageView(frame: CGRectMake(
//                (scrollView.frame.width - scrollView.frame.width*0.9)/2, //x
//                180, //y
//                scrollView.frame.width*0.9, 200)) //w, h
//            //        imageImageView.backgroundColor = UIColor.lightGrayColor()
//            imageImageView.userInteractionEnabled = false
//            let tempData = NSData(contentsOfURL: NSURL(string: "http://bing0112.100hub.net/bing/MessageImage/Sample.jpg")!)
//            if tempData != nil {
//                imageImageView.image = UIImage(data: tempData!)
//            } else {
//                imageImageView.backgroundColor = UIColor.redColor()
//            }
//            scrollView.addSubview(imageImageView)
//            
//            //scrollView contenntSize
//            scrollView.contentSize = CGSizeMake(scrollView.frame.width, imageImageView.frame.origin.y + imageImageView.frame.height + 210)
//            
//            //add event
//            let tapGesture = UITapGestureRecognizer(target: self, action: "scrollViewTouch")
//            backScrollView.addGestureRecognizer(tapGesture)
//            
//            
//            json = []
//            
//            
//            UIView.transitionWithView(backScrollView, duration: 0.3, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
//                backScrollView.transform = CGAffineTransformMakeScale(1.1, 1.1);
//                
//                }, completion: { (finished: Bool) -> Void in
//                    //
//                    UIView.transitionWithView(backScrollView, duration: 0.3, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
//                        backScrollView.transform = CGAffineTransformMakeScale(1.0, 1.0);
//                        
//                        }, completion: { (finished: Bool) -> Void in
//                            //
//                            
//                            print("beacon.swift: 縮小1.0")
//                    })
//                    print("beacon.swift: 放大1.1")
//            })
//        }
//        print("beacon.swift: show data end")
//    }
//    
//    func scrollViewTouch() {
//        print("beacon.swift: scrollViewTouch")
//        if backScrollView != nil {
//            backScrollView.hidden = !backScrollView.hidden
//        }
//        backScrollView = nil
//    }
//    
//    func setShow() {
//        print("set json.count(\(json.count)) Show=\(isShow) ========== ")
//        if json.count > 0 {
//            //            isShow = true
//            //            showData()
//        }
//    }
    
//    func appMovedToBackground() {
//        //        print("-beacon.swift:  App moved to background!")
//        //        locationManager.stopMonitoringForRegion(beaconRegion)
//        //        locationManager.startMonitoringForRegion(beaconRegion)
//    }
//    func appMoveToForeground() {
//        //        print("-beacon.swift:  App moved to foreground!")
//        //        if json.count > 0 {
//        ////            self.performSelector(Selector("showData"), withObject: nil, afterDelay: 0.0)
//        ////            showData()
//        //        }
//    }
    
    func getJsonCount() -> Int {
        return json.count
    }
}

