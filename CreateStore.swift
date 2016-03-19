//
//  add.swift
//  indoorB&W2
//
//  Created by Bing on 2016/3/2.
//  Copyright © 2016年 Bing. All rights reserved.
//

import UIKit

class CreateStore: UIViewController,UITextFieldDelegate,NSURLSessionDownloadDelegate {
    var textFieldAry:[UITextField] = [UITextField]()
    var store:Store?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
        self.navigationItem.title = "新增商店"
        
        let textFieldW:CGFloat = 250
        let textFieldH:CGFloat = 40
        let textFieldtext:[String] = ["商店名稱","分類","Slogan","Logo"]
        for var i:CGFloat = 0;i < 4 ; i++ {
            textFieldAry.append(Sup.addTextField(self, frame: CGRectMake(self.view.frame.size.width/2-textFieldW/2, 45.0 * i + 110.0, textFieldW, textFieldH), placeholdString: textFieldtext[Int(i)]))
            self.view.addSubview(textFieldAry[Int(i)])
        }
        
        //送出
        self.view.addSubview(Sup.addBtn(self, frame: CGRectMake(self.view.frame.size.width/2-textFieldW/2, 300, textFieldW, textFieldH), str: "送出", tag: 0))
    }
    func onBtnAction(sender:UIButton){
        if textFieldAry[0].text == "" {
            Sup.showAlert(self, str: "請輸入商店名稱")
            return
        }
        Sup.mySQL(self, url: "http://bing0112.100hub.net/bing/CreateStore.php", submitBody: "storeID=ID&storeName=\(textFieldAry[0].text!)&storeByMarket=\(Sup.Supervisor.supervisor)&storeCategory=\(textFieldAry[1].text!)&storeSlogan=\(textFieldAry[2].text!)&storeLogo=\(textFieldAry[3].text!)&storeSupervisor=\(Sup.Supervisor.supervisor)")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //取得echo回來的值
    func URLSession(session: NSURLSession, downloadTask: NSURLSessionDownloadTask, didFinishDownloadingToURL location: NSURL) {
        let resp = String(data: NSData(contentsOfURL: location)!, encoding: NSUTF8StringEncoding)
        print("resp: \(resp!)")
        if resp! == "商店名字重複"{
            Sup.showAlert(self, str: "商店重複")
        }else if resp! == "新增成功"{
            Sup.showAlert(self, str: "新增成功")
            Sup.mySQL(store!, url: "http://bing0112.100hub.net/bing/storeJson.php", submitBody: "supervisor=\(Sup.Supervisor.supervisor)")
            Sup.Supervisor.clickMode = 0
            for var i = 0 ; i < textFieldAry.count ;i++ {
                textFieldAry[i].text = ""
            }
        }
    }
    //鍵盤中return那個案件
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        //收回鍵盤
        textField.resignFirstResponder()
        return true
    }
    override func viewDidDisappear(animated: Bool) {
        for var i = 0 ; i < textFieldAry.count ;i++ {
            textFieldAry[i].text = ""
        }
    }
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for var i = 0 ; i < textFieldAry.count ;i++ {
            textFieldAry[i].resignFirstResponder()
        }
        
    }
}
