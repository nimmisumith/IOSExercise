//
//  ApiCalls.swift
//  IosExerciseA
//
//  Created by Nimmi P on 25/09/20.
//  Copyright © 2020 Nimmi P. All rights reserved.
//

import Foundation

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
    //read data from url
    func getJsonFromUrl(complete: @escaping (Bool, [RowModel], Error?) -> ()) {
        
        DispatchQueue.global().async {
            sleep(3)
            URLSession.shared.dataTask(with: self.url, completionHandler: {data, response, error in
                
                if error != nil{
                    self.readJsonFile(fileName: "file"){ [weak self] (success, rows, error) in
                        complete(success, rows, nil)
                    }
                    return
                }
                guard let data = data else{
                    return
                }
                
                let decoder = JSONDecoder()
                do{
                    let rdata = try decoder.decode(Rows.self,from: data)
                    self.serverdata.title = rdata.title
                    complete(true, rdata.rows, nil)

                
                }catch{
                    self.readJsonFile(fileName: "file"){ [weak self] (success, rows, error) in
                        complete(success, rows, nil)
                    }
                }
            }).resume()
        }
    }
    
    //Read data from file if api fails to load
    func readJsonFile(fileName: String,complete: @escaping (Bool, [RowModel], Error?) -> ()) {
        
        if let path = Bundle.main.path(forResource: fileName, ofType: "json") {
            
            do {
                
                let json = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let decoder = JSONDecoder()
                
                let rdata = try decoder.decode(Rows.self,from: json)
                self.serverdata.title = rdata.title
                complete(true, rdata.rows, nil)
                
            }catch let error {
                print("parse error: \(error.localizedDescription)")
            }
            
        }
        
    }
    
}
