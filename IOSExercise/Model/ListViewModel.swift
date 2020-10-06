//
//  ListViewModel.swift
//  IOSExercise
//
//  Created by Nimmi P on 01/10/20.
//  Copyright © 2020 Nimmi P. All rights reserved.
//

import Foundation
import SystemConfiguration //network checking

class ListViewModel{
    
    /*  A view model class that handle UI based on fetched data from api **/
    
    // Mark: private variables
    private let apiService: APIServiceProtocol
    
    private var rows:[RowModel] = [RowModel]()
    
    private var cellViews: [CellViewModel] = [CellViewModel](){
        didSet {
            self.reloadTableViewClosure?()
        }
    }
    
    // Mark: public variables
    var isLoading: Bool = false{
        didSet {
            self.updateLoadingStatus?()
        }
    }
    var alertMessage: String?{
        didSet{
            self.showAlertClosure?()
        }
    }
    var title: String?
    var numberOfCells: Int{
        return cellViews.count
    }
     var reloadTableViewClosure: (() -> ())?
     var showAlertClosure: (() -> ())?
     var updateLoadingStatus: (() -> ())?
    
    init(apiService: APIServiceProtocol = ApiCalls()) {
        self.apiService = apiService
    }
    
    // fetch data from api if network connection available. If error / no internet connection, showing an alert message accordingly
    func initFetch(){
        if isInternetAvailable(){  // Check if internet available
            self.isLoading = true
            apiService.getJsonFromUrl{ [weak self] (success, data, error) in
                self?.isLoading = false
                if error != nil { // show alertmessage if any error
                    self?.alertMessage = Constants.ErrorMessage
                }
                else{
                    // configure fetched data from server
                    if let data = data{
                        self?.setupFetchedData(data: data)
                    }
                }
            }
        }
        else{ // show alertmessage if no internet
            self.alertMessage = Constants.InternetCheckMessage
        }
    }
    
    // Returns cell viewmodel to cellForRowAt indexPath method for each row in tableview.
    func getCellViewModel(at indexPath: IndexPath) -> CellViewModel {
        return cellViews[indexPath.row]
    }
    
    //Creating cell viewmodel with values
    private func createCellViewModel(row: RowModel) -> CellViewModel{
        return CellViewModel(rowtitle: row.rowtitle ?? Constants.emptyString, descript: row.descript ?? Constants.emptyString, imageHref: row.imageHref ?? Constants.emptyString)
    }
    
    // Setup cell viewmodel for each row, if a value exists for a row
    private func setupFetchedData(data: Rows){
       
        self.rows = data.rows //cache data
        self.title = data.title
        var cellvm = [CellViewModel]()
        for row in rows{
            //Skip creating a row if all values are empty
            if row.rowtitle == nil && row.descript == nil && row.imageHref == nil {
                continue
            }
            cellvm.append(createCellViewModel(row: row))
        }
        self.cellViews = cellvm
    }
    
    //Check for internet
     private func isInternetAvailable() -> Bool{
          var zeroAddress = sockaddr_in()
          zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
          zeroAddress.sin_family = sa_family_t(AF_INET)
          
          let defaultRouteReachability = withUnsafePointer(to: &zeroAddress){
              $0.withMemoryRebound(to: sockaddr.self, capacity: 1){ zeroSockAddress in
                  SCNetworkReachabilityCreateWithAddress(nil,zeroSockAddress)
              }
          }
          var flags = SCNetworkReachabilityFlags()
          if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags){
              return false
          }
          let isReachable = flags.contains(.reachable)
          let needsConnection = flags.contains(.connectionRequired)
          return (isReachable && !needsConnection)
      }
    
}


// Cell viewmodel template
struct CellViewModel{
    let rowtitle: String
    let descript: String
    let imageHref: String
}

