//
//  BrowseProduct.swift
//  indoorBnW
//
//  Created by Bing on 2016/3/17.
//  Copyright © 2016年 LEO. All rights reserved.
//

import UIKit

class BrowseProduct: UIViewController,UIScrollViewDelegate,NSURLSessionDownloadDelegate {
    var scroller:UIScrollView = UIScrollView()
    var json = []
    var btnAry:[UIButton] = [UIButton]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.brownColor()
        self.navigationItem.title = "瀏覽商品"
        
        scroller = Sup.addScrollerView(self, frame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) , contentSize: CGSizeMake(self.view.frame.width, 1000))
        scroller.backgroundColor = UIColor.blackColor()
        self.view.addSubview(scroller)
        
        downloadProduct()
//        print(Sup.User.storeDic)
//        print(Sup.User.storeID)
//        print(Sup.User.storeName)
        

    }
    func URLSession(session: NSURLSession, downloadTask: NSURLSessionDownloadTask, didFinishDownloadingToURL location: NSURL) {
        do{
            json = try NSJSONSerialization.JSONObjectWithData(NSData(contentsOfURL: location)!, options: NSJSONReadingOptions.MutableContainers) as! NSArray
            
            print(json)
        }catch{
            print("解json失敗")
        }
        
        for var i = 0  ; i < json.count ; i++ {//json[i]["storeName"] as! String
            btnAry.append(Sup.addBtn(self, frame: CGRectMake(10, 20 + 140 * CGFloat(i), self.view.frame.size.width - 20, 130), str: "", tag: i))
            btnAry[i].backgroundColor = UIColor.yellowColor()
            scroller.addSubview(btnAry[i])
            scroller.addSubview(Sup.addLabel(CGRectMake(15, 10 + 140 * CGFloat(i), self.view.frame.size.width - 20, 50), str:"商店名稱: \(json[i]["productName"] as! String)" ))
            scroller.addSubview(Sup.addLabel(CGRectMake(15, 40 + 140 * CGFloat(i), self.view.frame.size.width - 20, 50), str:"商店分類: \(json[i]["productType"] as! String)"))
            scroller.addSubview(Sup.addLabel(CGRectMake(15, 70 + 140 * CGFloat(i), self.view.frame.size.width - 20, 50), str:"商店slogan: \(json[i]["productInfo"] as! String)"))
            scroller.addSubview(Sup.addLabel(CGRectMake(15, 100 + 140 * CGFloat(i), self.view.frame.size.width - 20, 50), str: "商店logo: \(json[i]["productPrice"] as! String)"))
            
        }
        scroller.contentSize = CGSizeMake(self.view.frame.size.width, (btnAry.last?.frame.origin.y)! + 170)
    
    
    }
    func downloadProduct(){
        Sup.mySQL(self, url: "http://bing0112.100hub.net/bing/product.php", submitBody: "productByStore=\(Sup.User.storeID)")
    }
    func onBtnAction(sender:UIButton){
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
