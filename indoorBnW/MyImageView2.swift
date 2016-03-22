//
//  MyImageView2.swift
//  testTable
//
//  Created by Bing on 2016/3/20.
//  Copyright © 2016年 Bing. All rights reserved.
//

import UIKit

class MyImageView2: UIImageView {
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setTarget(Target:UIViewController){
        let m_longPressRecognizer:UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: Target, action: Selector("handleLongPressFrom:"))
        m_longPressRecognizer.minimumPressDuration = 0.1//長按時間
        m_longPressRecognizer.allowableMovement = 1.0 //移動的更新速率  手指開合的瞬間開始觸發
        m_longPressRecognizer.cancelsTouchesInView = false//被外來因素取消
        self.addGestureRecognizer(m_longPressRecognizer)
    }
    

}
