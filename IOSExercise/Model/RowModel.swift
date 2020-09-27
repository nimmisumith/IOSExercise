//
//  RowModel.swift
//  IosExerciseA
//
//  Created by Nimmi P on 25/09/20.
//  Copyright © 2020 Nimmi P. All rights reserved.
//

import UIKit
import SwiftyJSON

class RowModel: NSObject {

       var rowtitle: String
       var descript: String
       var imageHref: String
       
       init(json: JSON) {
           self.rowtitle = json["title"].stringValue
           self.descript = json["description"].stringValue
           self.imageHref = json["imageHref"].stringValue
       }
}
