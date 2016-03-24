//
//  Supervisor.swift
//  indoorB&W2
//
//  Created by Bing on 2016/2/25.
//  Copyright © 2016年 Bing. All rights reserved.
//

import UIKit

class Supervisor: UIViewController {
    var store:Store?
    var email:Email?
    var btnAry:[UIButton] = [UIButton]()
    var btnW:CGFloat = 0.0
    var myView:UIView = UIView()
    var ibeacon:UIImageView = UIImageView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
        self.navigationItem.title = "首頁"
        
        let btnStr = ["瀏覽商店","訊息","Email","QRCode","登出"]
        //btnW = self.view.frame.size.width * 2 / 7
        btnW = self.view.frame.size.width/2 - 15
        let space:CGFloat = 10.0
        
        for var i:CGFloat = 0;i < 5;i++ {
            btnAry.append(Sup.addBtn(self, frame: CGRectMake(space * (i%2 + 1) + i%2 * btnW, self.view.frame.size.height , btnW, btnW), str:btnStr[Int(i)] , tag: Int(i)))
            self.view.addSubview(btnAry[Int(i)])
        }
        
        //btnAry.append(Sup.addBtn(self, frame: CGRectMake(space * (i%2 + 1) + i%2 * btnW, CGFloat(70+Int(i/2) * Int(btnW+10)) , btnW, btnW), str:btnStr[Int(i)] , tag: Int(i)))
        
        self.navigationItem.hidesBackButton = true //隱藏返回鍵
        
        myView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)
        myView.backgroundColor = UIColor.clearColor()
        self.view.addSubview(myView)
        
        ibeacon = Sup.addImageView(CGRectMake(self.view.frame.size.width/2+10, self.view.frame.size.height, btnW, btnW))
        self.view.addSubview(ibeacon)
    }
    func onBtnAction(sender:UIButton){//"瀏覽商店","訊息","Email","QRCode","地圖","設定"]
        switch sender.tag {
        case 0:
            goStore(sender.tag)//瀏覽
        case 1:
            goStore(sender.tag)//訊息
        case 2://Email
            if email == nil{
                email = Email()
            }
            self.navigationController?.pushViewController(email!, animated: true)
        case 3:
            goStore(sender.tag)//QRCode
        case 4:
            print("登出")
            //登出
            self.navigationController?.popToViewController(Sup.login!, animated: true)
        default:
            break
        }
    }
    func goStore(tag:Int){
        if store == nil{
            store = Store()
        }
        store!.downloadStore()
        Sup.Supervisor.clickMode = tag//進入store判斷要走什麼功能  0瀏覽  1訊息  3QRCode
        if tag == 0 || tag == 1 {
            store!.status = Sup.Status.Done
        }else if tag == 3{
            store!.status = Sup.Status.QRCode
        }
        
        self.navigationController?.pushViewController(store!, animated: true)
    }
    override func viewDidAppear(animated: Bool) {
        self.performSelector(Selector("btn1"), withObject: self, afterDelay: 0)
        self.performSelector(Selector("btn2"), withObject: self, afterDelay: 0.5)
        self.performSelector(Selector("btn3"), withObject: self, afterDelay: 1.0)
    }
    func btn1(){
        UIView.beginAnimations("MOveobjmati", context: nil)
        UIView.setAnimationDuration(0.7)
        btnAry[0].frame = CGRectMake(10, 70, btnW, btnW)
        UIView.setAnimationDuration(0.9)
        btnAry[1].frame = CGRectMake(20+btnW, 70, btnW, btnW)
        UIView.commitAnimations()
    }
    func btn2(){
        UIView.beginAnimations("MOveobjmati", context: nil)
        UIView.setAnimationDuration(0.6)
        btnAry[2].frame = CGRectMake(10, btnW+90, btnW, btnW)
        UIView.setAnimationDuration(0.8)
        btnAry[3].frame = CGRectMake(20+btnW, btnW+90, btnW, btnW)
        UIView.commitAnimations()
    }
    func btn3(){
        UIView.beginAnimations("MOveobjmati", context: nil)
        UIView.setAnimationDuration(0.5)
        btnAry[4].frame = CGRectMake(10, btnW*2+110, btnW, btnW)
        UIView.setAnimationDuration(0.7)
//        btnAry[5].frame = CGRectMake(20+btnW, btnW*2+110, btnW, btnW)
        ibeacon.frame = CGRectMake(20+btnW, btnW*2+110, btnW, btnW)
        UIView.commitAnimations()
        myView.frame = CGRectMake(0, 0, 0, 0)
    }
    
    override func viewDidDisappear(animated: Bool) {
        let viewH = self.view.frame.size.height
        let space:CGFloat = 10.0
        for var i:CGFloat = 0;i < 5;i++ {
            btnAry[Int(i)].frame = CGRectMake(space * (i%2 + 1) + i%2 * btnW, viewH , btnW, btnW)
        }
        myView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)
        ibeacon.frame = CGRectMake(self.view.frame.size.width/2+10, viewH, btnW, btnW)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    

    

}
