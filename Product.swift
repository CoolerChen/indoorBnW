//
//  Product.swift
//  indoorB&W2
//
//  Created by Bing on 2016/3/5.
//  Copyright © 2016年 Bing. All rights reserved.
//

import UIKit

class Product: UIViewController,UITableViewDelegate,UITableViewDataSource ,NSURLSessionDownloadDelegate {
    var json = []
    var productName:String!
    var createProduct:CreateProduct?
    var m_tableView:UITableView!
    var productDetail:ProductDetail?
    var editProduct:EditProduct?
    var Btn:UIButton = UIButton()
    var status = Sup.Status.Done //判斷是編輯還是瀏覽
    //var goto:Int!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
        
        let rightBtnItem:UIBarButtonItem = UIBarButtonItem(title: "Edit", style: UIBarButtonItemStyle.Done, target: self, action: Selector("OnSelectRightAction:"))
        self.navigationItem.rightBarButtonItem = rightBtnItem
        
        m_tableView = UITableView(frame: CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height))
        m_tableView.backgroundColor = UIColor.clearColor()
        m_tableView.autoresizingMask = [UIViewAutoresizing.FlexibleHeight, UIViewAutoresizing.FlexibleWidth]
        m_tableView.delegate = self
        m_tableView.dataSource = self
        //self.navigationController?.view.addSubview(m_tableView)
        self.view.addSubview(m_tableView)
        
        
        
        
        Btn=Sup.addBtn(self, frame: CGRectMake(self.view.frame.size.width-100, self.view.frame.size.height-100, 100, 100), str: "新增", tag: 0)
        self.view.addSubview(Btn)
        Btn.hidden = true
    }
    override func viewDidAppear(animated: Bool) {
        print("\(Sup.Supervisor.supervisor) 的 \(Sup.Supervisor.store) 商店" )
        Sup.mySQL(self, url: "http://bing0112.100hub.net/bing/product.php", submitBody: "productByStore=\(Sup.Supervisor.storeID)")
        self.navigationItem.title = "\(Sup.Supervisor.store)的商品"
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return json.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let kDisplayCell_ID:String = "Cell"// 實作看得到幾項的次數 用來分類標籤 只有一個標籤就沒差
        //設置cell為可選型態 因為該ID可用元件未必存在
        //詢問是否有可以覆用的cell   問有沒有kDisplayCell_ID這個標籤的cell可以用
        var cell = tableView.dequeueReusableCellWithIdentifier(kDisplayCell_ID) as! MyCell2!
        if cell == nil { //剛生成畫面的第一次都是nil  reuseIdentifier重複使用標籤
            cell = MyCell2(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "Cell")
            cell!.selectionStyle = UITableViewCellSelectionStyle.Blue //點選後改變的顏色
            //cell!.showsReorderControl = true  //是否可以排序
        }
        cell!.lab1.text =  "商品名:\(json[indexPath.row].objectForKey("productName") as! String)"//主標題
        cell!.lab2.text = "價格: \(json[indexPath.row].objectForKey("productPrice") as! String) 元"
        //cell!.lab3.text = "我是史丹利"
        cell!.textView.text = "介紹: \(json[indexPath.row].objectForKey("productInfo") as! String)"
        
        
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {() -> Void in
            let Img:UIImage = Sup.downloadimage("http://bing0112.100hub.net/bing/ProductImage/\(self.json[indexPath.row].objectForKey("productID") as! String).jpg")
            
            dispatch_async(dispatch_get_main_queue(), {() -> Void in
                cell.imgView.image = Img
            
            })
            
        })
//
        
        
        
        
        
        cell?.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator//右邊的 >
        
        
        return cell!
    }
    func OnSelectRightAction(sender:UIBarButtonItem){
        if status == Sup.Status.Done{
            sender.title = "Done"
            Btn.hidden = false
            status = Sup.Status.Edit
            
        }else if status == .Edit{
            sender.title = "Edit"
            Btn.hidden = true
            status = Sup.Status.Done
        }
    }
    func onBtnAction(sender:UIButton){
        if createProduct == nil{
            createProduct = CreateProduct()
            createProduct?.product = self
        }
        self.navigationController?.pushViewController(createProduct!, animated: true)
    }
    //取得echo回來的值
    func URLSession(session: NSURLSession, downloadTask: NSURLSessionDownloadTask, didFinishDownloadingToURL location: NSURL) {
        //let resp = String(data: NSData(contentsOfURL: location)!, encoding: NSUTF8StringEncoding)
        //print("resp: \(resp!)")//解拉回來的字串json格式
        do{
            json = try NSJSONSerialization.JSONObjectWithData(NSData(contentsOfURL: location)!, options: NSJSONReadingOptions.MutableContainers) as! NSArray
            //print(json)
        }catch{
            print("解json失敗")
        }
        m_tableView.reloadData()
        
    }
    //點選了哪一個
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch (status){
        case .Done://瀏覽
            productName = json[indexPath.row].objectForKey("productName") as? String
            Sup.Supervisor.productID = json[indexPath.row].objectForKey("productID") as! String
            if productDetail == nil{
                productDetail = ProductDetail()
            }
            Sup.Supervisor.productDic = json[indexPath.row] as! Dictionary<String, String>
            Sup.Supervisor.product = json[indexPath.row].objectForKey("productName") as! String
            self.navigationController?.pushViewController(productDetail!, animated: true)
        case .Edit://編輯
            print("編輯")
            if editProduct == nil{
                editProduct = EditProduct()
            }
            editProduct?.productGoEdit = true
            Sup.Supervisor.productDic = json[indexPath.row] as! Dictionary<String, String>
            editProduct?.product = self
            self.navigationController?.pushViewController(editProduct!, animated: true)
        case .QRCode:
            print("QRCode")
        }
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 220.0
    }
    
    override func viewDidDisappear(animated: Bool) {
        //畫面離開先把該畫面清乾淨  避免另一個商店近來會看到
        json = []
        m_tableView.reloadData()
        
        self.navigationItem.rightBarButtonItem!.title = "Edit"
        Btn.hidden = true
        status = .Done
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
