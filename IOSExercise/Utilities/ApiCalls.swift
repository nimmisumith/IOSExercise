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
   // var _headers : HTTPHeaders!
    var serverdata: ServerData!
    
    override init() {
        super.init()
        url = URL( string: "https://dl.dropboxusercontent.com/s/2iodh4vg0eortkl/facts.json")!
   //     _headers = ["Content-Type":"application/x-www-form-urlencoded"]
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
                
                  // if let parsedData = try? JSONSerialization.jsonObject(with: json) as AnyObject {
                       
                    
//                       let title = parsedData["title"] as! String
//                       print(title)
//                       if let array = parsedData["rows"] as? NSArray{
//                        for i in 0 ..< array.count{
//                           if let object = array[i] as? Dictionary<String, AnyObject>{
//                            let title = object["title"] as? String
//                            let descript = object["description"] as? String
//                            let imageHref = object["imageHref"] as? String
//
//                            }
//                        }
//                       }
                //   }
                   
               }catch let error {
                   print("parse error: \(error.localizedDescription)")
               }
               
           }
           
       }
    
    public enum Result<T>{
        case success(T)
        case failure(Error)
    }
    
    func getJsonFromUrl(){
        
        URLSession.shared.dataTask(with: url, completionHandler: {data, response, error in
            
            if let error = error{
                //completion(.failure(error))
                print(error)
                self.readJsonFile(fileName: "file")
                return
            }
            guard let data = data, error == nil else{
                return
            }
            
                print("data........\(data)")
               
                    
                       let swiftyJsonVar = JSON(data)
                       self.serverdata.title = swiftyJsonVar["title"].stringValue
                    
                       for item in swiftyJsonVar["rows"].arrayValue{
                            let dataObj = RowModel(json: item)
                            self.serverdata.jsonData.append(dataObj)
                       }
                       
                       self.load_data_delegate?.dataLoaded(true)
                    
                
           
        }).resume()
        
    }
    
    func getUrlImage(url:URL, completion: @escaping (Data?, URLResponse?,Error?) -> ()){
        
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    func downloadImage(url:URL, completion: @escaping (Result<Data>) -> Void){
        getUrlImage(url: url){ data, response, error in
            
            if let error = error{
                completion(.failure(error))
                print(error)
                return
            }
            guard let data = data, error == nil else{
                return
            }
            DispatchQueue.main.async {
                completion(.success(data))
            }
        }
    }
       
    
//    func readData(){
//
//        AF.sessionConfiguration.timeoutIntervalForRequest = 600
//        AF.sessionConfiguration.timeoutIntervalForResource = 600
//        AF.request(url, method: .post, encoding: URLEncoding.httpBody, headers: _headers)
//        .validate()
//            .responseData(emptyResponseCodes: [200,204,205], completionHandler: {(responseData) -> Void in
//
//            switch responseData.result{
//            case .failure(let error):
//                print("error \(error)")
//            case .success(let json):
//                let swiftyJsonVar = JSON(json)
//                print(swiftyJsonVar)
//            }
//
//        })
//
//    }
    
//    func readDataFromURL(){
//        let sessionConfig = URLSessionConfiguration.default
//        sessionConfig.timeoutIntervalForRequest = 30.0
//        sessionConfig.timeoutIntervalForResource = 60.0
//        sessionConfig.httpCookieStorage = nil
//
//        let session = URLSession(configuration: sessionConfig)
//        var request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData)
//        request.httpMethod = "GET"
//        request.setValue("Application/json",forHTTPHeaderField: "Content-Type")
////        guard let httpBody = try? JSONSerialization.data(withJSONObject:[], options:[]) else{
////            return
////        }
//       // request.httpBody = httpBody
//        session.dataTask(with: request, completionHandler: { data, response, error in
//            //check response
//            if let response = response{
//                print(response)
//            }
//            print("Error ",error)
////            if error != nil{
////                print(error ?? "No error value")
////                print("return from error")
////                return
////            }
//
//            if let data = data{
//                print("data........\(data)")
//                do{
//                    let swiftyJsonVar = JSON(data)
//                    print(swiftyJsonVar["title"])
//                    let json = try JSONSerialization.jsonObject(with: data, options : [])
//                    print("success")
//                    print(json)
//
//                }
//                catch{
//                    print(error)
//                }
//            }
//        }).resume()
//    }
//
    
    
}
