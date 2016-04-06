//
//  SizeVariations.swift
//  QorDemo
//
//  Created by Neo Chow on 31/3/2016.
//  Copyright © 2016 NeoChow. All rights reserved.
//

import Foundation
import SwiftyJSON
/*
 {
 AvailableQuantity: 20,
 SKU: 26,
 Size: "S"
 }
 */

struct SizeVariation:BaseModel {
    var isError: Bool { return false }
    var error: String?
    
    var quantity: Int
    var sku: Int64
    var size: String
    
    init(json: JSON) {
        quantity                  = json["AvailableQuantity"].intValue
        sku                       = json["SKU"].int64Value
        size                      = json["Size"].stringValue        
    }
}
