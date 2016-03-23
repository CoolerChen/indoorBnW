//
//  MyCell.swift
//  testTable
//
//  Created by Bing on 2016/3/15.
//  Copyright © 2016年 Bing. All rights reserved.
//

import UIKit

class MyCell1: UITableViewCell {
    var lab1:UILabel = UILabel()
    var lab2:UILabel = UILabel()
    var lab3:UILabel = UILabel()
    var fontSize:CGFloat = 30
    //var m_timer:NSTimer!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        
    }
    //lab3.font = UIFont(name: "Bradley Hand", size: 200)
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        //Bradley Hand,Noteworthy,Chalkboard SE
        
        
        lab1.font = UIFont.boldSystemFontOfSize(20)
        lab1.adjustsFontSizeToFitWidth = true
        lab1.textColor = UIColor.blueColor()
        self.addSubview(lab1)
        
        
        lab2.font = UIFont.boldSystemFontOfSize(20)
        //lab2.textColor = UIColor.purpleColor()
        lab2.shadowOffset = CGSizeMake(1, 1)
        lab2.textColor = UIColor.lightGrayColor()
        lab2.adjustsFontSizeToFitWidth = true
        self.addSubview(lab2)
        
        lab3.textColor = UIColor.lightGrayColor()
        lab3.font = UIFont.boldSystemFontOfSize(20)
        lab3.adjustsFontSizeToFitWidth = true//
        self.addSubview(lab3)
        
        lab1.frame = CGRectMake(30, -self.frame.size.height, self.frame.size.width, 20)
        lab2.frame = CGRectMake(30, -self.frame.size.height, self.frame.size.width, 20)
        lab3.frame = CGRectMake(30, -self.frame.size.height, self.frame.size.width, 20)
        
        
        UIView.beginAnimations("MOveobjmati", context: nil)
        UIView.setAnimationDuration(1)
        lab1.frame = CGRectMake(30, 10, self.frame.size.width, 20)
        lab2.frame = CGRectMake(30, 40, self.frame.size.width, 20)
        lab3.frame = CGRectMake(30, 70, self.frame.size.width, 20)
        UIView.commitAnimations()
        //timer()
        
        
    }
    override func prepareForReuse() {
        lab1.frame = CGRectMake(30, -self.frame.size.height, self.frame.size.width, 20)
        lab2.frame = CGRectMake(30, -self.frame.size.height, self.frame.size.width, 20)
        lab3.frame = CGRectMake(30, -self.frame.size.height, self.frame.size.width, 20)
        
        
        UIView.beginAnimations("MOveobjmati", context: nil)
        UIView.setAnimationDuration(1)
        lab1.frame = CGRectMake(30, 10, self.frame.size.width, 20)
        lab2.frame = CGRectMake(30, 40, self.frame.size.width, 20)
        lab3.frame = CGRectMake(30, 70, self.frame.size.width, 20)
        UIView.commitAnimations()
        //timer()
    }
//    func timer(){
//        
//        m_timer = NSTimer.scheduledTimerWithTimeInterval(1/33, target: self, selector: Selector("onTimetick:"), userInfo: nil, repeats: true)
//        
//    }
//    func onTimetick(sender:NSTimer){
//        lab1.font = UIFont.boldSystemFontOfSize(fontSize)
//        lab2.font = UIFont.boldSystemFontOfSize(fontSize)
//        lab3.font = UIFont.boldSystemFontOfSize(fontSize)
//        fontSize-=1
//        if fontSize <= 20{
//            m_timer.invalidate()
//            lab1.font = UIFont.boldSystemFontOfSize(20)
//            lab2.font = UIFont.boldSystemFontOfSize(20)
//            lab3.font = UIFont.boldSystemFontOfSize(20)
//            fontSize = 30
//        }
//    }
    

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }

}
