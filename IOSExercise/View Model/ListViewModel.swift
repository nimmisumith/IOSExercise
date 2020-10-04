//
//  ListViewModel.swift
//  IOSExercise
//
//  Created by Nimmi P on 01/10/20.
//  Copyright © 2020 Nimmi P. All rights reserved.
//

import Foundation

class ListViewModel{
    
    /*  A view model class that handle UI based on fetched data from api **/
    
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
    
    // fetch data from api if network connection available. If error / no internet connection, showing an alert message accordingly
    func initFetch(){
        if Utility.shared.isInternetAvailable(){
            self.isLoading = true
            apiService.getJsonFromUrl{ [weak self] (success, rows, error) in
                self?.isLoading = false
                if let error = error {
                    self?.alertMessage = error.localizedDescription
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
    
    // Returns cell viewmodel for each row in tableview.
    func getCellViewModel(at indexPath: IndexPath) -> CellViewModel {
        return cellViews[indexPath.row]
    }
    
    //Creating cell viewmodel with values
    func createCellViewModel(row: RowModel) -> CellViewModel{
        return CellViewModel(rowtitle: row.rowtitle ?? "", descript: row.descript ?? "", imageHref: row.imageHref ?? "")
    }
    
    // Setup cell viewmodel for each row, if a value exists for a row
    private func setupFetchedData(rows: [RowModel]){
       
        self.rows = rows //cache data
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
    
}


// A cell model template
struct CellViewModel{
    let rowtitle: String
    let descript: String
    let imageHref: String
}
