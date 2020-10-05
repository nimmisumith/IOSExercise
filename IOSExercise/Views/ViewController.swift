//
//  ViewController.swift
//  IOSExercise
//
//  Created by Nimmi P on 27/09/20.
//  Copyright © 2020 Nimmi P. All rights reserved.
//

import UIKit
import SnapKit
import SDWebImage

class ViewController: UIViewController {
    
    var tableView = UITableView()
    
    lazy var viewModel: ListViewModel = {
        return ListViewModel()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //init views
        initView()
        
        //init viewmodel
        initVM()
        
    }
    
    func initView(){
        
        setupTableView()
        setupNavigationBarItems()
    }
    
    func initVM(){
        // init alert closure
        viewModel.showAlertClosure = { [weak self]() in
            DispatchQueue.main.async {
                if let self = self, let message = self.viewModel.alertMessage{
                    Utility.shared.showToast(message: message, view: self.view)
                }
            }
        }
        // init data loading closure. Showing activity indicator while loading, and tableview once loaded
        viewModel.updateLoadingStatus = { [weak self]() in
            
            DispatchQueue.main.async {
                let isLoading = self?.viewModel.isLoading ?? false
                if isLoading{
                    //show activity indicator
                    self?.showActivityIndicator()
                 //   //hide tableview
                    UIView.animate(withDuration: Constants.animate_duration, animations: {
                        self?.tableView.alpha = CGFloat(Constants.alpha_0)
                    })
                }
                else{
                    //hide activity indicator
                    self?.hideActivityIndicator()
                    //show tableview
                    UIView.animate(withDuration: Constants.animate_duration, animations: {
                        self?.tableView.alpha = CGFloat(Constants.alpha_1)
                        self?.tableView.reloadData()
                    })
                }
            }
        }
        // tableview reload closure, update ui
        viewModel.reloadTableViewClosure = { [weak self]() in
            
            DispatchQueue.main.async {
                self?.title = self?.viewModel.title ?? Constants.emptyString
                self?.tableView.reloadData()
            }
        }
        
        // start fetching data from url
        viewModel.initFetch()
    }
    
    //adding reload button in navigation bar
    func setupNavigationBarItems(){
      
            let reloadButton = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(ViewController.didTapReloadButton(sender:)))
             reloadButton.tintColor = UIColor.purple
                   self.navigationItem.rightBarButtonItem = reloadButton
    }
    
    
    
    //adding tableview
    func setupTableView(){
        
        tableView = UITableView()
        view.addSubview(tableView)
        tableView.snp.makeConstraints{
            $0.top.left.bottom.right.equalToSuperview()
        }
        tableView.register(RowCell.self, forCellReuseIdentifier: Constants.cell_identifier)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.estimatedRowHeight = UITableView.automaticDimension
        tableView.rowHeight = UITableView.automaticDimension
    }
    
    //reload button click action
    @objc func didTapReloadButton(sender: UIBarButtonItem){
        //reload data
         DispatchQueue.main.async {
            UIView.animate(withDuration: Constants.animate_duration, animations: {
                           self.tableView.alpha = CGFloat(Constants.alpha_0)
                       })
            self.showActivityIndicator()

        }
        viewModel.initFetch()
    }
}

//tableview delegate & datasource methods
extension ViewController: UITableViewDataSource,UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfCells
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cell_identifier, for: indexPath) as? RowCell else{
            fatalError("Cell does not exists")
        }
        let cellVM = viewModel.getCellViewModel(at : indexPath)
        cell.cellVM = cellVM
        
        return cell
    }
    
}
