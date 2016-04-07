//
//  ChooseBtn.swift
//  QorDemo
//
//  Created by Neo Chow on 5/4/2016.
//  Copyright © 2016 NeoChow. All rights reserved.
//

import UIKit

class ChooseBtn: UIButton {

    var isChosen: Bool = false {
        didSet {
            if isChosen {
                highlight()
            } else {
                normalState()
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.cornerRadius = 5
        self.layer.masksToBounds = true
        titleLabel?.font = UIFont.systemFontOfSize(13)
    }
    
    convenience init(type buttonType: UIButtonType) {
        self.init(frame: CGRectZero)        
        // this button be automatically .Custom
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func highlight() {
        backgroundColor = UIColor.orangeColor()
        setTitleColor(UIColor.whiteColor(), forState: .Normal)
    }
    
    func normalState() {
        backgroundColor = UIColor(red: 244/255.0, green: 244/255.0, blue: 244/255.0, alpha: 1)
        setTitleColor(UIColor.blackColor(), forState: .Normal)
    }
}
