//
//  Goods.swift
//  QorDemo
//
//  Created by Neo Chow on 30/3/2016.
//  Copyright © 2016 NeoChow. All rights reserved.
//

import Foundation

struct Goods {
    var title: String!
    var amount: String!
    var price : String!
    var imageUrlStr : String!
    var isChecked = false
    var color:String?
    var size:String?
    
    init(title: String, amount: String, price: String, imgUrlStr: String, color: String, size: String) {
        self.title = title
        self.amount = amount
        self.price = price
        self.imageUrlStr = imgUrlStr
        self.color = color
        self.size = size
    }
}
