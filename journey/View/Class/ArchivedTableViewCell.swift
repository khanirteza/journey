//
//  ArchivedTableViewCell.swift
//  journey
//
//  Created by Mohammad Irteza Khan on 10/30/18.
//  Copyright © 2018 !serious. All rights reserved.
//

import UIKit

class ArchivedTableViewCell: UITableViewCell {
    
    @IBOutlet weak var fileLabel: JourneyBodyLabel!
    @IBOutlet weak var uploadButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
