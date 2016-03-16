//
//  Setting.swift
//  indoorB&W
//
//  Created by LEO on 2016/3/16.
//  Copyright © 2016年 Bing. All rights reserved.
//

import UIKit
import CoreLocation
import CoreBluetooth

class Setting: UIViewController, CBPeripheralManagerDelegate {
    var login:Login?
    var user:User?
    var supervisor:Supervisor?

    let locationManager = CLLocationManager()
    let myBTManager = CBPeripheralManager()
    var lastStage = CLProximity.Unknown
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.lightGrayColor()
        self.setupBeacon()
        
        //延遲換頁
        performSelector(Selector("showNextPage"), withObject: nil, afterDelay: 0.1)
    }
    
    func showNextPage() {
        if defaults.objectForKey("loginUser") != nil //有登入過
        {
            if Sup.userOrSupervisor == "supervisor" {
                self.navigationController?.pushViewController(supervisor!, animated: true)
            } else if Sup.userOrSupervisor == "user" {
                self.navigationController?.pushViewController(user!, animated: true)
            }
        }
        else {
            if login == nil {
                login = Login()
                login?.refreshWithFrame(self.view.frame)
            }
            self.navigationController?.pushViewController(login!, animated: true)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func peripheralManagerDidUpdateState(peripheral: CBPeripheralManager) {

        if peripheral.state == CBPeripheralManagerState.PoweredOff {

            simpleAlert("Beacon", message: "Turn On Your Device Bluetooh")
        }
    }
}
