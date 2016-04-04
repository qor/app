//
//  ColorVariations.swift
//  QorDemo
//
//  Created by Neo Chow on 31/3/2016.
//  Copyright © 2016 NeoChow. All rights reserved.
//

import Foundation
import SwiftyJSON
/*
 {
 Color: "Black",
 ID: 9,
 Images: [],
 SizeVariations: []
 }
 */

struct ColorVariation:BaseModel {
    var isError: Bool { return false }
    var error: String?
    
    var id: Int
    var color: String
    
    var images: [Image]
    var sizeVariations: [SizeVariation]
    
    init(json: JSON) {
        id                  = json["ID"].intValue
        color               = json["Color"].stringValue
        
        images = []
        for obj in json["Images"].arrayValue {
            images.append(Image(json: obj))
        }

        sizeVariations = []
        for obj in json["SizeVariations"].arrayValue {
            sizeVariations.append(SizeVariation(json: obj))
        }
    }
}

