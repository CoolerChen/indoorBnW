//
//  Store.swift
//  indoorB&W2
//
//  Created by Bing on 2016/3/4.
//  Copyright © 2016年 Bing. All rights reserved.
//

import UIKit

class Store: UIViewController,UITableViewDelegate,UITableViewDataSource ,NSURLSessionDownloadDelegate{
    var createStore:CreateStore?
    var editStore:EditStore?
    var m_tableView:UITableView!
    var json = []
    var product:Product?
    var message:Message?
    var Btn:UIButton = UIButton()
    var status = Sup.Status.Done //判斷是編輯還是瀏覽
    var supervisorStoreQRCode:SupervisorStoreQRCode?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()

        
        m_tableView = UITableView(frame: CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height))
        m_tableView.backgroundColor = UIColor.clearColor()
        m_tableView.autoresizingMask = [UIViewAutoresizing.FlexibleHeight, UIViewAutoresizing.FlexibleWidth]
        m_tableView.delegate = self
        m_tableView.dataSource = self
        self.view.addSubview(m_tableView)
        
//        Sup.mySQL(self, url: "http://bing0112.100hub.net/bing/storeJson.php", submitBody: "supervisor=\(Sup.Supervisor.supervisor)")
        
        
        Btn=Sup.addBtn(self, frame: CGRectMake(self.view.frame.size.width-100, self.view.frame.size.height-100, 100, 100), str: "新增", tag: 0)
        Btn.hidden = true
        self.view.addSubview(Btn)
    }
    func OnSelectRightAction(sender:UIBarButtonItem){
        if status == Sup.Status.Done{
            sender.title = "Done"
            Btn.hidden = false
            status = Sup.Status.Edit
        }else if status == Sup.Status.Edit{
            sender.title = "Edit"
            Btn.hidden = true
            status = Sup.Status.Done
        }
    }
    func onBtnAction(sender:UIButton){
        if createStore == nil{
            createStore = CreateStore()
            createStore?.store = self
        }
        self.navigationController?.pushViewController(createStore!, animated: true)
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return json.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let kDisplayCell_ID:String = "Cell"// 實作看得到幾項的次數 用來分類標籤 只有一個標籤就沒差
        //設置cell為可選型態 因為該ID可用元件未必存在
        //詢問是否有可以覆用的cell   問有沒有kDisplayCell_ID這個標籤的cell可以用
        var cell = tableView.dequeueReusableCellWithIdentifier(kDisplayCell_ID) as! MyCell1!
        if cell == nil { //剛生成畫面的第一次都是nil  reuseIdentifier重複使用標籤
            cell = MyCell1(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "Cell")
            cell!.selectionStyle = UITableViewCellSelectionStyle.Blue //點選後改變的顏色
            //cell!.showsReorderControl = true  //是否可以排序
        }
        cell!.lab1.text = json[indexPath.row].objectForKey("storeName") as? String //主標題
        cell!.lab2.text = json[indexPath.row].objectForKey("storeSlogan") as? String
        cell!.lab3.text = json[indexPath.row].objectForKey("storeLogo") as? String
        
        
        cell?.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator//右邊的 >
        //cell?.imageView?.image = UIImage(named: "123")//左邊圖片
        
        return cell!
    }
    //點選了哪一個
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //判斷要去哪裡
        switch (Sup.Supervisor.clickMode){
        case 0,3://瀏覽 或 QRCode
            
            switch status {
            case .Done:
                if product == nil{
                    product = Product()
                }
                //進瀏覽的話把商店名稱寫進Sup理
                Sup.Supervisor.store = json[indexPath.row].objectForKey("storeName") as! String
                Sup.Supervisor.storeID = json[indexPath.row].objectForKey("storeID") as! String
                Sup.Supervisor.storeDic = json[indexPath.row] as! Dictionary<String, String>
                self.navigationController?.pushViewController(product!, animated: true)
            case .Edit:
                if editStore == nil{
                    editStore = EditStore()
                }
                editStore?.store = self
                Sup.Supervisor.storeDic = json[indexPath.row] as! Dictionary<String, String>
                editStore?.setStoreDictionary(json[indexPath.row] as! Dictionary<String, String>)
                self.navigationController?.pushViewController(editStore!, animated: true)
                
            case .QRCode:
                //supervisorStoreQRCode
                if supervisorStoreQRCode == nil{
                    supervisorStoreQRCode = SupervisorStoreQRCode()
                }
                //supervisorStoreQRCode?.store = self
                Sup.Supervisor.storeDic = json[indexPath.row] as! Dictionary<String, String>
                self.navigationController?.pushViewController(supervisorStoreQRCode!, animated: true)
            }
        case 1://訊息
            print("訊息")
            if message == nil{
                message = Message()
            }
            Sup.Supervisor.store = json[indexPath.row].objectForKey("storeName") as! String
            Sup.Supervisor.storeID = json[indexPath.row].objectForKey("storeID") as! String
            self.navigationController?.pushViewController(message!, animated: true)
        
        default:
            break
        }
    }
    //列表高度   會依據列表數決定觸發次數
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 100
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    override func viewDidAppear(animated: Bool) {
        self.navigationItem.title = "\(Sup.Supervisor.supervisor)的商店"
        if Sup.Supervisor.clickMode == 0{
            let rightBtnItem:UIBarButtonItem = UIBarButtonItem(title: "Edit", style: UIBarButtonItemStyle.Done, target: self, action: Selector("OnSelectRightAction:"))
            self.navigationItem.rightBarButtonItem = rightBtnItem
        }
        //status = Sup.Status.Done
    }
    override func viewDidDisappear(animated: Bool) {
        self.navigationItem.rightBarButtonItem = nil
        Btn.hidden = true
    }
    
    func downloadStore(){
        Sup.mySQL(self, url: "http://bing0112.100hub.net/bing/storeJson.php", submitBody: "supervisor=\(Sup.Supervisor.supervisor)")
    }
}
