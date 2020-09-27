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
    var data = [RowModel]()
    
    var serverdata: ServerData!
    let api = ApiCalls()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        serverdata = ServerData.sharedInstance
        api.load_data_delegate = self
        
        addNavigationBar()
        setupTableView()
        setupActivityIndicator()
        readDataFromApi()
    }

    func addNavigationBar(){
        navBar = UINavigationBar(frame: CGRect(x: 0, y:0, width:view.frame.size.width, height: 44))
        view.addSubview(navBar)
       // let safeInsets: UIEdgeInsets = UIApplication.shared.delegate?.window.safeAreaInsets
      //  paddingTop = safeInsets.top
        navBar.tintColor = UIColor.darkGray
       // navBar.isTranslucent = false
       // navBar.barTintColor = UIColor.white
        
        
        
        
        let navItem = UINavigationItem(title: "Title Here")
        let reloadButton = UIBarButtonItem(barButtonSystemItem: .refresh, target: nil, action: #selector(ViewController.didTapReloadButton(sender:)))
        navItem.rightBarButtonItem = reloadButton
        navBar.setItems([navItem],animated: false)
        
      //  let reloadButton = UIBarButtonItem(image: UIImage(systemName:"circle") , style: UIBarButtonItem.Style.plain, target: self, action: #selector(ViewController.didTapReloadButton(sender:)))
        navigationItem.rightBarButtonItem = reloadButton
        
        navBar.snp.makeConstraints{
            $0.top.equalToSuperview().offset(22)
            $0.leading.equalToSuperview()
        }
        
    }
    func setupTableView(){
       
        tableView = UITableView(frame: .zero)
               view.addSubview(tableView)
               tableView.snp.makeConstraints{
                $0.top.equalTo(navBar.snp.bottom)
                $0.width.equalToSuperview()
                $0.centerY.equalToSuperview()
                $0.bottom.equalToSuperview()
               }
               tableView.register(RowCell.self, forCellReuseIdentifier: RowCell.identifier)
               tableView.dataSource = self
               tableView.delegate = self
               tableView.estimatedRowHeight = 100
               tableView.rowHeight = UITableView.automaticDimension
        tableView.backgroundColor = UIColor.lightGray
    }
    
    func readDataFromApi(){
        if Utility.shared.isInternetAvailable(){
            indicator.startAnimating()
           
           // api.getJsonFromUrl()
            api.readJsonFile(fileName: "file")
        }
        else{
            Utility.shared.showToast(message: Constants.InternetCheckMessage, view: self.view)
        }
    }
    func setupActivityIndicator(){
        indicator = Utility.shared.getActivityIndicator(view: self.view)
    }
    @objc func didTapReloadButton(sender: UIBarButtonItem){
        //reload data
    }
    
    func dataLoaded(_: Bool) {
          
        data = self.serverdata.jsonData
        DispatchQueue.main.async{
            self.tableView.reloadData()
            self.indicator.stopAnimating()
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
        cell.descriptionLabel?.text = item.descript
        cell.rowImage?.backgroundColor = UIColor.gray
        cell.rowImage?.sd_setImage(with: URL(string: item.imageHref))
      //  cell.rowImage?.sd_setImage(with: URL(string: item.imageHref),placeholderImage: nil,context: [.imageTransformer: getSDTransformer()])
        return cell
    }
    
    func getSDTransformer() -> SDImageResizingTransformer{
        return SDImageResizingTransformer(size: CGSize(width: 300,height: 250),scaleMode: .aspectFit)
    }
}

