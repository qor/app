//
//  Item.swift
//  QorDemo
//
//  Created by Neo Chow on 31/3/2016.
//  Copyright © 2016 NeoChow. All rights reserved.
//

import Foundation
import SwiftyJSON

struct ItemList:BaseModel {
    var isError: Bool { return false }
    var error: String?
  
    var products: [Product]
    
    init(json: JSON) {

        products = []
        for obj in json.arrayValue {
            products.append(Product(json: obj))
        }
    }
}
