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
    var product: Product?
    let bottomHeight:CGFloat = 40
    let popVCHeight = UIScreen.mainScreen().bounds.size.height * 0.75
    var bannerImgV = UIImageView(frame: CGRectZero)
    var cartBtn = UIButton(type: .Custom)
    var amountLbl = UILabel(frame: CGRectZero)
    var tableView: UITableView?
    var data = []
    var actionSheet:UIAlertController?
    var popupVC: PopupController?
    var popGroup: ConstraintGroup?
    var shadowV = UIView(frame: CGRectZero)
    var shadowGroup: ConstraintGroup?
    var cartVC = CartViewController()
    
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
        
        cartBtn.setTitle("Add to Cart", forState: .Normal)
        cartBtn.backgroundColor = UIColor.orangeColor()
        cartBtn.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        cartBtn.titleLabel?.font = UIFont.boldSystemFontOfSize(16)
        cartBtn.addTarget(self, action: #selector(addToCart), forControlEvents: .TouchUpInside)
        view.addSubview(cartBtn)
        
        setupConstraints()
        
        setupShadowView()
        setupPopVC()
        
        getData()
    }
    
    func setupShadowView() {
        shadowV.backgroundColor = UIColor.blackColor()
        shadowV.alpha = 0.0
        navigationController!.view.addSubview(shadowV)
        
        shadowGroup = constrain(shadowV) { (s) in
            s.leading == s.superview!.leading
            s.trailing == s.superview!.trailing
            s.top == s.superview!.top
            s.bottom == s.superview!.bottom
        }
        let tapGr = UITapGestureRecognizer(target: self, action: #selector(tapShadow))
        shadowV.addGestureRecognizer(tapGr)
    }
    
    func tapShadow() {
        dismissPopVC(true)
    }
    
    func setupPopVC() {
        popupVC = PopupController()
        popupVC!.closeBlock = {self.dismissPopVC(true)}
        addChildViewController(popupVC!)
        view.addSubview(popupVC!.view)
        popupVC!.didMoveToParentViewController(self)
        
        popGroup = constrain(popupVC!.view) { (v) in
            v.width == v.superview!.width
            v.leading == v.superview!.leading
            v.height == popVCHeight
            v.top == v.superview!.bottom
        }
        
        popupVC!.chooseBlock = {(color: String, size: String, amount: String) -> () in
            
            print("size: \(size)")
            self.dismissPopVC(false)

            self.cartVC.item = self.item
            self.cartVC.amount = amount
            self.cartVC.color = color
            self.cartVC.size = size
            
            self.navigationController!.pushViewController(self.cartVC, animated: true)
        }
    }
    
    private func showPopVC() {
        
        constrain(popupVC!.view, replace: popGroup!) { (v) in
            v.bottom == v.superview!.bottom
            v.leading == v.superview!.leading
            v.trailing == v.superview!.trailing
            v.height == popVCHeight
        }
        
        constrain(shadowV, replace: shadowGroup!) { (s) in
            s.leading == s.superview!.leading
            s.trailing == s.superview!.trailing
            s.top == s.superview!.top
            s.bottom == s.superview!.bottom - popVCHeight
        }
        UIView.animateWithDuration(0.5, animations: navigationController!.view.layoutIfNeeded)
        UIView.animateWithDuration(0.5, animations: {
            self.shadowV.alpha = 0.4 * (self.view.frame.size.height - self.popupVC!.view.frame.origin.y)/self.popVCHeight
            }) { (finished) in
        }
    }
    
    func dismissPopVC(animated: Bool) {
        constrain(popupVC!.view, replace: popGroup!) { (v) in
            v.width == v.superview!.width
            v.leading == v.superview!.leading
            v.height == popVCHeight
            v.top == v.superview!.bottom
        }
        constrain(shadowV, replace: shadowGroup!) { (s) in
            s.leading == s.superview!.leading
            s.trailing == s.superview!.trailing
            s.top == s.superview!.top
            s.bottom == s.superview!.bottom
        }
        
        var time = 0.0
        if animated {
            time = 0.5
        }
        UIView.animateWithDuration(time, animations: navigationController!.view.layoutIfNeeded)
        UIView.animateWithDuration(time, animations: {
            self.shadowV.alpha = 0.4 * (self.view.frame.size.height - self.popupVC!.view.frame.origin.y)/self.popVCHeight
        }) { (finished) in
        }
    }
    
    func getData() {
        APIClient.sharedClient.get(path: "/products/\(product!.code).json", modelClass: ProductDetail.self) { (model) in
            if !model.isError {
                
                self.item = model as? ProductDetail
                self.tableView!.reloadData()
                
                self.bannerImgV.kf_setImageWithURL(NSURL(string: "\(APIClient.sharedClient.base)\(self.item!.mainImage)")!)
                
                self.popupVC!.item = self.item
                
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
        navigationController!.pushViewController(cartVC, animated: true)
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
        
        showPopVC()
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
        
        constrain(cartBtn) { (c) in
            c.bottom == c.superview!.bottom
            c.trailing == c.superview!.trailing
            c.leading == c.superview!.leading
            c.height == bottomHeight
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
