//
//  JourneyTextField.swift
//  journey
//
//  Created by Mohammad Irteza Khan on 10/30/18.
//  Copyright © 2018 !serious. All rights reserved.
//

import UIKit

class JourneyTextField: UITextField {
    
    var padding = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        tintColor = UIColor.flatGreen
        borderStyle = .none
        layer.cornerRadius = 2
        layer.borderWidth = 0
        layer.masksToBounds = true
        layer.borderColor = UIColor.white.cgColor
        
        font = Utilities.getFont(.calibreRegular, size: 18.0)
        adjustsFontForContentSizeCategory = true
        
        let clearButton = UIButton()
        clearButton.setImage(UIImage.init(named: "ic_clear"), for: .normal)
        clearButton.frame = CGRect.init(x: 0, y: 0, width: 32, height: 32)
        clearButton.addTarget(self, action: #selector(clearTextField), for: .touchUpInside)
        
        rightView = clearButton
        clearButtonMode = .never
        
    }
    @objc func clearTextField(){
        text?.removeAll()
        becomeFirstResponder()
    }
    
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
}
