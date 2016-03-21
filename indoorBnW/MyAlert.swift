//
//  MyAlert.swift
//  testTable
//
//  Created by Bing on 2016/3/15.
//  Copyright © 2016年 Bing. All rights reserved.
//

import UIKit

class MyAlert: UIAlertController {
    
    var imageViewAry:[UIImageView] = [UIImageView]()
    var m_timer:NSTimer!
    var dx = 1
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for var i:CGFloat = 0 ; i < 7 ; i++ {
            let view:UIImageView = UIImageView()
            view.image = UIImage(named: "ibeacon.png")
            view.frame = CGRectMake(self.view.frame.size.width/2-80, -50, 50, 50 )
            view.alpha = 0
            self.view.addSubview(view)
            imageViewAry.append(view)
        }
        
        let m_longPressRecognizer:UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: Selector("handleLongPressFrom:"))
        m_longPressRecognizer.minimumPressDuration = 0.1//長按時間
        m_longPressRecognizer.allowableMovement = 1.0 //移動的更新速率  手指開合的瞬間開始觸發
        m_longPressRecognizer.cancelsTouchesInView = false//被外來因素取消
        self.view.addGestureRecognizer(m_longPressRecognizer)
    }
    func handleLongPressFrom(longPressRecognizer:UILongPressGestureRecognizer){
    
        
        if longPressRecognizer.state == UIGestureRecognizerState.Began{
            if m_timer != nil{
                m_timer.invalidate()
            }
            self.moveImageView(longPressRecognizer.locationOfTouch(0, inView: self.view))
        }else if longPressRecognizer.state == UIGestureRecognizerState.Changed{
            self.moveImageView(longPressRecognizer.locationOfTouch(0, inView: self.view))
        }else if longPressRecognizer.state == UIGestureRecognizerState.Ended || longPressRecognizer.state == UIGestureRecognizerState.Cancelled{
            
            
            UIView.beginAnimations("MOveobjmati", context: nil)
            UIView.setAnimationDuration(1)
            for var i = 0 ; i < imageViewAry.count ; i++ {
                imageViewAry[i].frame = CGRectMake(self.view.frame.size.width/2-25, -50, 50, 50)
            }
            UIView.commitAnimations()
            self.performSelector(Selector("timer"), withObject: nil, afterDelay: 1)
        }
    }
    func moveImageView(longPressRecognizer:CGPoint){
        
        var delay:Double = 0.5
        UIView.beginAnimations("MOveobjmati", context: nil)
        for var i = 0 ; i < imageViewAry.count ; i++ {
            
            UIView.setAnimationDuration(delay)
            imageViewAry[i].center = longPressRecognizer
            delay += 0.3
            
        }
        UIView.commitAnimations()
        
    }
    override func viewDidAppear(animated: Bool) {
        UIView.beginAnimations("MOveobjmati", context: nil)
        UIView.setAnimationDuration(1)
        
        for var i = 0 ; i < imageViewAry.count ; i++ {
            imageViewAry[i].alpha = 1
        }
        
        timer()
        print("\(self.view.frame.size.width)")

    }
    func timer(){
        m_timer = NSTimer.scheduledTimerWithTimeInterval(1/33, target: self, selector: Selector("onTimetick:"), userInfo: nil, repeats: true)
    }
    func onTimetick(sender:NSTimer){
        
        for var i = 0 ; i < imageViewAry.count ; i++ {
            imageViewAry[i].center.x += CGFloat(dx)
        }
        
        if imageViewAry[0].center.x >= 175{
            dx *= -1
        }else if imageViewAry[0].center.x <= 95{
            dx *= -1
        }
    }
    override func viewDidDisappear(animated: Bool) {
        UIView.commitAnimations()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
