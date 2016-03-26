//
//  ProductMessage.swift
//  indoorB&W2
//
//  Created by Bing on 2016/3/7.
//  Copyright © 2016年 Bing. All rights reserved.
//

import UIKit

class ProductDetail: UIViewController,UIScrollViewDelegate ,UITextViewDelegate{
    var imageView:UIImageView = UIImageView()
    var scroll:UIScrollView!
    var labAry:[UILabel] = [UILabel]()
    var textView:UITextView = UITextView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
        
        let imageviewW:CGFloat = 250
        scroll = Sup.addScrollerView(self, frame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) , contentSize:CGSizeMake(self.view.frame.size.width, self.view.frame.size.height) )
        self.view.addSubview(scroll)
        
        imageView = Sup.addImageView(CGRectMake(self.view.frame.size.width/2-imageviewW/2, 10, imageviewW, imageviewW))
        //imageView.backgroundColor =  UIColor.clearColor()
        scroll.addSubview(imageView)
        let labtext = ["商店名稱:","商店Slogan:","商店簡介:","商店分類:","商品名稱:","商品價格:"]
        for var i = 0 ; i < 6 ; i++ {
            labAry.append(Sup.addLabel(CGRectMake(5, imageView.frame.origin.y + imageviewW + CGFloat(i) * 50, self.view.frame.size.width-5, 50), str: ""))
            scroll.addSubview(labAry[i])
            labAry[i].textColor = UIColor.blueColor()
            labAry[i].textAlignment = .Right
            let lab:UILabel = Sup.addLabel(CGRectMake(5, imageView.frame.origin.y + imageviewW + CGFloat(i) * 50, self.view.frame.size.width, 50), str: labtext[i])
            lab.textColor = UIColor.blackColor()
            scroll.addSubview(lab)
            
        }
        let lab = Sup.addLabel(CGRectMake(5, imageView.frame.origin.y + imageviewW + CGFloat(6) * 50, self.view.frame.size.width, 50), str: "商品簡介:")
        lab.textColor = UIColor.blackColor()
        scroll.addSubview(lab)
        
        textView = Sup.addTextView(self, frame: CGRectMake(5, imageView.frame.origin.y + imageviewW + CGFloat(7) * 50, self.view.frame.size.width, imageviewW))
        scroll.addSubview(textView)
        textView.userInteractionEnabled = false
        textView.textColor = UIColor.blueColor()

        
        scroll.contentSize = CGSizeMake(self.view.frame.size.width,textView.frame.origin.y + imageviewW + 100 )
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    override func viewDidAppear(animated: Bool) {
        var Str:[String] = [String]()
        Str.append("\(Sup.Supervisor.storeDic["storeName"]!)")
        Str.append("\(Sup.Supervisor.storeDic["storeSlogan"]!)")
        Str.append("\(Sup.Supervisor.storeDic["storeLogo"]!)")
        Str.append("\(Sup.Supervisor.storeDic["storeCategory"]!)")
        
        
        Str.append("\(Sup.Supervisor.productDic["productName"]!)")
        //Str.append("商品Type:\(Sup.Supervisor.productDic["productType"]!)")
        //Str.append("商品簡介:\(Sup.Supervisor.productDic["productInfo"]!)")
        Str.append("\(Sup.getSeparatedString(Sup.Supervisor.productDic["productPrice"]!))元")
        textView.text = "\(Sup.Supervisor.productDic["productInfo"]!)"
        for var i = 0; i < Str.count;i++ {
            labAry[i].text = Str[i]
        }
        //下載頭像
        imageView.image = Sup.downloadimage("http://bing0112.100hub.net/bing/ProductImage/\(Sup.Supervisor.productDic["productID"]!).jpg")

    }
    override func viewDidDisappear(animated: Bool) {
        //let labTextAry:[String] = ["商店名稱:","商店Slogan:","商店簡介:","商店分類:","商品名稱:","商品價格:"]
        for var i  = 0 ; i < labAry.count ; i++ {
            labAry[i].text = ""
        }
        textView.text = ""
        imageView.image = nil
    }
}
