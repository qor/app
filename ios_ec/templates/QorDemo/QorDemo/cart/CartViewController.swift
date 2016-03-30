//
//  CartViewController.swift
//  QorDemo
//
//  Created by Neo Chow on 30/3/2016.
//  Copyright © 2016 NeoChow. All rights reserved.
//

import UIKit
import Cartography

class CartViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var tableView: UITableView?
    let bottomHeight:CGFloat = 50
    let cellReuseStr = "CartCell"
    var bottomView = UIView(frame: CGRectZero)
    var items :[Goods] = []
    var totalPriceLbl = UILabel(frame: CGRectZero)
    var buyBtn = UIButton(type: .Custom)
    var currentTotalPrice = 0.00
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "我的购物车"
        view.backgroundColor = UIColor(red: 245/255.0, green: 245/255.0, blue: 245/255.0, alpha: 1)
        edgesForExtendedLayout = .None
        
        // Do any additional setup after loading the view.
        tableView = UITableView(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.size.width, UIScreen.mainScreen().bounds.size.height-64-bottomHeight), style: .Plain)
        view.addSubview(tableView!)
        tableView?.dataSource = self
        tableView?.delegate = self
        tableView?.showsVerticalScrollIndicator = false
        tableView?.separatorStyle = .None
        tableView?.backgroundColor = UIColor.clearColor()
        tableView?.registerClass(CartTableViewCell.self, forCellReuseIdentifier: cellReuseStr)
        
        bottomView.frame = CGRectMake(0, CGRectGetHeight(tableView!.frame), CGRectGetWidth(tableView!.frame), bottomHeight)
        view.addSubview(bottomView)
        setupBottomView()
        
        if readData() {
            tableView!.reloadData()
        }
    }
    
    func setupBottomView() {
        bottomView.backgroundColor = UIColor.whiteColor()
        bottomView.addSubview(buyBtn)
        bottomView.addSubview(totalPriceLbl)
        
        buyBtn.backgroundColor = UIColor.orangeColor()
        buyBtn.setTitle("结算", forState: .Normal)
        buyBtn.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        buyBtn.titleLabel?.font = UIFont.boldSystemFontOfSize(15)
        buyBtn.addTarget(self, action: #selector(calcTotalPrice), forControlEvents: .TouchUpInside)
        
        updatePriceWithStr("0.0")
        
        constrain(buyBtn) { (b) in
            b.height == b.superview!.height
            b.top == b.superview!.top
            b.width == b.superview!.width / 3
            b.trailing == b.superview!.trailing
        }
        
        constrain(totalPriceLbl, buyBtn) { (t, b) in
            t.bottom == b.bottom
            t.leading == t.superview!.leading + 20
            t.top == t.superview!.top
        }
    }
    
    func updatePriceWithStr(priceStr: String) {
        let myAttribute = [ NSFontAttributeName: UIFont.systemFontOfSize(18) ]
        let myString = NSMutableAttributedString(string: "总价: ", attributes: myAttribute )
        
        let attrString = NSAttributedString(string: priceStr)
        myString.appendAttributedString(attrString)
        
        let myRange = NSRange(location: 4, length: attrString.length)
        myString.addAttribute(NSForegroundColorAttributeName, value: UIColor.orangeColor(), range: myRange)
        
        totalPriceLbl.attributedText = myString
    }
    
    func calcTotalPrice() {
        let alertController = UIAlertController(title: "恭喜", message: "购买成功，回到首页", preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(
            UIAlertAction(title: "好的", style: UIAlertActionStyle.Cancel) { (dd) -> Void in
                self.navigationController!.popToRootViewControllerAnimated(true)
            }
        )
        presentViewController(alertController, animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func readData() -> Bool {
        if let path = NSBundle.mainBundle().pathForResource("Cart", ofType: "json") {
            do {
                let jsonData = try NSData(contentsOfFile: path, options: NSDataReadingOptions.DataReadingMappedIfSafe)
                do {
                    let jsonResult = try NSJSONSerialization.JSONObjectWithData(jsonData, options: NSJSONReadingOptions.MutableContainers) as! NSArray
                    for itemObj in jsonResult {
                        let itemDict = itemObj as! NSDictionary
                        let item = Goods(title: itemDict["itemTitle"] as! String,
                                         amount: itemDict["amount"] as! String,
                                         price: itemDict["price"] as! String,
                                         imgUrlStr: itemDict["img"] as! String)
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

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 140
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(cellReuseStr, forIndexPath: indexPath) as! CartTableViewCell
        cell.selectionStyle = .None
        let model = items[indexPath.row]
        cell.refreshCellWithModel(model)
                
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        var model = items[indexPath.row]
       
        model.isChecked = !model.isChecked
        items[indexPath.row] = model
        
        currentTotalPrice += (model.isChecked ? 1 : -1) * Double(model.price)! * Double(model.amount)!
        updatePriceWithStr("\(currentTotalPrice)")
        
        tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .None)
        
        
    }
}
