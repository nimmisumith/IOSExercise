//
//  ApiCalls.swift
//  IosExerciseA
//
//  Created by Nimmi P on 25/09/20.
//  Copyright © 2020 Nimmi P. All rights reserved.
//

import Foundation
import SwiftyJSON


public protocol LoadDataDelegate: class{
    func dataLoaded(_:Bool)
}

class ApiCalls : NSObject{
    
    var load_data_delegate: LoadDataDelegate!
    
    var url : URL!
    var serverdata: ServerData!
    
    override init() {
        super.init()
        url = URL( string: "https://dl.dropboxusercontent.com/s/2iodh4vg0eortkl/facts.json")!
        serverdata = ServerData.sharedInstance
    }
    
    func readJsonFile(fileName: String) {
        print("Read data from file")
        if let path = Bundle.main.path(forResource: fileName, ofType: "json") {
            
            do {
                
                let json = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let swiftyJsonVar = JSON(json)
                self.serverdata.title = swiftyJsonVar["title"].stringValue
                
                for item in swiftyJsonVar["rows"].arrayValue{
                    let dataObj = RowModel(json: item)
                    self.serverdata.jsonData.append(dataObj)
                }
                
                self.load_data_delegate?.dataLoaded(true)
                
            }catch let error {
                print("parse error: \(error.localizedDescription)")
            }
            
        }
        
    }
    
    func getJsonFromUrl(){
        
        URLSession.shared.dataTask(with: url, completionHandler: {data, response, error in
            
            if let error = error{
                print(error)
                self.load_data_delegate?.dataLoaded(false)
                return
            }
            guard let data = data else{
                self.load_data_delegate?.dataLoaded(false)
                return
            }
            
            
            
            let swiftyJsonVar = JSON(data)
            self.serverdata.title = swiftyJsonVar["title"].stringValue
            
            for item in swiftyJsonVar["rows"].arrayValue{
                let dataObj = RowModel(json: item)
                self.serverdata.jsonData.append(dataObj)
            }
            
            self.load_data_delegate?.dataLoaded(true)
            
            
            
        }).resume()
        
    }
    
    
    
}
