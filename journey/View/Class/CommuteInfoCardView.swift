//
//  CommuteInfoCardView.swift
//  journey
//
//  Created by Mohammad Irteza Khan on 10/30/18.
//  Copyright © 2018 !serious. All rights reserved.
//

import UIKit

class CommuteInfoCardView: UIView {
    
    @IBOutlet var cardView: UIView!
    @IBOutlet weak var illustrationIconImageView: UIImageView!
    @IBOutlet weak var detailButton: UIButton!
    @IBOutlet weak var titleLabel: JourneyPopupHeadLabel!
    @IBOutlet weak var subtitleLabel: JourneyBodyLabel!
    @IBOutlet weak var commuteTimeLabel: JourneyTitleLabel!
    @IBOutlet weak var leaveAtLabel: JourneyBodyLabel!
    @IBOutlet weak var arriveByLabel: JourneyBodyLabel!
    @IBOutlet weak var snackComparisonLabel: JourneySmallBodyLabel!
    @IBOutlet weak var costLabel: UILabel!
    @IBOutlet weak var showDetailButton: UIButton!
    @IBOutlet weak var favoriteButton: UIButton!
    
    
    
    //    override init(frame: CGRect) {
    //        super.init(frame: frame)
    //        //commonInit()
    //    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //commonInit()
    }
    
    
    init(cardInfo: TripInfoModel, frame: CGRect){
        super.init(frame: frame)
        
        Bundle.main.loadNibNamed("CommuteInfoCardView", owner: self, options: nil)
        addSubview(cardView)
        cardView.frame = self.bounds
        cardView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        illustrationIconImageView.layer.cornerRadius = illustrationIconImageView.frame.size.width / 2
        illustrationIconImageView.clipsToBounds = true
        illustrationIconImageView.layer.borderWidth = 5.0
        illustrationIconImageView.layer.borderColor = UIColor.flatWhite.cgColor
        
        detailButton.layer.cornerRadius = detailButton.frame.size.width / 2
        detailButton.clipsToBounds = true
        detailButton.backgroundColor = UIColor.flatGreen
        //
        //        // Changing the provided time stamp to date format
        //        let departTime = Date.init(timeIntervalSince1970: Double(cardInfo.depart))
        //        let arriveTime = Date.init(timeIntervalSince1970: Double(cardInfo.arrive))
        //        let dateFormatter = DateFormatter()
        //        dateFormatter.dateFormat = "h:mm a"
        //        let departTimeString = dateFormatter.string(from: departTime)
        //        let arriveTimeString = dateFormatter.string(from: arriveTime)
        
        //let arriveDate = Date.init(timeIntervalSince1970: Double(cardInfo.depart))
        let commuteTime = Utilities.secondsToHourMin(seconds: cardInfo.arrive - cardInfo.depart)
        //        let commuteHour = Int(commuteTime / 3600)
        //        commuteTime %= 3600
        //        let commuteMin = Int(commuteTime / 60)
        
        // Setting the card's info using provided data
        titleLabel.text = cardInfo.title
        subtitleLabel.text = cardInfo.subtitle
        commuteTimeLabel.text = "\(commuteTime.hour) h \(commuteTime.minute) min"
        leaveAtLabel.text = "Leave at \(Utilities.getHumanDate(timestamp: Double(cardInfo.depart)))"
        arriveByLabel.text = "Arrive by \(Utilities.getHumanDate(timestamp: Double(cardInfo.arrive)))"
        snackComparisonLabel.text = cardInfo.snackComparison
        costLabel.text = "$" + String(format: "%.2f", cardInfo.cost)
        
        favoriteButton.tintColor = UIColor.flatGreen
        
        
        if let illustrationIcon = cardInfo.illustration {
            illustrationIconImageView.image = illustrationIcon
        }
        
        
        let startPoint = CGPoint.init(x: self.bounds.origin.x + 36.0, y: self.bounds.origin.y + 285.0)
        let endPoint = CGPoint.init(x: self.bounds.width - 36.0, y: self.bounds.origin.y + 285.0)
        
        Utilities.drawLineFromPointToPoint(startPoint: startPoint, endPoint: endPoint, ofColor: UIColor.flatPurpleDark, widthOfLine: 3.0, inView: self, atLevel: 10)
        
        let offsetDistance = (self.bounds.width - 62.0) - (self.bounds.origin.x + 22.0)
        
        //var modeIcon = [Int: UIImageView]()
        
        let startintPointLogo = UIImageView.init(image: UIImage.init(named: "ic_journey_walk"))
        let endingPointLogo = UIImageView.init(image: UIImage.init(named: "ic_journey_walk"))
        
        startintPointLogo.frame = CGRect.init(x: self.bounds.origin.x + 22.0, y: self.bounds.origin.y + 265.0, width: 40.0, height: 40.0)
        endingPointLogo.frame = CGRect.init(x: self.bounds.width - 62.0, y: self.bounds.origin.y + 265.0, width: 40.0, height: 40.0)
        
        addSubview(startintPointLogo)
        addSubview(endingPointLogo)
        
        for stop in cardInfo.tripTimeline {
            let displacement = CGFloat.init(Float(stop.key - cardInfo.depart) / Float(cardInfo.arrive - cardInfo.depart))
            let transportModeLogo = UIImageView.init(frame: CGRect.init(x: self.bounds.origin.x + 22.0 + (displacement * offsetDistance), y: self.bounds.origin.y + 265.0, width: 40.0, height: 40.0))
            
            switch stop.value {
            case .BART:
                transportModeLogo.image = UIImage.init(named: "ic_journey_bart-logo")
                
            case .Caltrain:
                transportModeLogo.image = UIImage.init(named: "ic_journey_caltrain-logo")
                
            case .Muni:
                transportModeLogo.image = UIImage.init(named: "ic_journey_muni")
                
            case .VTA:
                transportModeLogo.image = UIImage.init(named: "ic_journey_vta")
                
            case .Walk, .Wait:
                //transportModeLogo.image = UIImage.init(named: "ic_journey_walk")
                //return
                continue
                
            case .Destination:
                transportModeLogo.image = UIImage.init(named: "ic_journey_destination")
            }
            
            
            addSubview(transportModeLogo)
            
            if stop.key == cardInfo.depart {
                continue
            }
            let transferTimeLabel = JourneyBodyLabel.init(frame: CGRect.init(x: transportModeLogo.frame.origin.x - 10.0, y: transportModeLogo.frame.origin.y + transportModeLogo.frame.width + 8.0, width: 60.0, height: 20.0))
            transferTimeLabel.text = Utilities.getHumanDate(timestamp: Double(stop.key))
            transferTimeLabel.textAlignment = .center
            
            addSubview(transferTimeLabel)
        }
        
    }
    
}
