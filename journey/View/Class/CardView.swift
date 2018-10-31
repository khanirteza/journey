//
//  CardView.swift
//  journey
//
//  Created by Mohammad Irteza Khan on 10/30/18.
//  Copyright © 2018 !serious. All rights reserved.
//

import UIKit


@IBDesignable
class CardView: UIView {
    
    let shadowOffsetWidth: Int = 0
    let shadowOffsetHeight: Int = 2
    let shadowColor: UIColor? = UIColor.flatWhiteDark
    let shadowOpacity: Float = 0.6
    
    override func layoutSubviews() {
        //        layer.cornerRadius = cornerRadius
        //        let shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)
        
        let shadowPath = UIBezierPath(rect: bounds)
        
        layer.masksToBounds = false
        layer.shadowColor = shadowColor?.cgColor
        layer.shadowOffset = CGSize(width: shadowOffsetWidth, height: shadowOffsetHeight);
        layer.shadowOpacity = shadowOpacity
        layer.shadowPath = shadowPath.cgPath
    }
    
}
