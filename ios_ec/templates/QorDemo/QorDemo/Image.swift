//
//  Images.swift
//  QorDemo
//
//  Created by Neo Chow on 31/3/2016.
//  Copyright © 2016 NeoChow. All rights reserved.
//

import Foundation
import SwiftyJSON
/*
 {
 ID: 9,
 Image: "/system/color_variation_images/9/image/9-book-c.20160316055616619095831.20160331142216185765657.png"
 }
 */

struct Image:BaseModel {
    var isError: Bool { return false }
    var error: String?
    
    var id: Int
    var image: String
    
    init(json: JSON) {
        id              = json["ID"].intValue
        image           = json["Image"].stringValue
    }
}
