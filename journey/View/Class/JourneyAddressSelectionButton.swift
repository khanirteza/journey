//
//  JourneyAddressSelectionButton.swift
//  journey
//
//  Created by Mohammad Irteza Khan on 10/30/18.
//  Copyright © 2018 !serious. All rights reserved.
//

import UIKit

class JourneyAddressSelectionButton: UIButton {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        layer.cornerRadius = 2
        //layer.masksToBounds = cornerRadius > 0
        layer.masksToBounds = true
        layer.borderWidth = 0
        //layer.borderColor = borderColor?.cgColor
        
        setTitleColor(titleColor(for: .normal)?.withAlphaComponent(0.5), for: .highlighted)
        backgroundColor = UIColor.flatGreenDark
        tintColor = UIColor.init(contrastingBlackOrWhiteColorOn: backgroundColor!, isFlat: true)
        
        titleLabel?.font = Utilities.getFont(.calibreRegular, size: 18.0)
        titleLabel?.adjustsFontForContentSizeCategory = true
        contentEdgeInsets = UIEdgeInsets.init(top: 8, left: 8, bottom: 8, right: 8)
    }
    
    /// Enable custom button and change the view's alpha
    func makeEnable(_ state: Bool){
        isEnabled = state
        if isEnabled {
            alpha = 1
        }
        else{
            alpha = 0.5
        }
        
        setNeedsDisplay()
    }
    
}
