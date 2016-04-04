//
//  DetailViewController.swift
//  QorDemo
//
//  Created by Neo Chow on 21/3/2016.
//  Copyright © 2016 NeoChow. All rights reserved.
//

import UIKit
import Cartography

class DetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    var item: ProductDetail?
    let bottomHeight:CGFloat = 50
    let pickerHeight:CGFloat = 36.0 * 2
    var bannerImgV = UIImageView(frame: CGRectZero)
    var bottomView = UIView(frame: CGRectZero)
    var cartBtn = UIButton(type: .Custom)
    var amountLbl = UILabel(frame: CGRectZero)
    var lineV = UIView(frame: CGRectZero)
    var tableView: UITableView?
    var data = []
    let picker:UIPickerView = UIPickerView()
    var pickerGroup = ConstraintGroup()
    var actionSheet:UIAlertController?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        title = "Product Detail"
        edgesForExtendedLayout = .None
        view.backgroundColor = UIColor.whiteColor()
        
        let rightItem = UIBarButtonItem(title: "My Cart", style: .Plain, target: self, action: #selector(goToCart))
        navigationItem.rightBarButtonItem = rightItem
        
        tableView = UITableView(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.size.width, UIScreen.mainScreen().bounds.size.height-64-bottomHeight), style: .Plain)
        view.addSubview(tableView!)
        tableView?.dataSource = self
        tableView?.delegate = self
        tableView?.showsVerticalScrollIndicator = false
        tableView?.separatorStyle = .None
        tableView?.backgroundColor = UIColor.clearColor()
        
        let headV = UIView(frame: CGRectMake(0,0,CGRectGetWidth(tableView!.frame), 200))
        tableView!.tableHeaderView = headV
        headV.addSubview(bannerImgV)
        
        setupBottomView()
        
        getData()
    }
    
    func getData() {
        APIClient.sharedClient.get(path: "/products/pho-q.json", modelClass: ProductDetail.self) { (model) in
            if !model.isError {
                print("/products/pho-q.json parse model: \(model)")
                
                self.item = model as? ProductDetail
                self.tableView!.reloadData()
                
                self.bannerImgV.kf_setImageWithURL(NSURL(string: "\(APIClient.sharedClient.base)\(self.item!.mainImage)")!)
                
            } else {
                let alert = UIAlertController(title: "Network error", message: "try again?", preferredStyle: .Alert)
                let action = UIAlertAction(title: "OK", style: .Default, handler: { (a) in
                    self.getData()
                })
                alert.addAction(action)
                self.presentViewController(alert, animated: true, completion: nil)
            }

        }
    }
    
    func goToCart() {
        let cartVC = CartViewController()
        navigationController!.pushViewController(cartVC, animated: true)
    }
    
    func setupBottomView() {
        
        view.addSubview(bottomView)
        bottomView.addSubview(lineV)
        bottomView.addSubview(cartBtn)
        bottomView.addSubview(amountLbl)
        
        lineV.backgroundColor = UIColor(red: 234/255.0, green: 234/255.0, blue: 234/255.0, alpha: 1)
        bottomView.backgroundColor = UIColor.whiteColor()
        
        cartBtn.setTitle("Add to Cart", forState: .Normal)
        cartBtn.backgroundColor = UIColor.orangeColor()
        cartBtn.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        cartBtn.titleLabel?.font = UIFont.boldSystemFontOfSize(16)
        cartBtn.addTarget(self, action: #selector(addToCart), forControlEvents: .TouchUpInside)
        
        updateAmountWithStr("...")
        
        setupConstraints()
    }
    
    func updateAmountWithStr(amountStr: String) {
        let myAttribute = [ NSFontAttributeName: UIFont.systemFontOfSize(18) ]
        let myString = NSMutableAttributedString(string: "当前库存: ", attributes: myAttribute )
        
        let attrString = NSAttributedString(string: amountStr)
        myString.appendAttributedString(attrString)
        
        let myRange = NSRange(location: 6, length: attrString.length)
        myString.addAttribute(NSForegroundColorAttributeName, value: UIColor.orangeColor(), range: myRange)
        
        amountLbl.attributedText = myString
    }
    
    func addToCart() {
        
        goToCart()       
    }
    
    func buy() {
        let alertController = UIAlertController(title: "恭喜", message: "购买成功，回到首页", preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(
            UIAlertAction(title: "好的", style: UIAlertActionStyle.Cancel) { (dd) -> Void in
                self.navigationController!.popToRootViewControllerAnimated(true)
            }
        )
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    func setupConstraints() {
        
        constrain(bottomView) { (b) in
            b.height == bottomHeight
            b.leading == b.superview!.leading
            b.trailing == b.superview!.trailing
            b.bottom == b.superview!.bottom
        }
        
        constrain(lineV) { (l) in
            l.height == 1
            l.leading == l.superview!.leading
            l.trailing == l.superview!.trailing
            l.top == l.superview!.top
        }
        
        constrain(cartBtn) { (c) in
            c.top == c.superview!.top
            c.bottom == c.superview!.bottom
            c.trailing == c.superview!.trailing
            c.width == c.superview!.width / 3
        }
        
        constrain(amountLbl) { (a) in
            a.top == a.superview!.top
            a.bottom == a.superview!.bottom
            a.leading == a.superview!.leading + 20
        }
        
        constrain(bannerImgV) { (b) in
            b.top == b.superview!.top
            b.width == b.height
            b.centerX == b.superview!.centerX
            b.height == b.superview!.height
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 60
        } else if indexPath.section == 1 {
            return 40
        } else {
            return 140
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if let _ = item {
            return 3
        } else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Product Name"
        } else if section == 1 {
            return "Product Price"
        } else {
            return "Product Description"
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let _ = item {
            return 1
        } else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: nil)
        if indexPath.section == 0 {
            let titleLbl = UILabel(frame: CGRectZero)
            cell.contentView.addSubview(titleLbl)
            titleLbl.text = item!.name
            
            titleLbl.font = UIFont.systemFontOfSize(15)
            titleLbl.textColor = UIColor.blackColor()
            titleLbl.numberOfLines = 0
            
            constrain(titleLbl, block: { (t) in
               
                t.edges == inset(t.superview!.edges, 5, 20, 5, 20)
            })
            
        } else if indexPath.section == 1 {
            let priceLbl = UILabel(frame: cell.contentView.bounds)
            cell.contentView.addSubview(priceLbl)
            priceLbl.text = "$ \(item!.price)"
            
            priceLbl.textColor = UIColor.orangeColor()
            priceLbl.font = UIFont.systemFontOfSize(16)
            
            constrain(priceLbl, block: { (p) in
                
                p.edges == inset(p.superview!.edges, 10, 20, 10, 20)
            })

            
        } else {
            
            let descLbl = UILabel(frame: CGRectZero)
            cell.contentView.addSubview(descLbl)
            
            constrain(descLbl, block: { (d) in
                d.leading == d.superview!.leading + 20
                d.trailing == d.superview!.trailing - 20
                d.top == d.superview!.top + 15
                d.bottom == d.superview!.bottom - 15
            })
    
            descLbl.numberOfLines = 0
            descLbl.textColor = UIColor.lightGrayColor()
            descLbl.font = UIFont.systemFontOfSize(13)
            descLbl.text = item!.desc
        }
        
        return cell
    }
}
