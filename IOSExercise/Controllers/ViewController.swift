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
    
    var navBar : UINavigationBar!
    var indicator: UIActivityIndicatorView!
    var tableView = UITableView()
    var indicatorView = UIView()
    var serverdata: ServerData!
    
    lazy var viewModel: ListViewModel = {
        return ListViewModel()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        serverdata = ServerData.sharedInstance
        
        //init views
        initView()
        
        //init viewmodel
        initVM()
        
    }
    
    func initView(){
        setupTableView()
        addNavigationBar()
        setupActivityIndicator()
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
                    self?.indicator.startAnimating()
                    self?.indicatorView.isHidden = false
                    //hide tableview
                    UIView.animate(withDuration: 0.2, animations: {
                        self?.tableView.alpha = 0.0
                    })
                }
                else{
                    //hide activity indicator
                    self?.indicator.stopAnimating()
                    self?.indicatorView.isHidden = true
                    //show tableview
                    UIView.animate(withDuration: 0.2, animations: {
                        self?.tableView.alpha = 1.0
                        self?.tableView.reloadData()
                    })
                }
            }
        }
        // tableview reload closure, update ui
        viewModel.reloadTableViewClosure = { [weak self]() in
            
            DispatchQueue.main.async {
                self?.title = self?.serverdata.title ?? ""
                self?.navBar.topItem?.title = self?.serverdata.title ?? ""
                self?.tableView.reloadData()
            }
        }
        
        // start fetching data from url
        viewModel.initFetch()
    }
    
    //adding navigation bar and reload button
    func addNavigationBar(){
        navBar = UINavigationBar(frame: CGRect(x: 0, y:0, width:view.frame.size.width, height: 44))
        view.addSubview(navBar)
        view.bringSubviewToFront(navBar)
        navBar.tintColor = UIColor.darkGray
        
        let navItem = UINavigationItem(title: "")
        let reloadButton = UIBarButtonItem(barButtonSystemItem: .refresh, target: nil, action: #selector(ViewController.didTapReloadButton(sender:)))
        navItem.rightBarButtonItem = reloadButton
        navBar.setItems([navItem],animated: false)
        navigationItem.rightBarButtonItem = reloadButton
        
        navBar.snp.makeConstraints{
            $0.top.equalToSuperview().offset(22)
            $0.left.right.equalToSuperview()
            $0.height.equalTo(44)
        }
        
    }
    
    //adding activity indicator
    func setupActivityIndicator(){
        
        indicator = Utility.shared.getActivityIndicator(view: indicatorView)
        indicator.startAnimating()
        view.addSubview(indicatorView)
        view.bringSubviewToFront(indicatorView)
        indicatorView.snp.makeConstraints{
            $0.width.height.equalTo(40)
            $0.centerX.centerY.equalToSuperview()
        }
        
    }
    
    //adding tableview
    func setupTableView(){
        
        tableView = UITableView(frame: .zero)
        view.addSubview(tableView)
        tableView.snp.makeConstraints{
            $0.top.equalToSuperview().offset(60)
            $0.left.equalToSuperview()
            $0.right.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        tableView.register(RowCell.self, forCellReuseIdentifier: RowCell.identifier)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.estimatedRowHeight = UITableView.automaticDimension
        tableView.rowHeight = UITableView.automaticDimension
    }
    
    //reload button click action
    @objc func didTapReloadButton(sender: UIBarButtonItem){
        //reload data
        self.indicator.startAnimating()
        self.indicatorView.isHidden = false
        viewModel.initFetch()
    }
}

//tableview delegate & datasource methods
extension ViewController: UITableViewDataSource,UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfCells
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: RowCell.identifier, for: indexPath) as? RowCell else{
            fatalError("Cell does not exists")
        }
        let cellVM = viewModel.getCellViewModel(at : indexPath)
        cell.cellVM = cellVM
        
        return cell
    }
    
    
}
