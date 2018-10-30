//
//  JourneyTitleLabel.swift
//  journey
//
//  Created by Mohammad Irteza Khan on 10/30/18.
//  Copyright © 2018 !serious. All rights reserved.
//

import UIKit

class JourneyTitleLabel: UILabel {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    func setup() {
        font = Utilities.getFont(.calibreBold, size: 18.0)
        adjustsFontForContentSizeCategory = true
        textColor = UIColor.flatBlack
        numberOfLines = 0
    }
    
}
