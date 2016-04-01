//
//  ProductDetail.swift
//  QorDemo
//
//  Created by Neo Chow on 1/4/2016.
//  Copyright © 2016 NeoChow. All rights reserved.
//

import Foundation
import SwiftyJSON
/*
 Code: "plantbook-01",
 ColorVariations: [],
 Description: "The definitive notebook for geeks. Incredibly responsive tactile interface with handwriting recognition and battery life of several years! You can use any stylus with this device. Instant access with patented bookthumbing™ browsing technology. Can be used in landscape and portrait mode, works with any language.",
 ID: 9,
 MainImage: "/system/color_variation_images/9/image/9-book-c.20160316055616619095831.20160331142216185765657.png",
 Name: "The Plantbook",
 Price: 31.2
 */

struct ProductDetail:BaseModel {
    var isError: Bool { return false }
    var error: String?
    
    var id: Int
    var name: String
    var code: String
    var price: Double
    var desc: String
    var mainImage: String
    
    var colorVariations: [ColorVariation]
    
    init(json: JSON) {
        id                  = json["ID"].intValue
        name                = json["Name"].stringValue
        code                = json["Code"].stringValue
        price               = json["Price"].doubleValue
        desc                = json["Description"].stringValue
        mainImage           = json["MainImage"].stringValue
        
        colorVariations = []
        for variantion in json["ColorVariations"].arrayValue {
            colorVariations.append(ColorVariation(json: variantion))
        }
    }
}
