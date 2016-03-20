//
//  User.swift
//  indoorB&W2
//
//  Created by Bing on 2016/2/25.
//  Copyright © 2016年 Bing. All rights reserved.
//

//import UIKit
//
//class User: UIViewController {
//    var btnAry:[UIButton] = [UIButton]()
//    var btnW:CGFloat = 0.0
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        self.view.backgroundColor = UIColor.whiteColor()
//        self.navigationItem.title = "\(Sup.User.user)"
//        
//        let btnStr = ["開放資訊","會員專區","搜尋商家","Email","登出"]
//        btnW = self.view.frame.size.width/2 - 15
//        
//        for var i = 0; i < btnStr.count;i++ {
//            btnAry.append(Sup.addBtn(self, frame: CGRectMake(self.view.frame.size.width/2-btnW/2, self.view.frame.size.height/2-btnW/2 , btnW, btnW), str:btnStr[i] , tag: i))
//            self.view.addSubview(btnAry[i])
//        }
//        
//        
//    }
//    func onBtnAction(sender:UIButton){
//        switch sender.tag {
//        case 0:
//            print("開放資訊")
//        case 1:
//            print("會員專區")
//        case 2:
//            print("搜尋商家")
//        case 3:
//            print("Email")
//        case 4:
//            print("登出")
//        default:
//            break
//        }
//    }
//    override func viewDidAppear(animated: Bool) {
//        let space:CGFloat = 10.0
//        UIView.beginAnimations("MOveobjmati", context: nil)
//        UIView.setAnimationDuration(0.6)
//        
//        
//        
//        for var i:CGFloat = 0;i<5;i++ {
//            btnAry[Int(i)].frame = CGRectMake(space * (i%2 + 1) + i%2 * btnW, CGFloat(70+Int(i/2) * Int(btnW+10)) , btnW, btnW)
//        }
//        
//        
//        
//        
//        
//        UIView.commitAnimations()
//    }
//    
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//    }
//    
//    
//    
//    
//}

//
//  User.swift
//  indoorB&W2
//
//  Created by Bing on 2016/2/25.
//  Copyright © 2016年 Bing. All rights reserved.
//

import UIKit

class User: UIViewController {
    var browseStore:BrowseStore?
    var browseMessageLocal:BrowseMessageLocal?
    var userQRCode:UserQRCode?
    
    var btnAry:[UIButton] = [UIButton]()
    var btnW:CGFloat = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.whiteColor()
        self.navigationItem.title = "首頁"
        
        let btnStr = ["瀏覽訊息","收藏訊息","QRCode","瀏覽商品","Email","登出"]
        btnW = self.view.frame.size.width/2 - 15
        
        for var i = 0; i < btnStr.count;i++ {
            btnAry.append(Sup.addBtn(self, frame: CGRectMake(self.view.frame.size.width/2-btnW/2, self.view.frame.size.height/2-btnW/2 , btnW, btnW), str:btnStr[i] , tag: i))
            self.view.addSubview(btnAry[i])
        }
        self.navigationItem.hidesBackButton = true
    }
    func onBtnAction(sender:UIButton){
        switch sender.tag {
        case 0:
            print("瀏覽訊息")
            print("\(Sup.User.user)")
            if browseMessageLocal == nil {
                browseMessageLocal = BrowseMessageLocal()
                browseMessageLocal?.setPageSring("browse")
            } else {
                browseMessageLocal?.setPageSring("browse")
                browseMessageLocal?.viewDidLoad()
            }
            self.navigationController?.pushViewController(browseMessageLocal!, animated: true)
            
        case 1:
            print("收藏訊息")
            if browseMessageLocal == nil {
                browseMessageLocal = BrowseMessageLocal()
                browseMessageLocal?.setPageSring("favorite")
            } else {
                browseMessageLocal?.setPageSring("favorite")
                browseMessageLocal?.viewDidLoad()
            }
            self.navigationController?.pushViewController(browseMessageLocal!, animated: true)
        case 2:
            //userQRCode
            if userQRCode == nil {
                userQRCode = UserQRCode()
            }
            self.navigationController?.pushViewController(userQRCode!, animated: true)
        case 3:
            print("瀏覽商品")
            if browseStore == nil{
                browseStore = BrowseStore()
            }
            
            self.navigationController?.pushViewController(browseStore!, animated: true)
        case 4://Email
            let mailURL = NSURL(string: "message://")!
            if UIApplication.sharedApplication().canOpenURL(mailURL) {
                UIApplication.sharedApplication().openURL(mailURL)
            }
        case 5:
            self.navigationController?.popToViewController(Sup.login!, animated: true)
        default:
            break
        }
    }
    override func viewDidAppear(animated: Bool) {
        let space:CGFloat = 10.0
        UIView.beginAnimations("MOveobjmati", context: nil)
        UIView.setAnimationDuration(0.6)
        for var i:CGFloat = 0 ; i < 6 ; i++ {
            btnAry[Int(i)].frame = CGRectMake(space * (i%2 + 1) + i%2 * btnW, CGFloat(70+Int(i/2) * Int(btnW+10)) , btnW, btnW)
        }
        UIView.commitAnimations()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    
    
}
