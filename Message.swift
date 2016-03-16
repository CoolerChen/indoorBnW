//
//  Message.swift
//  indoorB&W2
//
//  Created by LEO on 2016/3/12.
//  Copyright © 2016年 Bing. All rights reserved.
//

import UIKit

class Message: UIViewController, UITableViewDelegate, UITableViewDataSource, NSURLSessionDownloadDelegate {
    var json = []
    
    var m_tableView:UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("storeName:\(Sup.Supervisor.store) supervisorName:\(Sup.Supervisor.supervisor)")
        self.view.backgroundColor = UIColor.lightGrayColor()
        
        m_tableView = UITableView(frame: CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height))
        m_tableView.backgroundColor = UIColor.clearColor()
        m_tableView.autoresizingMask = [UIViewAutoresizing.FlexibleHeight, UIViewAutoresizing.FlexibleWidth]
        m_tableView.delegate = self
        m_tableView.dataSource = self
        self.view.addSubview(m_tableView)
    }
    
    override func viewDidAppear(animated: Bool) {
        print("message viewDidAppear")
        self.navigationItem.title = "訊息清單"
        mySQL()
    }
    
    func mySQL(){
        Sup.mySQL(self, url: "http://bing0112.100hub.net/bing/MessageLoad.php", submitBody: "bySupervisor=\(Sup.Supervisor.supervisor)&byStore=\(Sup.Supervisor.store)")
    }
    
    func URLSession(session: NSURLSession, downloadTask: NSURLSessionDownloadTask, didFinishDownloadingToURL location: NSURL)
    {
        //        let resp = String(data: NSData(contentsOfURL: location)!, encoding: NSUTF8StringEncoding)
        //        print("resp: \(resp!)")//解拉回來的字串json格式
        do{
            json = try NSJSONSerialization.JSONObjectWithData(NSData(contentsOfURL: location)!, options: NSJSONReadingOptions.MutableContainers) as! NSArray
            print("json \(json)")
        }catch{
            print("解json失敗")
        }
        m_tableView.reloadData()
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return json.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell:UITableViewCell? = tableView.dequeueReusableCellWithIdentifier("Cell") as UITableViewCell!
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "Cell")
            cell!.selectionStyle = UITableViewCellSelectionStyle.Blue
        }
        cell?.textLabel?.text = json[indexPath.row].objectForKey("messageTitle") as? String
        cell?.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator//右邊的 >
        
        return cell!
    }
    
    
    
    
}
