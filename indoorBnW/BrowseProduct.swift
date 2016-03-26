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
    var imageAry:[UIImageView] = [UIImageView]()
    var productDetail:ProductDetail?
    var acti:UIActivityIndicatorView = UIActivityIndicatorView()
    var actiView:UIView = UIView()
    var loading:Bool = true
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
        self.navigationItem.title = "瀏覽商品"
        
        scroller = Sup.addScrollerView(self, frame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) , contentSize: CGSizeMake(self.view.frame.width, 1000))
        scroller.backgroundColor = UIColor.whiteColor()
        self.view.addSubview(scroller)
        loading = true
    }
    func URLSession(session: NSURLSession, downloadTask: NSURLSessionDownloadTask, didFinishDownloadingToURL location: NSURL) {
        do{
            json = try NSJSONSerialization.JSONObjectWithData(NSData(contentsOfURL: location)!, options: NSJSONReadingOptions.MutableContainers) as! NSArray
            
            print(json)
        }catch{
            print("解json失敗")
        }
        
        for var i = 0  ; i < json.count ; i++ {//json[i]["storeName"] as! String
            btnAry.append(Sup.addBtn(self, frame: CGRectMake(10, 20 + 120 * CGFloat(i), self.view.frame.size.width - 20, 100), str: "", tag: i))
            btnAry[i].backgroundColor = UIColor(red: 0.14, green: 0.51, blue: 0.9, alpha: 0.7)
            scroller.addSubview(btnAry[i])
            let lab1:UILabel = Sup.addLabel(CGRectMake(90, 10 + 120 * CGFloat(i), self.view.frame.size.width - 20, 50), str:"商品名稱: \(json[i]["productName"] as! String)" )
            lab1.textColor = UIColor.blackColor()
            scroller.addSubview(lab1)
            
            scroller.addSubview(Sup.addLabel(CGRectMake(90, 40 + 120 * CGFloat(i), self.view.frame.size.width - 20, 50), str:"商品價格: \(Sup.getSeparatedString(json[i]["productPrice"] as! String))元"))
            
            imageAry.append(Sup.addImageView(CGRectMake(20, 40 + 120 * CGFloat(i), 60, 60)))
            
            imageAry[i].image = Sup.downloadimage("http://bing0112.100hub.net/bing/ProductImage/\(self.json[i]["productID"] as! String).jpg")
            scroller.addSubview(imageAry[i])
            
            
        }
        if json.count != 0 {
            scroller.contentSize = CGSizeMake(self.view.frame.size.width, (btnAry.last?.frame.origin.y)! + 170)
        }
        actiView.hidden = true
        acti.stopAnimating()
        
    
    
    }
    override func viewDidAppear(animated: Bool) {
        //從明細回來不用重新下載
        if loading {
            downloadProduct()
        }
        loading = true
        
    }
    func downloadProduct(){
        actiView = Sup.addView(self.view.frame)
        self.view.addSubview(actiView)
        acti = Sup.addActivityIndicatorView(self.view.frame)
        acti.startAnimating()
        self.view.addSubview(acti)
        Sup.mySQL(self, url: "http://bing0112.100hub.net/bing/product.php", submitBody: "productByStore=\(Sup.User.storeID)")
    }
    
    func onBtnAction(sender:UIButton){
        Sup.Supervisor.productID = json[sender.tag].objectForKey("productID") as! String
        if productDetail == nil{
            productDetail = ProductDetail()
        }
        Sup.Supervisor.productDic = json[sender.tag] as! Dictionary<String, String>
        Sup.Supervisor.product = json[sender.tag].objectForKey("productName") as! String
        self.navigationController?.pushViewController(productDetail!, animated: true)
        loading = false
    }
    override func viewDidDisappear(animated: Bool) {
        //離開畫面就要清掉
//        if loading {
//            for var i = 0;i < btnAry.count;i++ {
//                btnAry[i].removeFromSuperview()
//            }
//            btnAry = []
//            for var i = 0 ; i < imageAry.count;i++ {
//                imageAry[i].removeFromSuperview()
//            }
//            imageAry = []
//        }
//        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
