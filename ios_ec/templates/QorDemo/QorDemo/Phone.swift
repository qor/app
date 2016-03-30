//
//  Phone.swift
//  QorDemo
//
//  Created by Neo Chow on 21/3/2016.
//  Copyright © 2016 NeoChow. All rights reserved.
//

import Foundation

struct Phone {
    var title: String!
    var amount: String!
    var price : String!
    var imageUrlStr : String!
    
    init(title: String, amount: String, price: String, imgUrlStr: String) {
        self.title = title
        self.amount = amount
        self.price = price
        self.imageUrlStr = imgUrlStr
    }
}