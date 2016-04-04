//
//  popupController.swift
//  QorDemo
//
//  Created by Neo Chow on 4/4/2016.
//  Copyright © 2016 NeoChow. All rights reserved.
//

import UIKit
import Cartography
import Kingfisher

class PopupController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    typealias simpleHandler = ()->()
    var closeBlock: simpleHandler?
    
    typealias chooseHandler = (color: String, size: String, amount: String)->()
    var chooseBlock: chooseHandler?
    
    let bottomHeight:CGFloat = 40
    let imgHeight:CGFloat = 100
    var confirmBtn = UIButton(type: .Custom)
    var imgV = UIImageView(frame: CGRectZero)
    var priceLbl = UILabel(frame: CGRectZero)
    var remainedLbl = UILabel(frame: CGRectZero)
    var remainedCount = 0
    var tableView: UITableView?
    var item: ProductDetail? {
        didSet {
            updateData()
        }
    }
    var currentProduct: ColorVariation?
    var currentSizeVariation: SizeVariation?
    
    var currentColorIndex: Int = 0
    var currentSizeIndex: Int = 0
    var amountLbl:UILabel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.whiteColor()// UIColor.cyanColor()
        
        setupCloseBtn()
        
        confirmBtn.setTitle("Confirm", forState: .Normal)
        confirmBtn.backgroundColor = UIColor.orangeColor()
        confirmBtn.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        confirmBtn.titleLabel?.font = UIFont.boldSystemFontOfSize(15)
        view.addSubview(confirmBtn)
        constrain(confirmBtn) { (c) in
            c.leading == c.superview!.leading
            c.trailing == c.superview!.trailing
            c.bottom == c.superview!.bottom
            c.height == bottomHeight
        }
        confirmBtn.addTarget(self, action: #selector(confirmSelection), forControlEvents: .TouchUpInside)
        
        view.addSubview(imgV)
        constrain(imgV) { (i) in
            i.leading == i.superview!.leading + 15
            i.top == i.superview!.top + 10
            i.height == imgHeight
            i.width == i.height
        }
        
        view.addSubview(priceLbl)
        priceLbl.textColor = UIColor.orangeColor()
        constrain(imgV, priceLbl) { (i, p) in
            p.leading == i.trailing + 20
            p.bottom == i.centerY - 2.5
        }
        
        view.addSubview(remainedLbl)
        constrain(remainedLbl, priceLbl) { (a, p) in
            a.leading == p.leading
            a.top == p.bottom + 5
        }
        
        tableView = UITableView(frame: CGRectZero, style: .Plain)
        view.addSubview(tableView!)
        tableView!.dataSource = self
        tableView!.delegate = self
        tableView!.tableFooterView = UIView(frame: CGRectZero)
        constrain(tableView!, imgV, confirmBtn) { (t, i, c) in
            t.leading == t.superview!.leading
            t.trailing == t.superview!.trailing
            t.top == i.bottom + 10
            t.bottom == c.top - 10
        }
    }
    
    func updateData() {
        if let product = self.item {
            if product.colorVariations.count == 0 {
                return
            }
            self.currentProduct = product.colorVariations.first
            
            self.imgV.kf_setImageWithURL(NSURL(string: "\(APIClient.sharedClient.base)\(product.mainImage)")!)
            self.priceLbl.text = "$ \(product.price)"
            
            if self.currentProduct?.sizeVariations.count > 0 {
                self.currentSizeVariation = self.currentProduct?.sizeVariations.first
                self.remainedLbl.text = "Remained: \(self.currentSizeVariation!.quantity)"
                self.remainedCount = self.currentSizeVariation!.quantity
            }
            
            self.tableView?.reloadData()
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if let _ = self.item {
            return 3
        }
        return 0
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Choose Color"
        } else if section == 1 {
            return "Choose Size"
        } else {
            return "Choose Quantity"
        }
    }
    
    func chooseColor(sender: ChooseBtn) {
        
        currentColorIndex = sender.tag
        sender.isChosen = !sender.isChosen
        tableView!.reloadData()
    }
    
    func chooseSize(sender: ChooseBtn) {
        
        currentSizeIndex = sender.tag
        sender.isChosen = !sender.isChosen
        tableView!.reloadData()
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .Default, reuseIdentifier: nil)
        cell.selectionStyle = .None
        
        if indexPath.section == 0 {
            var lastBtn:UIButton?
            var colorIndex = 0
            for colorVara in item!.colorVariations {
                let btn = ChooseBtn(type: .Custom)
                btn.setTitle(colorVara.color, forState: .Normal)
                cell.contentView.addSubview(btn)
                btn.tag = colorIndex
                btn.isChosen = colorIndex == currentColorIndex
                colorIndex += 1
                
                btn.addTarget(self, action: #selector(chooseColor(_:)), forControlEvents: .TouchUpInside)
                
                if let last = lastBtn {
                    constrain(btn, last, block: { (b, l) in
                        b.leading == l.trailing + 15
                        b.centerY == l.centerY
                    })
                } else {
                    constrain(btn, block: { (b) in
                        b.centerY == b.superview!.centerY
                        b.leading == b.superview!.leading + 10
                    })
                }
                lastBtn = btn
            }
        } else if indexPath.section == 1 {
            var lastBtn:UIButton?
            var sizeIndex = 0
            if let sizeVars = self.currentProduct?.sizeVariations {
                for sizeVara in sizeVars {
                    let btn = ChooseBtn(type: .Custom)
                    btn.setTitle(sizeVara.size, forState: .Normal)
                    btn.highlight()
                    cell.contentView.addSubview(btn)
                    btn.tag = sizeIndex
                    btn.isChosen = sizeIndex == currentSizeIndex
                    sizeIndex += 1
                    
                    btn.addTarget(self, action: #selector(chooseSize(_:)), forControlEvents: .TouchUpInside)
                    
                    if let last = lastBtn {
                        constrain(btn, last, block: { (b, l) in
                            b.leading == l.trailing + 15
                            b.centerY == l.centerY
                        })
                    } else {
                        constrain(btn, block: { (b) in
                            b.centerY == b.superview!.centerY
                            b.leading == b.superview!.leading + 10
                        })
                    }
                    lastBtn = btn
                }

            }
            
        } else {
            
            cell.textLabel?.text = "Buy amount:"
            
            let leftBtn = UIButton(type: .Custom)
            let rightBtn = UIButton(type: .Custom)
            let lbl = UILabel(frame: CGRectZero)
            cell.contentView.addSubview(leftBtn)
            cell.contentView.addSubview(rightBtn)
            cell.contentView.addSubview(lbl)
            
            let bg = UIColor(red: 244/255.0, green: 244/255.0, blue: 244/255.0, alpha: 1)
            leftBtn.backgroundColor = bg
            rightBtn.backgroundColor = bg
            lbl.backgroundColor = bg
            lbl.text = "0"
            lbl.textAlignment = .Center
            leftBtn.setTitle(" - ", forState: .Normal)
            leftBtn.setTitleColor(UIColor.brownColor(), forState: .Normal)
            rightBtn.setTitleColor(UIColor.brownColor(), forState: .Normal)
            rightBtn.setTitle(" + ", forState: .Normal)
            amountLbl = lbl
            rightBtn.addTarget(self, action: #selector(increaseAmount), forControlEvents: .TouchUpInside)
            leftBtn.addTarget(self, action: #selector(decreaseAmount), forControlEvents: .TouchUpInside)
            
            constrain(leftBtn, rightBtn, lbl, block: { (l, r, m) in
                r.centerY == r.superview!.centerY
                m.centerY == r.centerY
                l.centerY == r.centerY
                
                r.trailing == r.superview!.trailing - 10
                m.trailing == r.leading - 10
                l.trailing == m.leading - 10
                l.width == m.width
                m.width == r.width
                
                l.height == m.height
                m.height == r.height
                
                m.top == m.superview!.top + 5
            })
        }

        return cell
    }
    
    func increaseAmount() {
        if Int(amountLbl!.text!)! < remainedCount {
            amountLbl?.text = "\(1 + Int(amountLbl!.text!)!)"
        }
    }
    
    func decreaseAmount() {
        if Int(amountLbl!.text!)! > 0 {
            amountLbl?.text = "\(-1 + Int(amountLbl!.text!)!)"
        }
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func showAmountAlert() {
        let alertController = UIAlertController(title: "", message: "Amount could not be 0", preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(
            UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel) { (dd) -> Void in
            }
        )
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    func confirmSelection() {
        
        if Int(amountLbl!.text!)! <= 0 {
            showAmountAlert()
            return
        }
        
        if let block = chooseBlock {
            let colorVa = item!.colorVariations[currentColorIndex]
            let sizeVa = self.currentProduct!.sizeVariations[currentSizeIndex]
            block(color: colorVa.color, size: sizeVa.size, amount: amountLbl!.text!)
        }
    }
    
    func setupCloseBtn() {
        let btn = UIButton(type: .Custom)
        view.addSubview(btn)
        btn.setTitle("close", forState: .Normal)
        btn.setTitleColor(UIColor.blueColor(), forState: .Normal)
        
        constrain(btn) { (b) in
            b.trailing == b.superview!.trailing - 10
            b.top == b.superview!.top
        }
        btn.addTarget(self, action: #selector(dismissSelf), forControlEvents: .TouchUpInside)
    }
    
    func dismissSelf() {
        if let block = closeBlock {
            block()
        }
    }
}
