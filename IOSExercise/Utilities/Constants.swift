//
//  Constants.swift
//  IosExerciseA
//
//  Created by Nimmi P on 25/09/20.
//  Copyright © 2020 Nimmi P. All rights reserved.
//

import Foundation
import UIKit

struct Constants{
    // Constant strings to be used across application
    static let URL_PATH = "https://dl.dropboxusercontent.com/s/2iodh4vg0eortkl/facts.json"
    static let InternetCheckMessage = "Please check your Internet Connection..."
    // ViewController
    static let navigation_height = 44.0
    static let statusbar_height = 22
    static let indicator_size = 40
    static let tableview_top_margin = 60
    static let animate_duration = 0.2
    static let alpha_0: CGFloat = 0.0
    static let alpha_1: CGFloat = 1.0
    static let zero = 0
    //Rowcell
    static let cell_identifier: String = "row_cell"
    static let emptyString = ""
    static let infinite_lines = -1
    static let title_fontsize = 20.0
    static let normal_fontsize = 17.0
    static let stack_padding: CGFloat = 20
    static let stack_spacing: CGFloat = 10
    static let image_width = 300
    static let image_height = 250
    //ApiCalls
    static let json_file = "file"
    //UISceneDelegate
    static let uiscene_config_name = "Default Configuration"
    //Utility
    static let toast_x: CGFloat = 20
    static let toast_y: CGFloat = 200
    static let toast_w: CGFloat = 40
    static let toast_h: CGFloat = 35
    static let toast_alpha: CGFloat = 0.6
    static let toast_duration = 4.0
    static let toast_delay = 0.1
    static let toast_radius: CGFloat = 10
    
}
