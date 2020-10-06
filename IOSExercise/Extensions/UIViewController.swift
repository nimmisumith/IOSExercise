//
//  UIViewController.swift
//  IOSExercise
//
//  Created by Nimmi P on 05/10/20.
//  Copyright © 2020 Nimmi P. All rights reserved.
//

import UIKit
import SystemConfiguration //network checking

extension UIViewController{
    
    //To show an activity indicator view
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
        
    }
    //Hide activity indicator
    func hideActivityIndicator(){
        if let activityIndicator = view.viewWithTag(100) as? UIActivityIndicatorView{
        DispatchQueue.main.async {
            activityIndicator.stopAnimating()
            activityIndicator.removeFromSuperview()
        }
        }
    }
    
    
    //showing toast message
    func showToast(message: String){
        let x = view.getSize(input: Constants.toast_x)
        let y = view.getSize(input: Constants.toast_y)
        let width = view.getSize(input: Constants.toast_w)
        let height = view.getSize(input: Constants.toast_h)
        let toastLabel = UILabel(frame: CGRect(x: x, y: view.frame.size.height-y, width: view.frame.size.width-width, height: height))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(Constants.toast_alpha)
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = .center
        toastLabel.text = message
        toastLabel.alpha = Constants.alpha_1
        toastLabel.layer.cornerRadius = Constants.toast_radius
        toastLabel.clipsToBounds = true
        view.addSubview(toastLabel)
        UIView.animate(withDuration: Constants.toast_duration, delay: Constants.toast_delay, options: .curveEaseOut, animations: {
            toastLabel.alpha = Constants.alpha_0
        }, completion: { _ in
            toastLabel.removeFromSuperview()
        })

    }
    
}
