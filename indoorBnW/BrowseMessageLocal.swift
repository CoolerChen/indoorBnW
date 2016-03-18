//
//  BrowseMessageLocal.swift
//  indoorBnW
//
//  Created by LEO on 2016/3/18.
//  Copyright © 2016年 LEO. All rights reserved.
//

import UIKit

class BrowseMessageLocal: UIViewController, UITableViewDelegate, UITableViewDataSource {
    let db = SQLiteDB.sharedInstance()
    var data:AnyObject?
    var m_tableView:UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.lightGrayColor()
        
        m_tableView = UITableView(frame: CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height))
        m_tableView.backgroundColor = UIColor.clearColor()
        m_tableView.autoresizingMask = [UIViewAutoresizing.FlexibleHeight, UIViewAutoresizing.FlexibleWidth]
        m_tableView.delegate = self
        m_tableView.dataSource = self
        self.view.addSubview(m_tableView)
        
    }

    override func viewWillAppear(animated: Bool) {
        loadMessageLocalData()
        m_tableView.reloadData()
    }
    
    func loadMessageLocalData() {
        let db = SQLiteDB.sharedInstance()
        data = db.query("select * from messagelocal where 1=1")
        print("BrowseMessageLocal: data count \(data!.count)")
    }

    //MARK: - TableView
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data!.count
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        //詢問是否有可以覆用的cell   問有沒有kDisplayCell_ID這個標籤的cell可以用
        var cell:UITableViewCell? = tableView.dequeueReusableCellWithIdentifier("Cell") as UITableViewCell!
        if cell == nil { //剛生成畫面的第一次都是nil  reuseIdentifier重複使用標籤
            cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "Cell")
            cell!.selectionStyle = UITableViewCellSelectionStyle.Blue //點選後改變的顏色
            //cell!.showsReorderControl = true  //是否可以排序
        }
        cell?.textLabel?.text = data![indexPath.row].objectForKey("messageTitle") as? String //主標題
//        cell?.detailTextLabel?.text = json[indexPath.row].objectForKey("storeSlogan") as? String //副標題
//        cell?.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator//右邊的 >
        
        return cell!
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return (self.view.frame.height - 64)
    }

}
