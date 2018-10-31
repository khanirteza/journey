//
//  JourneyHeadlineLabel.swift
//  journey
//
//  Created by Mohammad Irteza Khan on 10/30/18.
//  Copyright © 2018 !serious. All rights reserved.
//

import UIKit

class JourneyHeadlineLabel: UILabel {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        font = Utilities.getFont(.calibreBold, size: 38.0)
        adjustsFontForContentSizeCategory = true
        numberOfLines = 0
    }
    
}
