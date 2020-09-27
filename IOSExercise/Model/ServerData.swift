//
//  ServerData.swift
//  IosExerciseA
//
//  Created by Nimmi P on 25/09/20.
//  Copyright © 2020 Nimmi P. All rights reserved.
//

import Foundation

class ServerData{

    // To store data in a common sharable place across the app
    static let sharedInstance = ServerData()

    var title : String?
    var jsonData = [RowModel]()
}
