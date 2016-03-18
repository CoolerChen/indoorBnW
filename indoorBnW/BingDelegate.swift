//
//  BingDelegate.swift
//  indoorBnW
//
//  Created by Bing on 2016/3/17.
//  Copyright © 2016年 LEO. All rights reserved.
//

import UIKit

protocol BingDelegate{
    func gotowhere() -> UIViewController
    
}


class Bing {
    var delegate:BingDelegate?
    var me:UIViewController?
    var vc:UIViewController?
    init(del:BingDelegate){
        me = del as? UIViewController
        delegate = del
    }
    func go(){
        vc = delegate?.gotowhere()
        me?.navigationController?.pushViewController(vc!, animated: true)
    }
}
