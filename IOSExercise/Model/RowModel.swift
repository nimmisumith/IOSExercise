//
//  RowModel.swift
//  IosExerciseA
//
//  Created by Nimmi P on 25/09/20.
//  Copyright © 2020 Nimmi P. All rights reserved.
//


// codable structure for storing parsed json data
struct Rows: Codable{
    let title: String
    let rows: [RowModel]
}
// data model for each row
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
