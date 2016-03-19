//
//  BrowseMessageLocal.swift
//  indoorBnW
//
//  Created by LEO on 2016/3/18.
//  Copyright © 2016年 LEO. All rights reserved.
//

import UIKit

class BrowseMessageLocal: UIViewController, UIScrollViewDelegate {
//, UITableViewDelegate, UITableViewDataSource {
    let db = SQLiteDB.sharedInstance()
    var data:AnyObject?
//    var m_tableView:UITableView!
    var m_scrollerView:UIScrollView!
    var m_pageControl:UIPageControl!
    var m_messageIndex:Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor(red: 209/255.0, green: 235/255.0, blue: 254/255.0, alpha: 1)
        self.automaticallyAdjustsScrollViewInsets = false
        
//        m_tableView = UITableView(frame: CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height))
//        m_tableView.backgroundColor = UIColor.clearColor()
//        m_tableView.autoresizingMask = [UIViewAutoresizing.FlexibleHeight, UIViewAutoresizing.FlexibleWidth]
//        m_tableView.delegate = self
//        m_tableView.dataSource = self
//        self.view.addSubview(m_tableView)
        
        loadMessageLocalData()
        refreshWithFrame(self.view.frame)
        
        if data?.count > 0 {m_messageIndex = 1}
        self.navigationItem.title = "\(m_messageIndex)/\(String((data?.count)!))"
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
        let db = SQLiteDB.sharedInstance()
        data = db.query("select * from messagelocal where 1=1")
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
    }

//    //MARK: - TableView
//    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return data!.count
//    }
//    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
//        return 1
//    }
//    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
//    {
//        //詢問是否有可以覆用的cell   問有沒有kDisplayCell_ID這個標籤的cell可以用
//        var cell:UITableViewCell? = tableView.dequeueReusableCellWithIdentifier("Cell") as UITableViewCell!
//        if cell == nil { //剛生成畫面的第一次都是nil  reuseIdentifier重複使用標籤
//            cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "Cell")
//            cell!.selectionStyle = UITableViewCellSelectionStyle.Blue //點選後改變的顏色
//            //cell!.showsReorderControl = true  //是否可以排序
//        }
////        cell?.textLabel?.text = data![indexPath.row].objectForKey("messageTitle") as? String //主標題
////        cell?.detailTextLabel?.text = data![indexPath.row].objectForKey("messageSubtitle") as? String //副標題
////        cell?.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator//右邊的
//        
//        let viewW = (cell?.frame.width)!
//        let viewH = (cell?.frame.height)!
//        
////        let viewStartY:CGFloat = 0
//        var usedY:CGFloat = 10
////
////        let scrollView = UIView(frame: CGRectMake(
////            ((cell?.frame.width)! - (cell?.frame.width)!*0.9)/2, //x
////            5, //(( viewH-viewStartY ) - ( viewH-viewStartY )*0.85)/2 + viewStartY, //y
////            (cell?.frame.width)!*0.9, //w
////            ( (cell?.frame.height)!-viewStartY )*0.85)) //h
////        scrollView.backgroundColor = UIColor(red: 0.85, green: 0.85, blue: 0.58, alpha: 1)
////        scrollView.layer.cornerRadius = 10
////        scrollView.layer.masksToBounds = true
////        cell?.addSubview(scrollView)
//        usedY = 20 //scrollView.frame.origin.y + 20
//        
////        let viewW = scrollView.frame.width
////        let viewH = scrollView.frame.height
//        
//        //標題
//        let titleLabel = UILabel(frame: CGRectMake(
//            (viewW - (viewW)*0.9)/2, //x
//            usedY, //y
//            (viewW)*0.9, 35)) //w, h
//        titleLabel.backgroundColor = UIColor.lightGrayColor()
//        titleLabel.text = data![0].objectForKey("messageTitle") as? String
//print("標題: \(data![0].objectForKey("messageTitle") as? String)")
//        cell?.addSubview(titleLabel)
//        usedY += titleLabel.frame.height + 20
//        
//        //副標題
//        let subtitleLabel = UILabel(frame: CGRectMake(
//            titleLabel.frame.origin.x, //x
//            usedY, //y
//            (viewW)*0.9, 35)) //w, h
//        subtitleLabel.backgroundColor = UIColor.lightGrayColor()
//        subtitleLabel.text = data![0].objectForKey("messageSubtitle") as? String
//        cell?.addSubview(subtitleLabel)
//        usedY += subtitleLabel.frame.height + 20
//        
//        //內容
//        let contentTextView = UITextView(frame: CGRectMake(
//            titleLabel.frame.origin.x, //x
//            usedY, //y
//            (viewW)*0.9, 70)) //w, h
//        contentTextView.backgroundColor = UIColor.lightGrayColor()
//        contentTextView.font = UIFont(name: ".SFUIText-Regular", size: 17) //改變textview字型大小
//        contentTextView.text = data![0].objectForKey("messageContent") as? String
//        contentTextView.selectable = false
//        cell?.addSubview(contentTextView)
//        usedY += contentTextView.frame.height + 20
//        
//        //圖片
//        let imageImageView = UIImageView(frame: CGRectMake(
//            ((viewW) - (viewW)*0.9)/2, //x
//            usedY, //y
//            (viewW)*0.9, 200)) //w, h
//        imageImageView.backgroundColor = UIColor.lightGrayColor()
//        imageImageView.userInteractionEnabled = false
//        
////        let imageName = data![0].objectForKey("messageImage") as? String
////        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {() -> Void in
////            let tempData = NSData(contentsOfURL: NSURL(string: "http://bing0112.100hub.net/bing/MessageImage/Sample.jpg")!)
////            
////            dispatch_async(dispatch_get_main_queue(),{
////                if tempData != nil {
////                    imageImageView.image = UIImage(data: tempData!)
////                } else {
////                    imageImageView.backgroundColor = UIColor.redColor()
////                }
////            })
////        })
////        scrollView.addSubview(imageImageView)
//        
////        let imageName = data![0].objectForKey("messageImage") as? String
////        let tempData = NSData(contentsOfURL: NSURL(string: "http://bing0112.100hub.net/bing/MessageImage/\(imageName!)")!)
////        if tempData != nil {
////            imageImageView.image = UIImage(data: tempData!)
////        } else {
////            imageImageView.backgroundColor = UIColor.redColor()
////        }
////        cell?.addSubview(imageImageView)
//        usedY += imageImageView.frame.height + 20
//        
//        //ScrollView ContentSize
////        scrollView.contentSize = CGSizeMake(scrollView.frame.width, usedY)
//        
//        cell?.selectionStyle = .None
//        
//        return cell!
//    }
//    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
//        return (self.view.frame.height - 64)
//    }

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
        
        //商店
        let storeLabel = UILabel(frame: CGRectMake(
            (pView.frame.width - pView.frame.width*0.9)/2, //x
            interval, //y
            pView.frame.width*0.9, 35)) //w, h
        storeLabel.backgroundColor = UIColor.lightGrayColor()
        storeLabel.layer.cornerRadius = corRadius
        storeLabel.layer.masksToBounds = true
        if data?.count > 0 {storeLabel.text = data![index].objectForKey("messageStore") as? String}
        pView.addSubview(storeLabel)
        usedHeight += storeLabel.frame.origin.y + storeLabel.frame.height + interval
        
        let alignX = (pView.frame.width - pView.frame.width*0.9)/2
        
        //標題
        let titleLabel = UILabel(frame: CGRectMake(
            alignX, //x
            usedHeight, //y
            pView.frame.width*0.9, 35)) //w, h
        titleLabel.backgroundColor = UIColor.lightGrayColor()
        titleLabel.layer.cornerRadius = corRadius
        titleLabel.layer.masksToBounds = true
        if data?.count > 0 {titleLabel.text = data![index].objectForKey("messageTitle") as? String}
        pView.addSubview(titleLabel)
        usedHeight += titleLabel.frame.height + interval
//        print("2 \(usedHeight)")
        
        //副標題
        let subtitleLabel = UILabel(frame: CGRectMake(
            alignX, //x
            usedHeight, //y
            pView.frame.width*0.9, 35)) //w, h
        subtitleLabel.backgroundColor = UIColor.lightGrayColor()
        if data?.count > 0 {subtitleLabel.text = data![index].objectForKey("messageSubtitle") as? String}
        subtitleLabel.layer.cornerRadius = corRadius
        subtitleLabel.layer.masksToBounds = true
        pView.addSubview(subtitleLabel)
        usedHeight += subtitleLabel.frame.height + interval
//        print("3 \(usedHeight)")
        
        //內容
        let contentTextView = UITextView(frame: CGRectMake(
            alignX, //x
            usedHeight, //y
            pView.frame.width*0.9, 70)) //w, h
        contentTextView.backgroundColor = UIColor.lightGrayColor()
        contentTextView.font = UIFont(name: ".SFUIText-Regular", size: 17) //改變textview字型大小
        if data?.count > 0 {contentTextView.text = data![index].objectForKey("messageContent") as? String}
        contentTextView.selectable = false
        contentTextView.layer.cornerRadius = corRadius
        contentTextView.layer.masksToBounds = true
        pView.addSubview(contentTextView)
        usedHeight += contentTextView.frame.height + interval
//        print("4 \(usedHeight)")
        
        //圖片 ImageView
        let imageImageView = UIImageView(frame: CGRectMake(
            alignX, //x
            usedHeight, //y
            pView.frame.width*0.9, 200)) //w, h
        imageImageView.userInteractionEnabled = false
        let imageName = NSHomeDirectory() + "/Documents/images/" + (data![index].objectForKey("messageImage") as? String)!
//        print("\(imageName) ========================...")
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
        pView.addSubview(imageImageView)
        usedHeight += imageImageView.frame.height + interval
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        let currentPage = scrollView.contentOffset.y / m_scrollerView.frame.size.height
//        print("\(scrollView.contentOffset.y) _ \(m_scrollerView.frame.size.height)")
//        print("\(currentPage) _ \(m_pageControl.currentPage)")
        if Int(currentPage)+1 == m_messageIndex {
            return
        }
        m_messageIndex = Int(currentPage)+1
//        print(Int(currentPage))
//        print(m_pageControl.currentPage)
        
        self.navigationItem.title = "\(m_messageIndex)/\((data?.count)!)"
//        print("\((data?.count)!)則通知, 第\(m_pageControl.currentPage + 1)則")
//        print("\(self.navigationItem.title) ==========================")
    }
}
