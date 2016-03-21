//
//  EditStore.swift
//  indoorB&W2
//
//  Created by Bing on 2016/3/9.
//  Copyright © 2016年 Bing. All rights reserved.
//

import UIKit

class EditStore: UIViewController,UITextFieldDelegate,NSURLSessionDownloadDelegate {
    var storeDic:Dictionary<String,String>!
    var textFieldAry:[UITextField] = [UITextField]()
    var store:Store?
    var acti:UIActivityIndicatorView = UIActivityIndicatorView()
    var actiView:UIView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
        
        let textFieldW:CGFloat = 250
        let textFieldH:CGFloat = 30
        let Fieltext:[String] = [storeDic["storeName"]!,storeDic["storeCategory"]!,storeDic["storeSlogan"]!,storeDic["storeLogo"]!]
        let textFieldtext:[String] = ["商店名稱","分類","Slogan","簡介"]
        for var i:CGFloat = 0;i < 4 ; i++ {
            textFieldAry.append(Sup.addTextField(self, frame: CGRectMake(self.view.frame.size.width/2-textFieldW/2, 40.0 * i + 110.0, textFieldW, textFieldH), placeholdString: textFieldtext[Int(i)]))
            self.view.addSubview(textFieldAry[Int(i)])
            textFieldAry[Int(i)].text = Fieltext[Int(i)]
        }
        
        //確認
        self.view.addSubview(Sup.addBtn(self, frame: CGRectMake(self.view.frame.size.width/2-textFieldW/2, 300, textFieldW, textFieldH), str: "確認", tag: 1))
        
        //刪除
        self.view.addSubview(Sup.addBtn(self, frame: CGRectMake(self.view.frame.size.width/2-textFieldW/2, 350, textFieldW, textFieldH), str: "刪除商店", tag: 2))
    }
    func onBtnAction(sender:UIButton){
        actiView = Sup.addView(self.view.frame)
        self.view.addSubview(actiView)
        acti = Sup.addActivityIndicatorView(self.view.frame)
        acti.startAnimating()
        self.view.addSubview(acti)
        switch sender.tag{
        case 1://修改
            Sup.mySQL(self, url: "http://bing0112.100hub.net/bing/EditStore.php", submitBody: "storeID=\(storeDic["storeID"]!)&storeName=\(textFieldAry[0].text!)&storeByMarket=\(storeDic["storeByMarket"]!)&storeCategory=\(textFieldAry[1].text!)&storeSlogan=\(textFieldAry[2].text!)&storeLogo=\(textFieldAry[3].text!)&storeSupervisor=\(storeDic["storeSupervisor"]!)")
        case 2://刪除
            let alertController = UIAlertController(title: "確定刪除？", message: nil, preferredStyle: UIAlertControllerStyle.Alert)
            let agreeAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) { (UIAlertAction) -> Void in
                //self.navigationController?.pushViewController(self.store!, animated: true)
                //alertController.presentViewController(self.store!, animated: true, completion: nil)
                //self.performSelector(Selector("goBack"), withObject: nil, afterDelay: 1)
                
                Sup.mySQL(self, url: "http://bing0112.100hub.net/bing/deleteStore.php", submitBody: "storeID=\(self.storeDic["storeID"]!)")
                
                //self.mySQL("http://bing0112.100hub.net/bing/deleteStore.php", subBody: "storeName=\(self.storeDic["storeName"]!)&storeSupervisor=\(self.storeDic["storeSupervisor"]!)")
            }
            let calAction = UIAlertAction(title: "NO", style: UIAlertActionStyle.Cancel, handler: nil)
            alertController.addAction(agreeAction)
            alertController.addAction(calAction)
            self.presentViewController(alertController, animated: true, completion: nil)
        default:
            break
        }
    }
    func setStoreDictionary(dic:Dictionary<String,String>){
        storeDic = dic
        print(dic)
        self.navigationItem.title = "編輯商店：\(storeDic["storeName"]!)"
        let Fieltext:[String] = [storeDic["storeName"]!,storeDic["storeCategory"]!,storeDic["storeSlogan"]!,storeDic["storeLogo"]!]
        for var i = 0;i<textFieldAry.count;i++ {
            textFieldAry[i].text = Fieltext[i]
        }
    }
    
    //取得echo回來的值
    func URLSession(session: NSURLSession, downloadTask: NSURLSessionDownloadTask, didFinishDownloadingToURL location: NSURL) {
        let resp = String(data: NSData(contentsOfURL: location)!, encoding: NSUTF8StringEncoding)
        print("resp: \(resp!)")
        if resp! == "修改成功"{
            Sup.showAlert(self, str: "修改成功")
            Sup.mySQL(store!, url: "http://bing0112.100hub.net/bing/storeJson.php", submitBody: "supervisor=\(Sup.Supervisor.supervisor)")
            Sup.Supervisor.clickMode = 0
        }else if resp! == "刪除成功"{
            let alertController = UIAlertController(title: "刪除成功", message: nil, preferredStyle: UIAlertControllerStyle.Alert)
            let agreeAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: { (UIAlertAction) -> Void in
                self.navigationController?.popToViewController(self.store!, animated: true)
            })
            Sup.mySQL(store!, url: "http://bing0112.100hub.net/bing/storeJson.php", submitBody: "supervisor=\(Sup.Supervisor.supervisor)")
            alertController.addAction(agreeAction)
            self.presentViewController(alertController, animated: true, completion: nil)
        }else {
            Sup.showAlert(self, str: "網路不穩")
        }
        actiView.hidden = true
        acti.stopAnimating()
    }
    //鍵盤中return那個案件
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        //收回鍵盤
        textField.resignFirstResponder()
        return true
    }
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for var i = 0 ; i < textFieldAry.count ;i++ {
            textFieldAry[i].resignFirstResponder()
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
}
