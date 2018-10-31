//
//  TimelineRegularTableViewCell.swift
//  journey
//
//  Created by Mohammad Irteza Khan on 10/30/18.
//  Copyright © 2018 !serious. All rights reserved.
//

import UIKit

class TimelineRegularTableViewCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: JourneySmallBodyLabel!
    @IBOutlet weak var timeLabel: JourneyBodyLabel!
    @IBOutlet weak var transportModeImageView: UIImageView!
    @IBOutlet weak var topLineView: UIView!
    @IBOutlet weak var bottomLineView: UIView!
    
    
    // MARK: - View Lifecycle
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        subtitleLabel.text = nil
        
        topLineView.layer.sublayers = nil
        bottomLineView.layer.sublayers = nil
    }
}
