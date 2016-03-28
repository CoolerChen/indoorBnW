//
//  MessageUIView.swift
//  indoorBnW
//
//  Created by LEO on 2016/3/22.
//  Copyright © 2016年 LEO. All rights reserved.
//

import UIKit

class MessageUIView: UIView {
    var referenceView = UIView()
    var getValueString = ""
    
    var backScrollView:UIView!
    var scrollView:UIScrollView!
    var closeImageView:UIImageView!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init(referenceView :UIView, getValueString :String)
    {
        self.referenceView = referenceView
        self.getValueString = getValueString
        print("字串 \(getValueString)")
        super.init(frame: CGRectMake(0, 0, referenceView.bounds.size.width, referenceView.bounds.size.height))
        setup()
    }
    
    func setup()
    {
        backScrollView?.hidden = false
        let scrollviewBackColor:UIColor = UIColor(red: 0.85, green: 0.85, blue: 0.58, alpha: 1)
        let txtBackgroundColor:UIColor = UIColor(red: 250/255.0, green: 243/255.0, blue: 203/255.0, alpha: 1)
        
        //
        let db = SQLiteDB.sharedInstance()
        let data = db.query("select * from messagelocal where messageTime='\(self.getValueString)' limit 1 ")
        
        if backScrollView == nil {
            let screenW = UIScreen.mainScreen().bounds.size.width
            let screenH = UIScreen.mainScreen().bounds.size.height
            
            backScrollView = UIView(frame: CGRectMake(0, 0, //x, y
                screenW, screenH*1.0)) //w, h
            backScrollView?.backgroundColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1)
            
            self.addSubview(backScrollView!)
        }
        
        let viewW = (backScrollView?.frame.width)!
        let viewH = (backScrollView?.frame.height)!
        let interval:CGFloat = 10
        let corRadius:CGFloat = 5
        let viewStartY:CGFloat = 20
        
        if scrollView != nil {
            (scrollView as UIView).removeFromSuperview()
        }
        if self.closeImageView != nil {
            self.closeImageView.removeFromSuperview()
        }
        
        //內ScrollView
        scrollView = UIScrollView(frame: CGRectMake(
            (viewW - viewW*0.9)/2, //x
            (( viewH-viewStartY ) - ( viewH-viewStartY )*0.9)/2 + viewStartY, //y
            viewW*0.9,
            ( viewH-viewStartY )*0.9)) //w, h
        //        scrollView = UIScrollView(frame: CGRectMake(
        //            (viewW - viewW*0.9)/2, //x
        //            (viewH - viewH*0.85)/2 + viewStartY, //y
        //            viewW*0.9,
        //            ( viewH-viewStartY )*0.85)) //w, h
        scrollView.backgroundColor = scrollviewBackColor
        scrollView.layer.cornerRadius = corRadius*2
        scrollView.layer.masksToBounds = true
        self.addSubview(scrollView)
        usedY = 20
        
        scrollView.hidden = false
        
        //商店
        if data.count > 0 {
            if (data[0]["messageStore"] as! String) != "" {
                let storeLabel = UILabel(frame: CGRectMake(
                    (scrollView.frame.width - scrollView.frame.width*0.9)/2, //x
                    usedY, //y
                    scrollView.frame.width*0.9, 35)) //w, h
                storeLabel.backgroundColor = txtBackgroundColor
                storeLabel.layer.cornerRadius = corRadius
                storeLabel.layer.masksToBounds = true
                storeLabel.text = data[0]["messageStore"] as! String
                scrollView.addSubview(storeLabel)
                usedY += storeLabel.frame.height + interval
            }
        }
        
        //標題
        let titleLabel = UILabel(frame: CGRectMake(
            (scrollView.frame.width - scrollView.frame.width*0.9)/2, //x
            usedY, //y
            scrollView.frame.width*0.9, 35)) //w, h
        titleLabel.backgroundColor = txtBackgroundColor
        titleLabel.layer.cornerRadius = corRadius
        titleLabel.layer.masksToBounds = true
        titleLabel.font = UIFont(name: ".SFUIText-Regular", size: 15)
        //        titleLabel.text = json[0].objectForKey("messageTitle") as? String
        titleLabel.text = data.count>0 ? data[0]["messageTitle"] as! String : ""
        //        print(data[0]["messageTitle"] as! String)
        //print("標題: \(json[0].objectForKey("messageTitle") as? String)")
        scrollView.addSubview(titleLabel)
        usedY += titleLabel.frame.height + interval
        
        //副標題
        let subtitleLabel = UILabel(frame: CGRectMake(
            titleLabel.frame.origin.x, //x
            usedY, //y
            scrollView.frame.width*0.9, 35)) //w, h
        subtitleLabel.backgroundColor = txtBackgroundColor
        subtitleLabel.layer.cornerRadius = corRadius
        subtitleLabel.layer.masksToBounds = true
        subtitleLabel.font = UIFont(name: ".SFUIText-Regular", size: 15)
        //        subtitleLabel.text = json[0].objectForKey("messageSubtitle") as? String
        subtitleLabel.text = data.count>0 ? data[0]["messageSubtitle"] as! String : ""
//print("subtitleLabel.text \(subtitleLabel.text)")
        scrollView.addSubview(subtitleLabel)
        usedY += subtitleLabel.frame.height + interval
        
        //內容
        let contentTextView = UITextView(frame: CGRectMake(
            titleLabel.frame.origin.x, //x
            usedY, //y
            scrollView.frame.width*0.9, 100)) //w, h
        contentTextView.backgroundColor = txtBackgroundColor
        contentTextView.layer.cornerRadius = corRadius
        contentTextView.layer.masksToBounds = true
        contentTextView.font = UIFont(name: ".SFUIText-Regular", size: 15) //改變textview字型大小
        //        contentTextView.text = json[0].objectForKey("messageContent") as? String
        contentTextView.text = data.count>0 ? data[0]["messageContent"] as! String : ""
        //        print(data[0]["messageContent"] as! String)
        contentTextView.selectable = false
        scrollView.addSubview(contentTextView)
        usedY += contentTextView.frame.height + interval
        
        //圖片
        let imageImageView = UIImageView(frame: CGRectMake(
            (scrollView.frame.width - scrollView.frame.width*0.9)/2, //x
            usedY, //y
            scrollView.frame.width*0.9, 200)) //w, h
        imageImageView.backgroundColor = txtBackgroundColor
        imageImageView.layer.cornerRadius = corRadius
        imageImageView.layer.masksToBounds = true
        imageImageView.userInteractionEnabled = false
        
        let imageName = data.count>0 ? data[0]["messageImage"] as! String : ""
        //        print(imageName)
        if imageName != "" {
            //            let tempData = NSData(contentsOfURL: NSURL(string: "http://bing0112.100hub.net/bing/MessageImage/\(imageName)")!)
            let tempData = NSData(contentsOfFile: NSHomeDirectory() + "/Documents/images/msg/" + imageName)
            if tempData != nil {
                imageImageView.image = UIImage(data: tempData!)
            }
        }
        scrollView.addSubview(imageImageView)
        usedY += imageImageView.frame.height + interval
        
        //ScrollView ContentSize
        scrollView.contentSize = CGSizeMake(scrollView.frame.width, usedY)
        
        //        json = [] //顯示訊息後清空，避免重複顯示
        
        scrollView.transform = CGAffineTransformMakeScale(0.1, 0.1)
        UIView.transitionWithView(scrollView, duration: 0.35, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void
            in
            self.scrollView.transform = CGAffineTransformMakeScale(1.1, 1.1);
            
            }, completion: { (finished: Bool) -> Void in
                //
                UIView.transitionWithView(self.scrollView, duration: 0.3, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
                    self.scrollView.transform = CGAffineTransformMakeScale(1.0, 1.0);
                    
                    }, completion: { (finished: Bool) -> Void in
                        //
                        //                        print("showMessage.swift 縮小訊息比例1.0")
//                        //關閉訊息圖案XX
//                        let closeW:CGFloat = 35
//                        self.closeImageView = UIImageView(frame: CGRectMake(
//                            (viewW - viewW*0.1/2) - closeW/2 - 2, //x
//                            (( viewH-viewStartY ) - ( viewH-viewStartY )*0.85)/2 + viewStartY - closeW/2 + 2, //y
//                            35, 35)) //w, h
//                        //        print("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ \(closeImageView.frame.origin.x) \(closeImageView.frame.origin.y)")
//                        self.closeImageView.userInteractionEnabled = true
//                        self.closeImageView.layer.cornerRadius = corRadius
//                        self.closeImageView.layer.masksToBounds = true
//                        self.closeImageView.image = UIImage(named: "close")
//                        self.backScrollView.addSubview(self.closeImageView)
//                        //加入event
//                        let closeimgTapGesture = UITapGestureRecognizer(target: self, action: "viewTouch:")
//                        self.closeImageView.addGestureRecognizer(closeimgTapGesture)
//                        
//                        //2
//                        let closeImageView2 = UIImageView(frame: CGRectMake(
//                            self.scrollView.frame.width - closeW/2 - 2, //x
//                            -closeW/2 + 2, //y
//                            35, 35)) //w, h
//                        //        print("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ \(closeImageView.frame.origin.x) \(closeImageView.frame.origin.y)")
//                        closeImageView2.userInteractionEnabled = true
//                        closeImageView2.layer.cornerRadius = corRadius
//                        closeImageView2.layer.masksToBounds = true
//                        closeImageView2.image = UIImage(named: "close")
//                        self.scrollView.addSubview(closeImageView2)
//                        //加入event
//                        let closeimgTapGesture2 = UITapGestureRecognizer(target: self, action: "viewTouch:")
//                        closeImageView2.addGestureRecognizer(closeimgTapGesture2)
                        //關閉訊息圖案XX
                        let closeW:CGFloat = 35
                        self.closeImageView = UIImageView(frame: CGRectMake(
                            (viewW - viewW*0.1/2) - closeW/2 - 2, //x
                            (( viewH-viewStartY ) - ( viewH-viewStartY )*0.9)/2 + viewStartY - closeW/2 + 2, //y
                            35, 35)) //w, h
                        //        print("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ \(closeImageView.frame.origin.x) \(closeImageView.frame.origin.y)")
                        self.closeImageView.userInteractionEnabled = true
                        self.closeImageView.layer.cornerRadius = corRadius
                        self.closeImageView.layer.masksToBounds = true
                        self.closeImageView.image = UIImage(named: "close")
                        self.addSubview(self.closeImageView)
                        //加入event
                        let closeimgTapGesture1 = UITapGestureRecognizer(target: self, action: "viewTouch:")
                        self.closeImageView.addGestureRecognizer(closeimgTapGesture1)
                })
                //                print("showMessage.swift 放大訊息比例1.1")
        })
        
        //add event
        let viewTapGesture = UITapGestureRecognizer(target: self, action: "viewTouch:")
        backScrollView?.addGestureRecognizer(viewTapGesture)
    }
    
    func viewTouch(sender: UITapGestureRecognizer) {
        backScrollView.hidden = true
        scrollView.hidden = true
        closeImageView.hidden = true
        self.hidden = true
    }
}
