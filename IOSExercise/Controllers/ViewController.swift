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
      //  self.navigationItem.title = self.serverdata.title
        setupTableView()
        addNavigationBar()
        setupActivityIndicator()
    }
    func initVM(){
        viewModel.showAlertClosure = { [weak self]() in
            DispatchQueue.main.async {
                if let self = self, let message = self.viewModel.alertMessage{
                    Utility.shared.showToast(message: message, view: self.view)
                }
            }
        }
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
        viewModel.reloadTableViewClosure = { [weak self]() in
            
            print("reload tableview closure")
            DispatchQueue.main.async {
                self?.title = self?.serverdata.title ?? ""
                self?.navBar.topItem?.title = self?.serverdata.title ?? ""
                self?.tableView.reloadData()
            }
        }
        
        viewModel.initFetch()
    }
    
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
    
    @objc func didTapReloadButton(sender: UIBarButtonItem){
           //reload data
           self.indicator.startAnimating()
           self.indicatorView.isHidden = false
           viewModel.initFetch()
         //  readDataFromApi()
    }
}

extension ViewController: UITableViewDataSource,UITableViewDelegate{

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        return viewModel.numberOfCells
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("table view indexpath: \(indexPath)")
        guard let cell = tableView.dequeueReusableCell(withIdentifier: RowCell.identifier, for: indexPath) as? RowCell else{
            fatalError("Cell does not exists")
        }
        let cellVM = viewModel.getCellViewModel(at : indexPath)
        cell.cellVM = cellVM
        
        return cell
    }

    
}


//class ViewController: UIViewController,LoadDataDelegate{
//
//    var navBar : UINavigationBar!
//    var indicator: UIActivityIndicatorView!
//    var tableView = UITableView()
//    var indicatorView = UIView()
//    var data = [RowModel]()
//
//    var serverdata: ServerData!
//    let api = ApiCalls()
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        serverdata = ServerData.sharedInstance
//        api.load_data_delegate = self
//        setupTableView()
//        addNavigationBar()
//        setupActivityIndicator()
//        readDataFromApi()
//    }
//
//    override func viewWillAppear(_ animated: Bool) {
//        if self.serverdata.jsonData.count > 0{
//
//            DispatchQueue.main.async{
//                self.tableView.reloadData()
//                self.title = self.serverdata.title ?? ""
//                self.navBar.topItem?.title = self.serverdata.title ?? ""
//            }
//        }
//    }
//
    
//
//    func readDataFromApi(){
//        if Utility.shared.isInternetAvailable(){
//            //call api
//            api.getJsonFromUrl()
//
//        }
//        else{
//            Utility.shared.showToast(message: Constants.InternetCheckMessage, view: self.view)
//        }
//    }
//    func setupActivityIndicator(){
//
//        indicator = Utility.shared.getActivityIndicator(view: indicatorView)
//        indicator.startAnimating()
//        view.addSubview(indicatorView)
//        view.bringSubviewToFront(indicatorView)
//        indicatorView.snp.makeConstraints{
//            $0.width.height.equalTo(40)
//            $0.centerX.centerY.equalToSuperview()
//        }
//
//    }
   
//
//    func dataLoaded(_ b: Bool) {
//
//        if(!b){
//            //if api fails, showing offline data from json file
//            api.readJsonFile(fileName: "file")
//            return
//        }
//        else{
//            //load data from shared object
//            data = self.serverdata.jsonData
//
//            DispatchQueue.main.async{
//                self.tableView.reloadData()
//                self.indicator.stopAnimating()
//                self.indicatorView.isHidden = true
//                self.title = self.serverdata.title ?? ""
//                self.navBar.topItem?.title = self.serverdata.title ?? ""
//            }
//        }
//    }
//}
//extension ViewController: UITableViewDataSource,UITableViewDelegate{
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//
//        return data.count
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let item : RowModel = data[indexPath.row]
//        let cell = tableView.dequeueReusableCell(withIdentifier: RowCell.identifier, for: indexPath) as! RowCell
//        cell.titleLabel?.text = item.rowtitle
//        cell.descriptionLabel?.numberOfLines = -1
//        cell.descriptionLabel?.sizeToFit()
//        cell.descriptionLabel?.text = item.descript
//        cell.rowImage?.backgroundColor = UIColor.gray
//        cell.rowImage?.sd_setImage(with: URL(string: item.imageHref),placeholderImage: nil,context: [.imageTransformer: getSDTransformer()])
//        return cell
//    }
//
//    //resizing image to a fixed size area
//    func getSDTransformer() -> SDImageResizingTransformer{
//        return SDImageResizingTransformer(size: CGSize(width: 300,height: 250),scaleMode: .aspectFit)
//    }
//}
//
