//
//  UIViewController.swift
//  IOSExercise
//
//  Created by Nimmi P on 05/10/20.
//  Copyright © 2020 Nimmi P. All rights reserved.
//

import UIKit

extension UIViewController{
    
  //  static let activityIndicator : UIActivityIndicatorView = UIActivityIndicatorView()
    
    func showActivityIndicator(){
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.tag = 100
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = .gray
        DispatchQueue.main.async {
            self.view.addSubview(activityIndicator)
            activityIndicator.startAnimating()
        }
    //    UIApplication.shared.beginIgnoringInteractionEvents()
        
    }
    
    func hideActivityIndicator(){
        if let activityIndicator = view.viewWithTag(100) as? UIActivityIndicatorView{
        DispatchQueue.main.async {
            activityIndicator.stopAnimating()
            activityIndicator.removeFromSuperview()
        }
      //  UIApplication.shared.endIgnoringInteractionEvents()
        }
    }
    
}
