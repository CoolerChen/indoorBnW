//
//  BrowseStore.swift
//  indoorBnW
//
//  Created by Bing on 2016/3/17.
//  Copyright © 2016年 LEO. All rights reserved.
//

import UIKit

class BrowseStore: UIViewController,UIScrollViewDelegate,NSURLSessionDownloadDelegate {
    var scroller:UIScrollView = UIScrollView()
    var browseProduct:BrowseProduct?
    var json = []
    var btnAry:[UIButton] = [UIButton]()
    var acti:UIActivityIndicatorView = UIActivityIndicatorView()
    var actiView:UIView = UIView()
    var browseProductAry:[AnyObject] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.blueColor()
        self.navigationItem.title = "瀏覽商店"
        
        scroller = Sup.addScrollerView(self, frame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) , contentSize: CGSizeMake(self.view.frame.width, 1000))
        scroller.backgroundColor = UIColor.whiteColor()
        self.view.addSubview(scroller)
        downloadStore()
    }
    func URLSession(session: NSURLSession, downloadTask: NSURLSessionDownloadTask, didFinishDownloadingToURL location: NSURL) {
//        let resp = String(data: NSData(contentsOfURL: location)!, encoding: NSUTF8StringEncoding)
//        print("resp: \(resp!)")//解拉回來的字串json格式
        do{
            json = try NSJSONSerialization.JSONObjectWithData(NSData(contentsOfURL: location)!, options: NSJSONReadingOptions.MutableContainers) as! NSArray
            
//            print(json)
        }catch{
            print("解json失敗")
        }
        
        for var i = 0  ; i < json.count ; i++ {//json[i]["storeName"] as! String
            btnAry.append(Sup.addBtn(self, frame: CGRectMake(10, 20 + 140 * CGFloat(i), self.view.frame.size.width - 20, 130), str: "", tag: i))
            btnAry[i].backgroundColor = UIColor(red: 0.14, green: 0.51, blue: 0.9, alpha: 0.7)
            scroller.addSubview(btnAry[i])
            
            let lab1:UILabel = Sup.addLabel(CGRectMake(15, 10 + 140 * CGFloat(i), self.view.frame.size.width - 20, 50), str:"商店名稱: \(json[i]["storeName"] as! String)" )
            lab1.textColor = UIColor.blackColor()
            scroller.addSubview(lab1)
            let lab2:UILabel = Sup.addLabel(CGRectMake(15, 40 + 140 * CGFloat(i), self.view.frame.size.width - 20, 50), str:"商店分類: \(json[i]["storeCategory"] as! String)")
            lab2.textColor = UIColor.whiteColor()
            scroller.addSubview(lab2)
            let lab3:UILabel = Sup.addLabel(CGRectMake(15, 70 + 140 * CGFloat(i), self.view.frame.size.width - 20, 50), str:"商店slogan: \(json[i]["storeSlogan"] as! String)")
            lab3.textColor = UIColor.whiteColor()
            scroller.addSubview(lab3)
            let lab4:UILabel = Sup.addLabel(CGRectMake(15, 100 + 140 * CGFloat(i), self.view.frame.size.width - 20, 50), str: "商店簡介: \(json[i]["storeLogo"] as! String)")
            lab4.textColor = UIColor.whiteColor()
            scroller.addSubview(lab4)
            browseProductAry.append(NSNull)
            
        }
        scroller.contentSize = CGSizeMake(self.view.frame.size.width, (btnAry.last?.frame.origin.y)! + 170)
        actiView.hidden = true
        acti.stopAnimating()
    }
    func onBtnAction(sender:UIButton){
        print(json[sender.tag])
        //把資料丟給Sup裡面 然後跳去product那一頁並且把該store的資料撈下來呈現
        Sup.User.storeDic = json[sender.tag] as! Dictionary<String, String>
        Sup.User.storeID = json[sender.tag]["storeID"] as! String
        Sup.User.storeName = json[sender.tag]["storeName"] as! String
        Sup.Supervisor.storeDic = json[sender.tag] as! Dictionary<String, String>
        
        
        if browseProductAry[sender.tag].isEqual(NSNull) {
            browseProductAry[sender.tag] = BrowseProduct()
            (browseProductAry[sender.tag] as! BrowseProduct).downloadProduct()
            print("yo")
        }
        (browseProductAry[sender.tag] as! BrowseProduct).loading = false
        self.navigationController?.pushViewController(browseProductAry[sender.tag] as! UIViewController, animated: true)
        
        
//        if browseProduct == nil{
//            browseProduct = BrowseProduct()
//        }
//        self.navigationController?.pushViewController(browseProduct!, animated: true)
        
        
    }

    func downloadStore(){
        actiView = Sup.addView(self.view.frame)
        self.view.addSubview(actiView)
        acti = Sup.addActivityIndicatorView(self.view.frame)
        acti.startAnimating()
        self.view.addSubview(acti)
        Sup.mySQL(self, url: "http://bing0112.100hub.net/bing/allStoreJSON.php", submitBody: "")
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    

}
