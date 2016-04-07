//
//  CartTableViewCell.swift
//  QorDemo
//
//  Created by Neo Chow on 30/3/2016.
//  Copyright © 2016 NeoChow. All rights reserved.
//

import UIKit
import Cartography
import Kingfisher

class CartTableViewCell: UITableViewCell {
    
    let boxWidth:CGFloat = 30
    var imgV = UIImageView(frame: CGRectZero)
    var titleLbl = UILabel(frame: CGRectZero)
    var priceLbl = UILabel(frame: CGRectZero)
    var amountLbl = UILabel(frame: CGRectZero)
    var checkBox = UIView(frame: CGRectZero)
    var containerView = UIView(frame: CGRectZero)
    var colorBtn = ChooseBtn(type: .Custom)
    var sizeBtn = ChooseBtn(type: .Custom)
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(containerView)
        containerView.backgroundColor = UIColor(red: 252/255.0, green: 252.0/255, blue: 252/255.0, alpha: 1)
        backgroundColor = UIColor(red: 245/255.0, green: 245.0/255, blue: 245/255.0, alpha: 1)

        containerView.addSubview(imgV)
        containerView.addSubview(titleLbl)
        containerView.addSubview(priceLbl)
        containerView.addSubview(amountLbl)
        containerView.addSubview(checkBox)
        containerView.addSubview(colorBtn)
        containerView.addSubview(sizeBtn)
        
        setupBasicAttibutes()
        
        setupConstraints()
    }
    
    func setupBasicAttibutes() {
        checkBox.layer.cornerRadius = boxWidth/2
        checkBox.layer.masksToBounds = true
        
        imgV.userInteractionEnabled = true      
        
        titleLbl.numberOfLines = 0
        titleLbl.font = UIFont.systemFontOfSize(14)
        titleLbl.textColor = UIColor.blackColor()
        
        priceLbl.textColor = UIColor.orangeColor()
        priceLbl.font = UIFont.systemFontOfSize(15)
        
        amountLbl.font = UIFont.systemFontOfSize(14)
    }
    
    func setupConstraints() {
        
        constrain(containerView) { (c) in
            c.leading == c.superview!.leading
            c.trailing == c.superview!.trailing
            c.top == c.superview!.top+10
            c.bottom == c.superview!.bottom - 10
        }
        
        constrain(checkBox) { (c) in
            c.width == c.height
            c.width == boxWidth
            c.centerY == c.superview!.centerY
            c.leading == c.superview!.leading + 15
        }
        
        constrain(imgV) { (i) in
            i.width == i.height
            i.top == i.superview!.top + 10
            i.centerY == i.superview!.centerY
        }
        constrain(imgV, checkBox) { (i, c) in
            i.leading == c.trailing + 15
        }
        
        constrain(titleLbl, imgV) { (t, i) in
            t.top == i.top
            t.leading == i.trailing + 15
            t.trailing == t.superview!.trailing - 20
        }
        
        constrain(priceLbl, titleLbl) { (p, t) in
            p.leading == t.leading
        }
        constrain(priceLbl, imgV) { (p, i) in
            p.bottom == i.bottom
        }
        
        constrain(amountLbl, priceLbl) { (a, p) in
            a.bottom == p.bottom
            a.trailing == a.superview!.trailing - 20
        }
        
        constrain(colorBtn, sizeBtn, imgV) { (c, s, i) in
            c.centerY == s.centerY
            c.centerY == i.centerY
            
            c.leading == i.trailing + 15
            s.leading == c.trailing + 10
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func uncheck() {
        checkBox.backgroundColor = UIColor.clearColor()
        checkBox.layer.borderColor = UIColor.lightGrayColor().CGColor
        checkBox.layer.borderWidth = 1
    }
    
    private func highlightCheck() {
        checkBox.backgroundColor = UIColor.orangeColor()
        checkBox.layer.borderColor = UIColor.clearColor().CGColor
    }
    
    func refreshCellWithModel(model: Goods) {
        titleLbl.text = model.title
        amountLbl.text = "x\(model.amount)"
        priceLbl.text = "$ \(model.price)"
        
        if model.isChecked {
            highlightCheck()
        } else {
            uncheck()
        }
        
        if let collor = model.color {
            colorBtn.setTitle(collor, forState: .Normal)
            colorBtn.isChosen = true
            colorBtn.hidden = false
        } else {
            colorBtn.hidden = true
        }
        if let ssize = model.size {
            sizeBtn.setTitle(ssize, forState: .Normal)
            sizeBtn.isChosen = true
            sizeBtn.hidden = false
        } else {
            sizeBtn.hidden = true
        }
        
        
        imgV.kf_setImageWithURL(NSURL(string: "\(APIClient.sharedClient.base)\(model.imageUrlStr)")!)
    }
}
