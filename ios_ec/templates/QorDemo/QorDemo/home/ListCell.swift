//
//  ListCell.swift
//  QorDemo
//
//  Created by Neo Chow on 21/3/2016.
//  Copyright © 2016 NeoChow. All rights reserved.
//

import UIKit
import Cartography

class ListCell: UITableViewCell {

    var logoImgV = UIImageView(frame: CGRectZero)
    var titleLbl = UILabel(frame: CGRectZero)
    var amountLbl = UILabel(frame: CGRectZero)
    var priceLbl = UILabel(frame: CGRectZero)
    var buyBtn = UIButton(type: .Custom)
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(logoImgV)
        contentView.addSubview(titleLbl)
        contentView.addSubview(amountLbl)
        contentView.addSubview(priceLbl)
        contentView.addSubview(buyBtn)
        
        titleLbl.numberOfLines = 2
        titleLbl.font = UIFont.boldSystemFontOfSize(16)
        titleLbl.textColor = UIColor.blackColor()
        
        amountLbl.font = UIFont.systemFontOfSize(13)
        amountLbl.textColor = UIColor.lightGrayColor()
        
        priceLbl.textColor = UIColor.redColor()
        priceLbl.font = UIFont.systemFontOfSize(15)
        
        buyBtn.layer.cornerRadius = 5
        buyBtn.layer.borderColor = UIColor.redColor().CGColor
        buyBtn.layer.borderWidth = 1
        buyBtn.setTitle("立即购买", forState: .Normal)
        buyBtn.titleLabel?.font = UIFont.systemFontOfSize(15)
        buyBtn.setTitleColor(UIColor.blueColor(), forState: .Normal)
        
        setupConstraints()
    }
    
    func setupConstraints() {
        
        constrain(logoImgV) { (l) in
            l.centerY == l.superview!.centerY
            l.top == l.superview!.top + 15
            l.width == l.height
            l.leading == l.superview!.leading + 20
        }
        
        constrain(titleLbl) { (t) in
            t.trailing == t.superview!.trailing - 20
            t.top == t.superview!.top + 15
        }
        constrain(titleLbl, logoImgV) { (t, l) in
            t.leading == l.trailing + 40
        }
        
        constrain(amountLbl, titleLbl) { (a, t) in
            a.top == t.bottom + 20
        }
        
        constrain(titleLbl, amountLbl, priceLbl) { (t, a, p) in
            align(left: t, a, p)
        }
        
        constrain(buyBtn) { (b) in
            b.trailing == b.superview!.trailing - 20
            b.bottom == b.superview!.bottom - 10
        }
        constrain(buyBtn, priceLbl) { (b, p) in
            b.bottom == p.bottom
        }
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func refreshCellWithModel(model: Phone) {
        
        titleLbl.text = model.title
        amountLbl.text = "月销 \(model.amount)件"
        priceLbl.text = "￥ \(model.price)"
        logoImgV.kf_setImageWithURL(NSURL(string: model.imageUrlStr)!)
    }
}
