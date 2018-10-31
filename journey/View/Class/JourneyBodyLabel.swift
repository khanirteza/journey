//
//  JourneyBodyLabel.swift
//  journey
//
//  Created by Mohammad Irteza Khan on 10/30/18.
//  Copyright © 2018 !serious. All rights reserved.
//

import UIKit

class JourneyBodyLabel: UILabel {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    func setup(){
        font = Utilities.getFont(.calibreRegular, size: 18.0)
        adjustsFontForContentSizeCategory = true
        textColor = UIColor.flatBlack
        numberOfLines = 0
        //sizeToFit()
    }
}
