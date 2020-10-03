//
//  RowModel.swift
//  IosExerciseA
//
//  Created by Nimmi P on 25/09/20.
//  Copyright © 2020 Nimmi P. All rights reserved.
//

import Foundation
import SwiftyJSON


struct Rows: Codable{
    let title: String
    let rows: [RowModel]
}
struct RowModel: Codable{
    let rowtitle: String?
    let descript: String?
    let imageHref: String?
    
    enum CodingKeys: String, CodingKey{
        case rowtitle = "title"
        case descript = "description"
        case imageHref = "imageHref"
    }
}

//class RowModel: NSObject {
//
//       var rowtitle: String
//       var descript: String
//       var imageHref: String
//
//       init(json: JSON) {
//           self.rowtitle = json["title"].stringValue
//           self.descript = json["description"].stringValue
//           self.imageHref = json["imageHref"].stringValue
//       }
//}
