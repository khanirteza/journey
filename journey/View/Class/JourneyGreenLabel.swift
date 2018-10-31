//
//  JourneyGreenLabel.swift
//  journey
//
//  Created by Mohammad Irteza Khan on 10/30/18.
//  Copyright © 2018 !serious. All rights reserved.
//

import UIKit

class JourneyGreenLabel: UILabel {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        font = Utilities.getFont(.calibreRegular, size: 18.0)
        adjustsFontForContentSizeCategory = true
        textColor = UIColor.flatGreen
        numberOfLines = 0
    }
}
