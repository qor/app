//
//  SectionsTableViewController.swift
//  QorDemo
//
//  Created by Neo Chow on 21/3/2016.
//  Copyright © 2016 NeoChow. All rights reserved.
//

import UIKit
import Kingfisher

class ListTableViewController: UITableViewController {

    var items :[Phone] = []
    let cellReuseStr = "ReuseStr"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "商品列表"
        
        tableView.registerClass(ListCell.self, forCellReuseIdentifier: cellReuseStr)
        
        if readData() {
            tableView.reloadData()
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
                
        tableView.scrollToRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0) , atScrollPosition: .Top, animated: false)
    }
    
    func readData() -> Bool {
        if let path = NSBundle.mainBundle().pathForResource("list", ofType: "json") {
            do {
                let jsonData = try NSData(contentsOfFile: path, options: NSDataReadingOptions.DataReadingMappedIfSafe)
                do {
                    let jsonResult = try NSJSONSerialization.JSONObjectWithData(jsonData, options: NSJSONReadingOptions.MutableContainers) as! NSArray
                    for itemObj in jsonResult {
                        let itemDict = itemObj as! NSDictionary
                        let item = Phone(title: itemDict["itemTitle"] as! String,
                                        amount: itemDict["itemMonthSoldCount"] as! String,
                                         price: itemDict["itemActPrice"] as! String,
                                     imgUrlStr: itemDict["itemImg"] as! String)
                        items.append(item)
                    }
                } catch {
                    return false
                }
            } catch {
                return false
            }
            return true
        }
        return false
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 120
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellReuseStr, forIndexPath: indexPath) as! ListCell

        let model = items[indexPath.row]
        cell.refreshCellWithModel(model)
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let model = items[indexPath.row]
        let detailVC = DetailViewController()
        detailVC.item = model
        
        navigationController!.pushViewController(detailVC, animated: true)
    }
    
    
}
