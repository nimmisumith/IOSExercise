//
//  Utility.swift
//  IosExerciseA
//
//  Created by Nimmi P on 24/09/20.
//  Copyright © 2020 Nimmi P. All rights reserved.
//

import Foundation
import SystemConfiguration //network checking
import UIKit //UIView creation
import SnapKit

class Utility : NSObject{
    
    static let shared: Utility = Utility()
    
    
    //Check for internet
    func isInternetAvailable() -> Bool{
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress){
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1){ zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil,zeroSockAddress)
            }
        }
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags){
            return false
        }
        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        return (isReachable && !needsConnection)
    }
    
    //showing toast message
    func showToast(message: String, view: UIView){
        let x = getSize(input: Constants.toast_x, view: view)
        let y = getSize(input: Constants.toast_y, view: view)
        let width = getSize(input: Constants.toast_w, view: view)
        let height = getSize(input: Constants.toast_h, view: view)
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
    
    //scaling to ipad size if needed
    func getSize(input: CGFloat, view : UIView) -> CGFloat {
        if(view.traitCollection.horizontalSizeClass == .regular && view.traitCollection.verticalSizeClass == .regular){
            return (input*3/2)
        }
        else{
            return input
        }
    }
    
    //creating an activity indicator view
    func getActivityIndicator(view: UIView) -> UIActivityIndicatorView{
        
        let indicator: UIActivityIndicatorView = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.gray)
        indicator.frame = CGRect(x: Constants.zero, y: Constants.zero, width: Constants.indicator_size, height: Constants.indicator_size)
        indicator.center = view.center
        view.addSubview(indicator)
        indicator.snp.makeConstraints{
            $0.width.height.equalTo(Constants.indicator_size)
            $0.centerX.centerY.equalToSuperview()
        }
        view.bringSubviewToFront(indicator)
        return indicator
    }
}
