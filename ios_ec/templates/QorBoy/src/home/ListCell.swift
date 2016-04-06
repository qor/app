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
    var descLbl = UILabel(frame: CGRectZero)
    var priceLbl = UILabel(frame: CGRectZero)
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(logoImgV)
        contentView.addSubview(titleLbl)
        contentView.addSubview(descLbl)
        contentView.addSubview(priceLbl)
        
        titleLbl.numberOfLines = 1
        titleLbl.font = UIFont.boldSystemFontOfSize(16)
        titleLbl.textColor = UIColor.blackColor()
        
        descLbl.font = UIFont.systemFontOfSize(13)
        descLbl.numberOfLines = 2
        descLbl.textColor = UIColor.lightGrayColor()
        
        priceLbl.textColor = UIColor.redColor()
        priceLbl.font = UIFont.systemFontOfSize(15)
        
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
            t.top == t.superview!.top + 10
            t.height == 20
        }
        constrain(titleLbl, logoImgV) { (t, l) in
            t.leading == l.trailing + 40
        }
        
        constrain(descLbl, titleLbl) { (a, t) in
            a.top == t.bottom + 5
        }
        
        constrain(titleLbl, descLbl, priceLbl) { (t, a, p) in
            align(left: t, a, p)
        }
        constrain(priceLbl) { (p) in
            p.bottom == p.superview!.bottom - 10
        }
        
        constrain(descLbl, priceLbl) { (d, p) in
            d.bottom == p.top
            d.trailing == d.superview!.trailing - 10
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func refreshCellWithModel(model: Product) {
        
        titleLbl.text = model.name
        descLbl.text = model.desc
        priceLbl.text = "$ \(model.price)"
        logoImgV.kf_setImageWithURL(NSURL(string: "\(APIClient.sharedClient.base)\(model.mainImage)")!)
    }
}
