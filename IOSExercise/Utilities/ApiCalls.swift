//
//  ApiCalls.swift
//  IosExerciseA
//
//  Created by Nimmi P on 25/09/20.
//  Copyright © 2020 Nimmi P. All rights reserved.
//

import Foundation

protocol APIServiceProtocol{
    func getJsonFromUrl(complete: @escaping(_ success : Bool, _ data :Rows,_ error : Error? )->())
}
class ApiCalls: NSObject, APIServiceProtocol{
    
    
    var url : URL!
    
    override init() {
        super.init()
        url = URL( string: Constants.URL_PATH)!
    }
    
    //read data from url
    func getJsonFromUrl(complete: @escaping (Bool, Rows, Error?) -> ()) {
        
        DispatchQueue.global().async {
            sleep(3)
            URLSession.shared.dataTask(with: self.url, completionHandler: {data, response, error in
                
                if error != nil{
                    self.readJsonFile(fileName: Constants.json_file){(success, rows, error) in
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
                   // self.serverdata.title = rdata.title
                    complete(true, rdata, nil)

                
                }catch{
                    self.readJsonFile(fileName: Constants.json_file){(success, rows, error) in
                        complete(success, rows, nil)
                    }
                }
            }).resume()
        }
    }
    
    //Read data from file if api fails to load
    func readJsonFile(fileName: String,complete: @escaping (Bool, Rows, Error?) -> ()) {
        
        if let path = Bundle.main.path(forResource: fileName, ofType: "json") {
            
            do {
                
                let json = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let decoder = JSONDecoder()
                
                let rdata = try decoder.decode(Rows.self,from: json)
               // self.serverdata.title = rdata.title
                complete(true, rdata, nil)
                
            }catch let error {
                print(error.localizedDescription)
            }
            
        }
        
    }
    
}
