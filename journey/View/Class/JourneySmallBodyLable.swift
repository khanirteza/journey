//
//  JourneySmallBodyLable.swift
//  journey
//
//  Created by Mohammad Irteza Khan on 10/30/18.
//  Copyright © 2018 !serious. All rights reserved.
//

import UIKit

class JourneySmallBodyLabel: UILabel {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setup()
    }
    
    func setup(){
        font = Utilities.getFont(.calibreRegular, size: 14.0)
        adjustsFontForContentSizeCategory = true
        textColor = UIColor.flatWhiteDark
        numberOfLines = 0
        //sizeToFit()
    }
}
