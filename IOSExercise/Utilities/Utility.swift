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

class Utility : NSObject{
    
    static let shared: Utility = Utility()
    
    
    
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
    
    func showToast(message: String, view: UIView){
        let x = getSize(input: 20, view: view)
        let y = getSize(input: 200, view: view)
        let width = getSize(input: 40, view: view)
        let height = getSize(input: 35, view: view)
        let toastLabel = UILabel(frame: CGRect(x: x, y: view.frame.size.height-y, width: view.frame.size.width-width, height: height))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = .center
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10
        toastLabel.clipsToBounds = true
        view.addSubview(toastLabel)
        UIView.animate(withDuration: 4.0, delay: 0.1, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: { _ in
            toastLabel.removeFromSuperview()
        })
        
    }
    
    func getSize(input: CGFloat, view : UIView) -> CGFloat {
        if(view.traitCollection.horizontalSizeClass == .regular && view.traitCollection.verticalSizeClass == .regular){
            return (input*3/2)
        }
        else{
            return input
        }
    }
    
    func getActivityIndicator(view: UIView) -> UIActivityIndicatorView{
        
        let indicator: UIActivityIndicatorView = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.medium)
        indicator.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        indicator.center = view.center
        view.addSubview(indicator)
        view.bringSubviewToFront(indicator)
        return indicator
    }
}
