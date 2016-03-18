//
//  ViewController.swift
//  indoorB&W2
//
//  Created by Bing on 2016/2/25.
//  Copyright © 2016年 Bing. All rights reserved.
//

import UIKit

class Login: UIViewController,UITextFieldDelegate,NSURLSessionDownloadDelegate,BingDelegate {
    var passer:Passer?
    var registeredUser:RegisteredUser?
    var registeredSupervisor:RegisteredSupervisor?
    var btnAry:[UIButton] = [UIButton]()
    var textFieldAry:[UITextField] = [UITextField]()
    
    var bing:Bing!
    var VC:UIViewController?
    
    let segm:UISegmentedControl = UISegmentedControl(items: ["會員","商家"])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bing = Bing(del: self)
        Sup.login = self
        
        self.navigationItem.hidesBackButton = true //隱藏返回鍵
    }
    func gotowhere() -> UIViewController {
        return VC!
    }
    
    func refreshWithFrame(frame:CGRect){
        self.view.frame = frame
        self.view.backgroundColor = UIColor.lightGrayColor()
        self.navigationItem.title = "indoor B&W"
//        print(NSHomeDirectory())
        
        let btnW:CGFloat = 300;
        let btnH:CGFloat = 40;
    
        btnAry.append(Sup.addBtn(self, frame: CGRectMake(-300, self.view.frame.size.height, 10, 10), str: "登入", tag: 0))
        btnAry.append(Sup.addBtn(self, frame: CGRectMake(self.view.frame.size.width, self.view.frame.size.height, 10, 10), str: "註冊會員", tag: 1))
        btnAry.append(Sup.addBtn(self, frame: CGRectMake(self.view.frame.size.width, -60, 10, 10), str: "註冊商家", tag: 2))
        btnAry.append(Sup.addBtn(self, frame: CGRectMake(-300, -60, 10, 10), str: "訪客", tag: 3))
        for var i = 0 ; i < btnAry.count ; i++ {
            self.view.addSubview(btnAry[i])
        }
        
        textFieldAry.append(Sup.addTextField(self, frame: CGRectMake(self.view.frame.size.width/2, self.view.frame.size.height, btnW, btnH), placeholdString: "帳號"))
        textFieldAry.append(Sup.addTextField(self, frame: CGRectMake(self.view.frame.size.width/2,-60, btnW, btnH), placeholdString: "密碼"))
        
        self.view.addSubview(textFieldAry[0])
        self.view.addSubview(textFieldAry[1])
        
        textFieldAry[1].secureTextEntry = true
        textFieldAry[0].text = "Bing"
        textFieldAry[1].text = "Bing"
        
        
        
        segm.frame = CGRectMake(self.view.frame.size.width , 200, btnW,btnH)
        segm.selectedSegmentIndex = 0
        segm.addTarget(self, action: "onSegmAction:", forControlEvents: .ValueChanged)
        segm.tintColor = UIColor.blackColor()
        self.view.addSubview(segm)
    }
    
    func onBtnAction(sender:UIButton){
        switch sender.tag {
        case 0:
            if textFieldAry[1].text == "" || textFieldAry[0].text == "" {
                Sup.showAlert(self, str: "資料請填寫完成")
                return
            }
            Sup.mySQL(self, url: "http://bing0112.100hub.net/bing/login.php", submitBody: "where=\(Sup.userOrSupervisor)&Acc=\(textFieldAry[0].text!)&Pwd=\(textFieldAry[1].text!)")
        case 1:
            if registeredUser == nil{
                registeredUser = RegisteredUser()
            }
            self.navigationController?.pushViewController(registeredUser!, animated: true)
        case 2:
            if registeredSupervisor == nil{
                registeredSupervisor = RegisteredSupervisor()
            }
            self.navigationController?.pushViewController(registeredSupervisor!, animated: true)
        case 3:
            if passer == nil{
                passer = Passer()
            }
            self.navigationController?.pushViewController(passer!, animated: true)
            
        default:
            break
        }
    }
    func onSegmAction(sender:UISegmentedControl){
        switch sender.selectedSegmentIndex {
        case 0:
            Sup.userOrSupervisor = "user"
        case 1:
            Sup.userOrSupervisor = "supervisor"
        default :
            break
        }
    }
    //取得echo回來的值
    func URLSession(session: NSURLSession, downloadTask: NSURLSessionDownloadTask, didFinishDownloadingToURL location: NSURL) {
        let resp = String(data: NSData(contentsOfURL: location)!, encoding: NSUTF8StringEncoding)
        print("resp: \(resp!)")
        if resp! == "帳號錯誤"{
            Sup.showAlert(self, str: "帳號錯誤")
        }else if resp! == "密碼錯誤" {
            Sup.showAlert(self, str: "密碼錯誤")
        }else if resp! == "帳號密碼正確"{
            //再判斷要去管理者或使用者
            if Sup.userOrSupervisor == "user"{
                VC = User()
                Sup.User.user = textFieldAry[0].text!
            }else if Sup.userOrSupervisor == "supervisor"{
                VC = Supervisor()
                Sup.Supervisor.supervisor = textFieldAry[0].text!//設定是哪個suprevisor
            }
            textFieldAry[0].text = ""
            textFieldAry[1].text = ""
            bing.go()
        }else if resp! == ""{
            Sup.showAlert(self, str: "請區分大小寫")
        }else{
            Sup.showAlert(self, str: "網路不穩")
        }
    }
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        textFieldAry[0].resignFirstResponder()
        textFieldAry[1].resignFirstResponder()
    }
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        print("\(string)")
        if textField == textFieldAry[0] || textField == textFieldAry[1]{
            if (string.characters.count + textField.text!.characters.count) > 8 && string.characters.count > 0 {
                Sup.showAlert(self, str: "最多輸入8個字")
                return false
            }
        }
        return true
    }
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField == textFieldAry[0]{
            textFieldAry[1].becomeFirstResponder()
        }
        return true
    }
    override func viewDidAppear(animated: Bool) {
        
        UIView.beginAnimations("MOveobjmati", context: nil)
        UIView.setAnimationDuration(1)
        for var i = 0 ; i < btnAry.count ; i++ {
            btnAry[i].frame = CGRectMake(self.view.frame.size.width/2-300/2, 70.0 * CGFloat(i) + 250.0, 300, 60)
        }
        for var i = 0 ; i < textFieldAry.count ; i++ {
            textFieldAry[i].frame = CGRectMake(self.view.frame.size.width/2-300 / 2, 55.0 * CGFloat(i) + 85.0, 300, 40)
        }
        segm.frame = CGRectMake(self.view.frame.size.width/2-300 / 2, 200, 300,40)
        UIView.commitAnimations()
        
        
        
//        for var i:CGFloat = 0;i < 4;i++ {
//            btnAry.append(Sup.addBtn(self, frame: CGRectMake(self.view.frame.size.width/2-btnW/2, 70.0 * i + 250.0, btnW, 60), str: btnStr[Int(i)], tag: Int(i)))
//            self.view.addSubview(btnAry[Int(i)])
//        }
//        
//        let textFieldStr = ["帳號","密碼"]
//        for var i:CGFloat = 0;i < 2;i++ {
//            textFieldAry.append(Sup.addTextField(self, frame: CGRectMake(self.view.frame.size.width/2-btnW / 2, 55.0 * i + 85.0, btnW, btnH), placeholdString: textFieldStr[Int(i)]))
//            self.view.addSubview(textFieldAry[Int(i)])
//        }
    }
    // 判斷有無登入與會員或商家
    //    func check(){
    //        let defaults=NSUserDefaults.standardUserDefaults()
    //        if defaults.objectForKey("loginUser") != nil{
    //            m_checkStr = (defaults.objectForKey("who")) as! String
    //
    //        }else{
    //            print("尚未登入")
    //        }
    //    }
    
    
}

