//
//  ProductMessage.swift
//  indoorB&W2
//
//  Created by Bing on 2016/3/7.
//  Copyright © 2016年 Bing. All rights reserved.
//

import UIKit

class ProductDetail: UIViewController,UIScrollViewDelegate {
    var imageView:UIImageView = UIImageView()
    var scroll:UIScrollView!
    var labAry:[UILabel] = [UILabel]()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.orangeColor()
        
        let imageviewW:CGFloat = 250
        scroll = Sup.addScrollerView(self, frame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) , contentSize:CGSizeMake(self.view.frame.size.width, self.view.frame.size.height) )
        self.view.addSubview(scroll)
        let img:UIImage = UIImage()
        imageView = Sup.addImageView(CGRectMake(self.view.frame.size.width/2-imageviewW/2, 0, imageviewW, imageviewW), img: img)
        imageView.backgroundColor =  UIColor.redColor()
        scroll.addSubview(imageView)
        
        for var i = 0 ; i < 8 ; i++ {
            labAry.append(Sup.addLabel(CGRectMake(0, imageView.frame.origin.y + imageviewW + CGFloat(i) * 50, self.view.frame.size.width, 50), str: ""))
            scroll.addSubview(labAry[i])
        }
        
        scroll.contentSize = CGSizeMake(self.view.frame.size.width,imageView.frame.origin.y + imageviewW + CGFloat(8) * 50 )
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    override func viewDidAppear(animated: Bool) {
        var Str:[String] = [String]()
        Str.append("商店名稱:\(Sup.Supervisor.storeDic["storeName"]!)")
        Str.append("商店Slogan:\(Sup.Supervisor.storeDic["storeSlogan"]!)")
        Str.append("商店Logo:\(Sup.Supervisor.storeDic["storeLogo"]!)")
        Str.append("商店分類:\(Sup.Supervisor.storeDic["storeCategory"]!)")
        
        
        Str.append("商品名稱:\(Sup.Supervisor.productDic["productName"]!)")
        Str.append("商品Type:\(Sup.Supervisor.productDic["productType"]!)")
        Str.append("商品簡介:\(Sup.Supervisor.productDic["productInfo"]!)")
        Str.append("商品價格:\(Sup.Supervisor.productDic["productPrice"]!)")
        
        for var i = 0; i < Str.count;i++ {
            labAry[i].text = Str[i]
        }
        
        //下載頭像
        imageView.image = Sup.downloadimage("http://bing0112.100hub.net/bing/ProductImage/\(Sup.Supervisor.productDic["productID"]!).jpg")

    }
    override func viewDidDisappear(animated: Bool) {
        let labTextAry:[String] = ["商店名稱:","商店Slogan:","商店Logo:","商店分類:","商品名稱:","商品Type:","商品簡介:","商品價格:"]
        for var i  = 0 ; i < labAry.count ; i++ {
            labAry[i].text = labTextAry[i]
        }
        imageView.image = nil
    }
}
