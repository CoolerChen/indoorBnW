//
//  BingDelegate.swift
//  indoorBnW
//
//  Created by Bing on 2016/3/17.
//  Copyright © 2016年 LEO. All rights reserved.
//

import UIKit

protocol BingLoginDelegate{
    func gotowhere() -> UIViewController
}
class Bing {
    var delegate:BingLoginDelegate?
    var me:UIViewController?
    var vc:UIViewController?
    init(del:BingLoginDelegate){
        me = del as? UIViewController
        delegate = del
    }
    func go(){
        vc = delegate?.gotowhere()
        me?.navigationController?.pushViewController(vc!, animated: true)
    }
}
