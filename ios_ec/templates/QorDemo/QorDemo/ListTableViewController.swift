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
    var currentRow = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "商品列表"
        
        if readData() {
            tableView.reloadData()
        }
        print("items: \(items)")
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
        let cell = tableView.dequeueReusableCellWithIdentifier("listCellReuseStr", forIndexPath: indexPath) as! ListCell
        
        // Configure the cell...
        cell.titleLbl.text = items[indexPath.row].title
        cell.amoutLbl.text = items[indexPath.row].amount
        cell.priceLbl.text = items[indexPath.row].price
        

        cell.logoImgV.kf_setImageWithURL(NSURL(string: items[indexPath.row].imageUrlStr)!)
        
        
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetail" {
            let destController = segue.destinationViewController as! DetailViewController
            
            destController.imgUrlStr = items[currentRow].imageUrlStr
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        currentRow = indexPath.row
        self.performSegueWithIdentifier("showDetail", sender: self)
    }
    
    
}
