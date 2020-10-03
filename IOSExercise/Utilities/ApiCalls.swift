//
//  ApiCalls.swift
//  IosExerciseA
//
//  Created by Nimmi P on 25/09/20.
//  Copyright © 2020 Nimmi P. All rights reserved.
//

import Foundation
import SwiftyJSON

//enum APIError: String,Error {
//    case noNetwork = "No Network"
//}
protocol APIServiceProtocol{
    func getJsonFromUrl(complete: @escaping(_ success : Bool, _ data :[RowModel],_ error : Error? )->())
}
class ApiCalls: NSObject, APIServiceProtocol{
    
    var serverdata: ServerData!
    var url : URL!
    
    override init() {
        super.init()
        url = URL( string: Constants.URL_PATH)!
        serverdata = ServerData.sharedInstance
    }
    
    func getJsonFromUrl(complete: @escaping (Bool, [RowModel], Error?) -> ()) {
        
        DispatchQueue.global().async {
            sleep(3)
            URLSession.shared.dataTask(with: self.url, completionHandler: {data, response, error in
                
                if let error = error{
                    print("dataTask error : \(error)")
                    self.readJsonFile(fileName: "file"){ [weak self] (success, rows, error) in
                        
                        for row in rows{
                            print("row :::  \(row.rowtitle)")
                        }
                        complete(success, rows, nil)
                        
                    }
                    return
                }
                guard let data = data else{
                    print("no data")
                    return
                }
                print("data here....  \(data)")
                
                let swiftyJsonVar = JSON(data)
               //  print("data in string : \(swiftyJsonVar)")
                
                self.serverdata.title = swiftyJsonVar["title"].stringValue
                print(swiftyJsonVar["title"].stringValue)
                let decoder = JSONDecoder()
                
             
                do{
                    let rdata = try decoder.decode(Rows.self,from: data)
                                   print(rdata.title,rdata.rows.count)
                                   complete(true, rdata.rows, nil)

                
                }catch let error {
                    print("parse error: \(error.localizedDescription)")
                    print("Correpted data")
                    self.readJsonFile(fileName: "file"){ [weak self] (success, rows, error) in
                        
                        complete(success, rows, nil)
                        
                    }
                }
            }).resume()
        }
    }
    
    func readJsonFile(fileName: String,complete: @escaping (Bool, [RowModel], Error?) -> ()) {
        print("Read data from file")
        if let path = Bundle.main.path(forResource: fileName, ofType: "json") {
            
            do {
                
                let json = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let swiftyJsonVar = JSON(json)
                self.serverdata.title = swiftyJsonVar["title"].stringValue
                print("data here file....  \(json)")
                let decoder = JSONDecoder()
                
                let rdata = try decoder.decode(Rows.self,from: json)
                print(rdata.title,rdata.rows.count)
                complete(true, rdata.rows, nil)
                
                print("getJsonFromUrl completion")
                
                
                
                
            }catch let error {
                print("parse error: \(error.localizedDescription)")
            }
            
        }
        
    }
    
}

//public protocol LoadDataDelegate: class{
//    func dataLoaded(_:Bool)
//}
//
//class ApiCalls : NSObject{
//
//    var load_data_delegate: LoadDataDelegate!
//
//    var url : URL!
//    var serverdata: ServerData!
//
//    override init() {
//        super.init()
//        url = URL( string: "https://dl.dropboxusercontent.com/s/2iodh4vg0eortkl/facts.json")!
//        serverdata = ServerData.sharedInstance
//    }
//
//    func readJsonFile(fileName: String) {
//        print("Read data from file")
//        if let path = Bundle.main.path(forResource: fileName, ofType: "json") {
//
//            do {
//
//                let json = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
//                let swiftyJsonVar = JSON(json)
//                self.serverdata.title = swiftyJsonVar["title"].stringValue
//
//                for item in swiftyJsonVar["rows"].arrayValue{
//                    let dataObj = RowModel(json: item)
//                    self.serverdata.jsonData.append(dataObj)
//                }
//
//                self.load_data_delegate?.dataLoaded(true)
//
//            }catch let error {
//                print("parse error: \(error.localizedDescription)")
//            }
//
//        }
//
//    }
//
//    func getJsonFromUrl(){
//
//        URLSession.shared.dataTask(with: url, completionHandler: {data, response, error in
//
//            if let error = error{
//                print(error)
//                self.load_data_delegate?.dataLoaded(false)
//                return
//            }
//            guard let data = data else{
//                self.load_data_delegate?.dataLoaded(false)
//                return
//            }
//
//
//
//            let swiftyJsonVar = JSON(data)
//            self.serverdata.title = swiftyJsonVar["title"].stringValue
//
//            for item in swiftyJsonVar["rows"].arrayValue{
//                let dataObj = RowModel(json: item)
//                self.serverdata.jsonData.append(dataObj)
//            }
//
//            self.load_data_delegate?.dataLoaded(true)
//
//
//
//        }).resume()
//
//    }
//
//
//
//}
