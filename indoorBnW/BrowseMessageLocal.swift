//
//  BrowseMessageLocal.swift
//  indoorBnW
//
//  Created by LEO on 2016/3/18.
//  Copyright © 2016年 LEO. All rights reserved.
//

import UIKit

class BrowseMessageLocal: UIViewController, UIScrollViewDelegate {
    var whichPage:String = ""
    let db = SQLiteDB.sharedInstance()
    var data:AnyObject?
//    var m_tableView:UITableView!
    var m_scrollerView:UIScrollView!
    var m_pageControl:UIPageControl!
    var m_messageIndex:Int = 0 //第幾項，從1開始
    
    func setPageSring(page:String) {
        whichPage = page
//        print("setPageSring \(page)")
    }

    override func viewDidLoad() {
//        print("viewDidLoad page=\(whichPage)")
//        print("viewDidLoad s")
        super.viewDidLoad()

        self.view.backgroundColor = UIColor(red: 209/255.0, green: 235/255.0, blue: 254/255.0, alpha: 1)
        self.automaticallyAdjustsScrollViewInsets = false
        
        loadMessageLocalData()
        refreshWithFrame(self.view.frame)
        
        if data?.count > 0 {
            m_messageIndex = 1
        } else {
            m_messageIndex = 0
        }
        self.navigationItem.title = "\(m_messageIndex)/\(String((data?.count)!))"
//        print("viewDidLoad e")
    }

    override func viewWillAppear(animated: Bool) {
//        loadMessageLocalData()
    }
    override func viewDidAppear(animated: Bool) {
//        m_tableView.reloadData()
//        refreshWithFrame(self.view.frame)
    }
    override func viewWillDisappear(animated: Bool) {
        for vc:UIView in self.view.subviews {
            vc.removeFromSuperview()
        }
    }
    
    func loadMessageLocalData() {
        /*
            id             : 1
            messageTime    :2016-03-18_14-11-09
            messageStore   :商店名稱
            messageTitle   :標題
            messageSubtitle:副標題
            messageContent :內容
            messageImage   :圖片檔名.副檔名
            addFavorite    :加入收藏
        */
        switch whichPage {
            case "browse":
                data = db.query("select * from messagelocal where 1=1")
            case "favorite":
                data = db.query("select * from messagelocal where addFavorite='yes'")
            default:
                data = db.query("select * from messagelocal where 1=1")
        }
        print(data!.count)
    }

    func refreshWithFrame(frame:CGRect) {
        m_scrollerView = UIScrollView() //宣告空的ScrollView
        //建議x,y還是要設因為self不一定跟window一樣
        m_scrollerView?.frame = CGRectMake(0, 64, frame.size.width, frame.size.height-64)
        //可視範圍 或容量 contentSize內容大小
        //m_scrollerView?.contentSize = CGSizeMake(frame.size.width, 10000)
        //m_scrollerView.contentOffset//容器的座標  往上拖10個單位 他就會往上10加10  如容量的對應位置
//        m_scrollerView.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        m_scrollerView.showsHorizontalScrollIndicator = true //水平的滾動指示
        m_scrollerView.showsVerticalScrollIndicator = false //垂直的滾動指示
        m_scrollerView.delegate = self
        m_scrollerView.pagingEnabled = true  //可以以本身容器的寬度做切頁分頁
        self.view.addSubview(m_scrollerView)
        
        var pageView:UIView!
        let w:CGFloat = frame.size.width
        let h:CGFloat = frame.size.height - 64
//        var usedHeight:CGFloat = 0
        
        var aryColor:[UIColor] = [UIColor.redColor(),UIColor.orangeColor(),UIColor.greenColor(),UIColor.blackColor(),UIColor.blueColor()]
        
        if data?.count > 0 {
//            print("大於零")
            for var i = 0 ; i < data?.count ; i++ {
                pageView = UIView(frame: CGRectMake(0, h*CGFloat(i), w, h))
    //            print("pageView ori y= \(pageView.frame.origin.y)")
                pageView.backgroundColor = aryColor[i%5]
                
                //載入資料
                addObject(pageView, index: i)
                
                m_scrollerView.addSubview(pageView)//在scrollerView 上面掛載不同顏色的UIView
            }
            //重新刷新寬高
            m_scrollerView.contentSize = CGSizeMake(w, pageView.frame.origin.y + pageView.frame.size.height)
        } else {
//            print("小於等於零")
        }
    }

    func addObject(pView:UIView, index:Int) {
        var usedHeight:CGFloat = 0
        let corRadius:CGFloat = 5
        let interval:CGFloat = 10
        
        let scrollView = UIScrollView(frame: CGRectMake(
            (pView.frame.width - pView.frame.width*0.9)/2, //x
            (pView.frame.height - pView.frame.height*0.9)/2 + 10, //y
            pView.frame.width*0.9, //w
            pView.frame.height*0.9)) //h
        scrollView.backgroundColor = UIColor(red: 209/255.0, green: 235/255.0, blue: 254/255.0, alpha: 1)
        scrollView.layer.cornerRadius = corRadius*2
        scrollView.layer.masksToBounds = true
        pView.addSubview(scrollView)
        
        //商店
        let storeLabel = UILabel(frame: CGRectMake(
            (scrollView.frame.width - scrollView.frame.width*0.9)/2, //x
            20, //y
            scrollView.frame.width*0.9, 35)) //w, h
        storeLabel.backgroundColor = UIColor.lightGrayColor()
        storeLabel.layer.cornerRadius = corRadius
        storeLabel.layer.masksToBounds = true
        if data?.count > 0 {storeLabel.text = data![index]["messageStore"] as? String}
        scrollView.addSubview(storeLabel)
        usedHeight += storeLabel.frame.origin.y + storeLabel.frame.height + interval
        
        let alignX = (pView.frame.width - pView.frame.width*0.9)/2
        
        //標題
        let titleLabel = UILabel(frame: CGRectMake(
            alignX, //x
            usedHeight, //y
            scrollView.frame.width*0.9, 35)) //w, h
        titleLabel.backgroundColor = UIColor.lightGrayColor()
        titleLabel.layer.cornerRadius = corRadius
        titleLabel.layer.masksToBounds = true
        if data?.count > 0 {titleLabel.text = data![index].objectForKey("messageTitle") as? String}
        scrollView.addSubview(titleLabel)
        usedHeight += titleLabel.frame.height + interval
        
        //副標題
        let subtitleLabel = UILabel(frame: CGRectMake(
            alignX, //x
            usedHeight, //y
            scrollView.frame.width*0.9, 35)) //w, h
        subtitleLabel.backgroundColor = UIColor.lightGrayColor()
        if data?.count > 0 {subtitleLabel.text = data![index].objectForKey("messageSubtitle") as? String}
        subtitleLabel.layer.cornerRadius = corRadius
        subtitleLabel.layer.masksToBounds = true
        scrollView.addSubview(subtitleLabel)
        usedHeight += subtitleLabel.frame.height + interval
        
        //內容
        let contentTextView = UITextView(frame: CGRectMake(
            alignX, //x
            usedHeight, //y
            scrollView.frame.width*0.9, 70)) //w, h
        contentTextView.backgroundColor = UIColor.lightGrayColor()
        contentTextView.font = UIFont(name: ".SFUIText-Regular", size: 17) //改變textview字型大小
        if data?.count > 0 {contentTextView.text = data![index].objectForKey("messageContent") as? String}
        contentTextView.selectable = false
        contentTextView.layer.cornerRadius = corRadius
        contentTextView.layer.masksToBounds = true
        scrollView.addSubview(contentTextView)
        usedHeight += contentTextView.frame.height + interval
        
        //圖片 ImageView
        let imageImageView = UIImageView(frame: CGRectMake(
            alignX, //x
            usedHeight, //y
            scrollView.frame.width*0.9, 200)) //w, h
        imageImageView.userInteractionEnabled = false
        let imageName = NSHomeDirectory() + "/Documents/images/msg/" + (data![index].objectForKey("messageImage") as? String)!
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {() -> Void in
            let tempData = NSData(contentsOfFile: imageName)

            dispatch_async(dispatch_get_main_queue(),{
                if tempData != nil {
                    imageImageView.image = UIImage(data: tempData!)
                } else {
                    imageImageView.backgroundColor = UIColor.whiteColor()
                }
            })
        })
        scrollView.addSubview(imageImageView)
        usedHeight += imageImageView.frame.height + interval
        
        //瀏覽訊息頁才有收藏按鈕
        if whichPage == "browse" {
            //加入收藏按鈕
            let buttonH = pView.frame.height*0.08
            let buttonW = CGFloat(60)
            let favImage = UIImageView(frame: CGRectMake(
                pView.frame.width - pView.frame.width*0.05 - buttonW , //x
                pView.frame.height*0.06 - buttonH/2, //y
                buttonW, //w
                buttonH)) //h
            favImage.backgroundColor = UIColor(red: 209/255.0, green: 235/255.0, blue: 254/255.0, alpha: 1)
            favImage.layer.cornerRadius = 10
            favImage.layer.masksToBounds = true
            if data?.count > 0 {
                if (data![index]["addFavorite"] as? String) == "yes" {
                    favImage.image = UIImage(named: "FavoriteStarO") //橘色
                } else {
                    favImage.image = UIImage(named: "FavoriteStarG") //灰色
                }
            }
            favImage.contentMode = UIViewContentMode.ScaleAspectFit
            favImage.userInteractionEnabled = true
            let tapGesture = UITapGestureRecognizer(target: self, action: "imageTapped")
            favImage.addGestureRecognizer(tapGesture)
            favImage.tag = index + 1
            pView.addSubview(favImage)
        }
    }
    
    func imageTapped() {
        //改變sqlite addFavorite欄位的值
        let messageTime = data![m_messageIndex - 1].objectForKey("messageTime") as? String
        let favValue = db.query("select addFavorite from messagelocal where messageTime='\(messageTime!)'")
        
        if favValue.count > 0 {
            let willChangeImage = self.view.viewWithTag(m_messageIndex) as! UIImageView
            
            if (favValue[0]["addFavorite"] as? String) == "yes" {
                let reV = db.query("update messagelocal set addFavorite='no' where messageTime='\(messageTime!)'")
                willChangeImage.image = UIImage(named: "FavoriteStarG") //灰色
//                print("index:\(m_messageIndex - 1) set no: \(reV)")
            } else {
                let reV = db.query("update messagelocal set addFavorite='yes' where messageTime='\(messageTime!)'")
                
                willChangeImage.image = UIImage(named: "FavoriteStarO") //橘色
//                print("index:\(m_messageIndex - 1) set yes: \(reV)")
            }
        } else {
            print("count 0")
        }
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        let currentPage = scrollView.contentOffset.y / m_scrollerView.frame.size.height

        if Int(currentPage)+1 == m_messageIndex {
            return
        }
        m_messageIndex = Int(currentPage)+1

        self.navigationItem.title = "\(m_messageIndex)/\((data?.count)!)"
    }
}
