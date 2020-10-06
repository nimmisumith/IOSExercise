//
//  ApiCalls.swift
//  IosExerciseA
//
//  Created by Nimmi P on 25/09/20.
//  Copyright © 2020 Nimmi P. All rights reserved.
//

import Foundation


//Protocol that defines function for accessing data from url
protocol APIServiceProtocol{
    func getJsonFromUrl(complete: @escaping(_ : Bool, _ :Rows?, _ : Error?)->())
}

//Class that implements this protocol
class ApiCalls: NSObject, APIServiceProtocol{
    
    private var url : URL!
    
    override init() {
        super.init()
        url = URL( string: Constants.URL_PATH)!
    }
    
    //read data from url
    func getJsonFromUrl(complete: @escaping (Bool, Rows?, Error?) -> ()) {
    
        DispatchQueue.global().async {
            sleep(3)
            URLSession.shared.dataTask(with: self.url, completionHandler: {data, response, error in
                
                if error != nil{
                      complete(false, nil, error)
                      return
                }
                guard let data = data else{
                    return
                }
                //data load success
                let decoder = JSONDecoder()
                do{
                    let rdata = try decoder.decode(Rows.self,from: data)
                    complete(true, rdata, nil) 
                
                }catch let error{
                    complete(false, nil, error)
                }
            }).resume()
        }
    }
    
}
