//
//  ServerData.swift
//  IosExerciseA
//
//  Created by Nimmi P on 25/09/20.
//  Copyright © 2020 Nimmi P. All rights reserved.
//

import Foundation

class ServerData{

    static let sharedInstance = ServerData()

    var title : String?
    var jsonData = [RowModel]()
}
