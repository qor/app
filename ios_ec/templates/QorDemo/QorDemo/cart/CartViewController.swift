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
    var lineV = UIView(frame: CGRectZero)
    var item: ProductDetail?
    
    var amount: String = "0"
    var size: String?
    var color: String?

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "My Shopping Cart"
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
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        syncData()
    }
    
    func syncData() {
        readCartFile()
                
        if Int(amount) <= 0 && items.count == 0 {
            let alertController = UIAlertController(title: "Blank Cart", message: "Maybe you want some goods...", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(
                UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel) { (dd) -> Void in
                    self.navigationController!.popToRootViewControllerAnimated(true)
                }
            )
            presentViewController(alertController, animated: true, completion: nil)
        } else {
            if let _ = color {
                let good = Goods(title: item!.name, amount: amount, price: "\(item!.price)", imgUrlStr: item!.mainImage, color: color!, size: size!)
                items.append(good)
                tableView!.reloadData()
                writeCartFile()
                
            }
        }
    }
    
    func cartFilePath() -> String {
        let str = NSHomeDirectory()
        return "\(str)/Documents/cart.plist"
    }

    func readCartFile() {
        let arr = NSArray(contentsOfFile: cartFilePath())
        items.removeAll()
        if let arrCart = arr {
            for dict in arrCart {
                let dicc = dict as! [String: String]
                var good = Goods(title: dicc["name"]!, amount: dicc["amount"]!, price: dicc["price"]!, imgUrlStr: dicc["mainImage"]!, color: dicc["color"]!, size: dicc["size"]!)
                good.isChecked = false
                items.append(good)
            }
        }
    }
    
    func writeCartFile() {
        var itemArr:[[String:String!]] = []
        for good in items {
            if good.isChecked == false {
                let dict = ["name":good.title,
                            "amount":good.amount,
                            "price":good.price,
                            "mainImage":good.imageUrlStr,
                            "color":good.color,
                            "size":good.size]
                itemArr.append(dict)

            }
        }
        let cocoaArray : NSArray = itemArr
        cocoaArray.writeToFile(cartFilePath(), atomically: true)
    }
    
    func setupBottomView() {
        bottomView.backgroundColor = UIColor.whiteColor()
        bottomView.addSubview(lineV)
        bottomView.addSubview(buyBtn)
        bottomView.addSubview(totalPriceLbl)
        
        lineV.backgroundColor = UIColor(red: 234/255.0, green: 234/255.0, blue: 234/255.0, alpha: 1)
        
        buyBtn.backgroundColor = UIColor.orangeColor()
        buyBtn.setTitle("Paying", forState: .Normal)
        buyBtn.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        buyBtn.titleLabel?.font = UIFont.boldSystemFontOfSize(15)
        buyBtn.addTarget(self, action: #selector(calcTotalPrice), forControlEvents: .TouchUpInside)
        
        updatePriceWithStr("0.0")
        
        constrain(lineV) { (l) in
            l.height == 1
            l.leading == l.superview!.leading
            l.trailing == l.superview!.trailing
            l.top == l.superview!.top
        }
        
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
        let myString = NSMutableAttributedString(string: "Total Price: ", attributes: myAttribute )
        
        let attrString = NSAttributedString(string: priceStr)
        myString.appendAttributedString(attrString)
        
        let myRange = NSRange(location: "Total Price: ".length, length: attrString.length)
        myString.addAttribute(NSForegroundColorAttributeName, value: UIColor.orangeColor(), range: myRange)
        
        totalPriceLbl.attributedText = myString
    }
    
    func calcTotalPrice() {
        let alertController = UIAlertController(title: "Congratulations", message: "Buying succeed，Continue...", preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(
            UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel) { (dd) -> Void in
                self.navigationController!.popToRootViewControllerAnimated(true)
            }
        )
        writeCartFile()
        presentViewController(alertController, animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
