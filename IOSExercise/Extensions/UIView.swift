//
//  UIView.swift
//  IOSExercise
//
//  Created by Nimmi P on 06/10/20.
//  Copyright © 2020 Nimmi P. All rights reserved.
//

import UIKit

extension UIView{
    
    //scaling to ipad size if needed
    func getSize(input: CGFloat) -> CGFloat {
        if(self.traitCollection.horizontalSizeClass == .regular && self.traitCollection.verticalSizeClass == .regular){
            return (input*3/2)
        }
        else{
            return input
        }
    }
    
}
