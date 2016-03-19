//
//  Registered.swift
//  indoorB&W2
//
//  Created by Bing on 2016/2/25.
//  Copyright © 2016年 Bing. All rights reserved.
//

import UIKit

class RegisteredUser: UIViewController,UITextFieldDelegate,NSURLSessionDownloadDelegate{
    var textFieldAry:[UITextField] = [UITextField]()
    var user:User?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.whiteColor()
        self.navigationItem.title = "會員註冊"
        let textFieldW:CGFloat = 250
        let textFieldH:CGFloat = 30
        let textFieldtext:[String] = ["帳號","密碼","會員卡號","信箱","手機","地址"]
        for var i:CGFloat = 0;i < 6 ; i++ {
            textFieldAry.append(Sup.addTextField(self, frame: CGRectMake(self.view.frame.size.width/2-textFieldW/2, 40.0 * i + 110.0, textFieldW, textFieldH), placeholdString: textFieldtext[Int(i)]))
            self.view.addSubview(textFieldAry[Int(i)])
        }
        textFieldAry[1].secureTextEntry = true
        
        //註冊
        self.view.addSubview(Sup.addBtn(self, frame: CGRectMake(self.view.frame.size.width/2-textFieldW/2, 360, textFieldW, textFieldH), str: "會員註冊", tag: 0))
        

    }
    func onBtnAction(sender:UIButton){
        //login()
        //先檢查是否有未填的
        var check = true
        for var i = 0 ; i < textFieldAry.count ;i++ {
            if textFieldAry[i].text == ""{
                Sup.showAlert(self, str: "請輸入完整")
                check = false
                return
            }
        }
        if check{
            Sup.mySQL(self, url: "http://bing0112.100hub.net/bing/user.php", submitBody: "userAcc=\(textFieldAry[0].text!)&userPwd=\(textFieldAry[1].text!)&userCard=\(textFieldAry[2].text!)&userEmail=\(textFieldAry[3].text!)&userPhone=\(textFieldAry[4].text!)&userAddress=\(textFieldAry[5].text!)")
        }
        
    }
    //寫入手機
    func login(){
        let defaults=NSUserDefaults.standardUserDefaults()
        //if defaults.objectForKey("who") as! String == "user"{
            defaults.setObject(textFieldAry[0].text, forKey: "loginUser")
            //defaults.setObject(who, forKey: "who")
        //}
//        print("userDefaults= \(defaults.objectForKey("loginUser")!)")
//        print("who= \(defaults.objectForKey("who")!)")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //取得echo回來的值
    func URLSession(session: NSURLSession, downloadTask: NSURLSessionDownloadTask, didFinishDownloadingToURL location: NSURL) {
        let resp = String(data: NSData(contentsOfURL: location)!, encoding: NSUTF8StringEncoding)
        print("resp: \(resp!)")
        if resp! == "帳號重複"{
            Sup.showAlert(self, str: "帳號重複")
        }else{
            if user == nil{
                user = User()
            }
            for var i = 0 ; i < textFieldAry.count ;i++ {
                textFieldAry[i].text = ""
            }
            self.navigationController?.pushViewController(user!, animated: true)
            
        }

    }
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        print("\(string)")
        if textField == textFieldAry[0]{  //處理帳號
            //判斷長度   即將貼上的字串跟原本的字串長度   count(string) > 0  鍵盤的delete是空字串所以要排除
            if (string.characters.count + textField.text!.characters.count) > 8 && string.characters.count > 0 {
                Sup.showAlert(self, str: "帳號最多輸入8個字")
                return false
            }
        }else if textField == textFieldAry[1]{   //處理密碼
            if(string.characters.count + textField.text!.characters.count) > 8 && string.characters.count > 0 {
                Sup.showAlert(self, str: "帳號最多輸入8個字")
                return false
            }
        }else if textField == textFieldAry[4]{
            if(string.characters.count + textField.text!.characters.count) > 10 && string.characters.count > 0 {
                Sup.showAlert(self, str: "帳號最多輸入10個字")
                return false
            }
        }
        
        return true
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

    
   
    
}
