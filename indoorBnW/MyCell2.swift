//
//  MyCell2.swift
//  testTable
//
//  Created by Bing on 2016/3/16.
//  Copyright © 2016年 Bing. All rights reserved.
//

import UIKit

class MyCell2: UITableViewCell {
    var lab1:UILabel = UILabel()
    var lab2:UILabel = UILabel()
    var lab3:UILabel = UILabel()
    var textView:UITextView = UITextView()
    var imgView:UIImageView = UIImageView()
    let view:UIView = UIView()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        
        //imgView.image = UIImage(named: "ball.png")
        self.addSubview(imgView)
        
        
        lab1.font = UIFont.boldSystemFontOfSize(20)
        lab1.adjustsFontSizeToFitWidth = true
        lab1.textColor = UIColor.blueColor()
        self.addSubview(lab1)

        //lab2.font = UIFont.boldSystemFontOfSize(20)
        lab2.font = UIFont.boldSystemFontOfSize(20)//UIFont(name: "Bradley Hand", size: 20)
        lab2.textColor = UIColor.blueColor()
        lab2.shadowOffset = CGSizeMake(1, 1)
        lab2.adjustsFontSizeToFitWidth = true
        self.addSubview(lab2)
//
        lab3.font = UIFont.boldSystemFontOfSize(20)
        lab3.adjustsFontSizeToFitWidth = true//
        lab3.textColor = UIColor.blueColor()
        self.addSubview(lab3)
        
        self.addSubview(textView)
        
        
        view.frame = CGRectMake(self.frame.size.width, 110, self.frame.size.width, 100)
        view.backgroundColor = UIColor(red: 0.36, green: 0.68, blue: 1, alpha: 0.7)
        
        self.addSubview(view)
        
        
        textView.frame = CGRectMake(self.frame.size.width, 110, self.frame.size.width-10, 100)
        imgView.frame = CGRectMake(self.frame.size.width, 10, 90, 90)
        lab1.frame = CGRectMake(self.frame.size.width, 10, self.frame.size.width - 100, 30)
        lab2.frame = CGRectMake(self.frame.size.width, 40, self.frame.size.width - 100, 30)
        lab3.frame = CGRectMake(self.frame.size.width, 60, self.frame.size.width, 30)

        UIView.beginAnimations("MOveobjmati", context: nil)
        UIView.setAnimationDuration(1)
        lab1.frame = CGRectMake(110, 10, self.frame.size.width - 100, 30)
        lab2.frame = CGRectMake(110, 40, self.frame.size.width - 100, 30)
        lab3.frame = CGRectMake(110, 60, self.frame.size.width, 30)
        imgView.frame = CGRectMake(10, 10, 90, 90)
        textView.frame = CGRectMake(10, 110, self.frame.size.width, 100)
        view.frame = CGRectMake(10, 110, self.frame.size.width, 100)
        UIView.commitAnimations()
        
        
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError("init(coder:) has not been implemented")
    }
    //準備被拿出來重用
    override func prepareForReuse() {
        super.prepareForReuse()
        view.frame = CGRectMake(self.frame.size.width, 110, self.frame.size.width, 100)
        textView.frame = CGRectMake(self.frame.size.width, 110, self.frame.size.width, 100)
        imgView.frame = CGRectMake(self.frame.size.width, 10, 90, 90)
        lab1.frame = CGRectMake(self.frame.size.width, 10, self.frame.size.width - 100, 30)
        lab2.frame = CGRectMake(self.frame.size.width, 40, self.frame.size.width - 100, 30)
        lab3.frame = CGRectMake(self.frame.size.width, 60, self.frame.size.width, 30)
        
        UIView.beginAnimations("MOveobjmati", context: nil)
        UIView.setAnimationDuration(1)
        lab1.frame = CGRectMake(110, 10, self.frame.size.width - 100, 30)
        lab2.frame = CGRectMake(110, 40, self.frame.size.width - 100, 30)
        lab3.frame = CGRectMake(110, 60, self.frame.size.width, 30)
        imgView.frame = CGRectMake(10, 10, 90, 90)
        textView.frame = CGRectMake(10, 110, self.frame.size.width, 100)
        view.frame = CGRectMake(10, 110, self.frame.size.width, 100)
        UIView.commitAnimations()
    }
    override func setSelected(selected: Bool, animated: Bool) {
        
        super.setSelected(selected, animated: animated)
        
    }
    

}
