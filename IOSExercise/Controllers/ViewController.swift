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

class ViewController: UIViewController,LoadDataDelegate{

    var navBar : UINavigationBar!
    var indicator: UIActivityIndicatorView!
    var tableView = UITableView()
    var indicatorView = UIView()
    var data = [RowModel]()
    
    var serverdata: ServerData!
    let api = ApiCalls()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        serverdata = ServerData.sharedInstance
        api.load_data_delegate = self
        setupTableView()
        addNavigationBar()
        setupActivityIndicator()
        readDataFromApi()
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
    func setupTableView(){
       
        tableView = UITableView(frame: .zero)
               view.addSubview(tableView)
               tableView.snp.makeConstraints{
                $0.top.equalToSuperview().offset(60)
                $0.width.equalToSuperview()
                $0.centerY.equalToSuperview()
                $0.bottom.equalToSuperview()
               }
               tableView.register(RowCell.self, forCellReuseIdentifier: RowCell.identifier)
               tableView.dataSource = self
               tableView.delegate = self
               tableView.estimatedRowHeight = 100
               tableView.rowHeight = UITableView.automaticDimension
    }
    
    func readDataFromApi(){
        if Utility.shared.isInternetAvailable(){
            //call api
            api.getJsonFromUrl()
           
        }
        else{
            Utility.shared.showToast(message: Constants.InternetCheckMessage, view: self.view)
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
    @objc func didTapReloadButton(sender: UIBarButtonItem){
        //reload data
        readDataFromApi()
    }
    
    func dataLoaded(_ b: Bool) {
          
        if(!b){
            //if api fails, showing offline data from json file
             api.readJsonFile(fileName: "file")
             return
        }
        else{
            //load data from shared object
            data = self.serverdata.jsonData
            
            DispatchQueue.main.async{
                self.tableView.reloadData()
                self.indicator.stopAnimating()
                self.indicatorView.isHidden = true
                self.title = self.serverdata.title ?? ""
                self.navBar.topItem?.title = self.serverdata.title ?? ""
            }
        }
    }
}
extension ViewController: UITableViewDataSource,UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item : RowModel = data[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: RowCell.identifier, for: indexPath) as! RowCell
        cell.titleLabel?.text = item.rowtitle
        cell.descriptionLabel?.numberOfLines = -1
        cell.descriptionLabel?.sizeToFit()
        cell.descriptionLabel?.text = item.descript
        cell.rowImage?.backgroundColor = UIColor.gray
        cell.rowImage?.sd_setImage(with: URL(string: item.imageHref),placeholderImage: nil,context: [.imageTransformer: getSDTransformer()])
        return cell
    }
    
    //resizing image to a fixed size area
    func getSDTransformer() -> SDImageResizingTransformer{
        return SDImageResizingTransformer(size: CGSize(width: 300,height: 250),scaleMode: .aspectFit)
    }
}

