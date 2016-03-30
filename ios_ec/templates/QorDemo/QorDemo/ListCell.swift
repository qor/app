//
//  ListCell.swift
//  QorDemo
//
//  Created by Neo Chow on 21/3/2016.
//  Copyright © 2016 NeoChow. All rights reserved.
//

import UIKit

class ListCell: UITableViewCell {

    @IBOutlet weak var logoImgV: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var amoutLbl: UILabel!
    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var buyBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        buyBtn.layer.cornerRadius = 5
        buyBtn.layer.borderColor = UIColor.redColor().CGColor
        buyBtn.layer.borderWidth = 1
        //buyBtn.setTitleColor(UIColor.redColor(), forState: .Normal)
        
    }

}
