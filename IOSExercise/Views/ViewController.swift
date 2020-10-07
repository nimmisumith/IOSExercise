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
    
    //Tableview to display data
    private var tableView = UITableView()
    
    //ViewModel that connects UI components with presentation logic
    private lazy var viewModel: ListViewModel = {
        return ListViewModel()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //init views
        initView()
        
        //init viewmodel
        initVM()
        
    }
    
    private func initView(){
        
        setupTableView()
        setupNavigationBarItems()
    }
    
    private func initVM(){
        // init alert closure
        viewModel.showAlertClosure = { [weak self]() in
            DispatchQueue.main.async {
                if let self = self, let message = self.viewModel.alertMessage{
                    self.showToast(message: message)
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
        
        // Start fetching data from url here..
        viewModel.initFetch()
    }
    
    //Setting reload button in navigation bar
    private func setupNavigationBarItems(){
        
        let reloadButton = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(ViewController.didTapReloadButton(sender:)))
        reloadButton.tintColor = UIColor.purple
        self.navigationItem.rightBarButtonItem = reloadButton
    }
    
    //adding tableview
    private func setupTableView(){
        
        tableView = UITableView(frame: .zero)
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
    @objc private func didTapReloadButton(sender: UIBarButtonItem){
        //Hide tableview & show activity indicator
        DispatchQueue.main.async {
            UIView.animate(withDuration: Constants.animate_duration, animations: {
                self.tableView.alpha = CGFloat(Constants.alpha_0)
            })
            self.showActivityIndicator()
            
        }
        //reload data
        viewModel.initFetch()
    }
}

//tableview datasource
extension ViewController: UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfCells
    }
    
}
//tableview delegate
extension ViewController:UITableViewDelegate{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cell_identifier, for: indexPath) as? RowCell else{
            fatalError("Cell does not exists")
        }
        // Setting data from ViewModel
        let cellVM = viewModel.getCellViewModel(at : indexPath)
        cell.cellVM = cellVM
        cell.layoutIfNeeded() //To update layout immediately
        return cell
    }
}
