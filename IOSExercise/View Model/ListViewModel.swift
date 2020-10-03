//
//  ListViewModel.swift
//  IOSExercise
//
//  Created by Nimmi P on 01/10/20.
//  Copyright © 2020 Nimmi P. All rights reserved.
//

import Foundation

class ListViewModel{
    
    let apiService: APIServiceProtocol
    
    private var rows:[RowModel] = [RowModel]()
    
    private var cellViews: [CellViewModel] = [CellViewModel](){
        didSet {
            self.reloadTableViewClosure?()
        }
    }
    
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
    
    var numberOfCells: Int{
        return cellViews.count
    }
    
    var reloadTableViewClosure: (() -> ())?
    var showAlertClosure: (() -> ())?
    var updateLoadingStatus: (() -> ())?
    
    init(apiService: APIServiceProtocol = ApiCalls()) {
        self.apiService = apiService
    }
    
    func initFetch(){
        if Utility.shared.isInternetAvailable(){
                    //call api
                    self.isLoading = true
                           apiService.getJsonFromUrl{ [weak self] (success, rows, error) in
                               self?.isLoading = false
                               if let error = error {
                                self?.alertMessage = error.localizedDescription
                                print("error initFetch vm : \(error.localizedDescription)")
                               }
                               else{
                                   
                                   self?.setupFetchedData(rows: rows)
                               }
                               
                           }
        
                }
                else{
                    self.alertMessage = Constants.InternetCheckMessage
                }
    }
    
    func getCellViewModel(at indexPath: IndexPath) -> CellViewModel {
        return cellViews[indexPath.row]
    }
    
    func createCellViewModel(row: RowModel) -> CellViewModel{
        
        
        return CellViewModel(rowtitle: row.rowtitle ?? "", descript: row.descript ?? "", imageHref: row.imageHref ?? "")
    }
    
    private func setupFetchedData(rows: [RowModel]){
        print(rows.count)
        self.rows = rows //cache data
        var cellvm = [CellViewModel]()
        for row in rows{
            print("row in vm \(row.rowtitle)")
            //Skip creating a row if all values are empty
            if row.rowtitle == nil && row.descript == nil && row.imageHref == nil {
                continue
            }
            cellvm.append(createCellViewModel(row: row))
        }
        self.cellViews = cellvm
        print("set data")
    }
    
}



struct CellViewModel{
    let rowtitle: String
    let descript: String
    let imageHref: String
}
