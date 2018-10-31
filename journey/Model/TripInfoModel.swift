//
//  TripInfoModel.swift
//  journey
//
//  Created by Mohammad Irteza Khan on 10/29/18.
//  Copyright © 2018 !serious. All rights reserved.
//

import Foundation
import SwiftyJSON

enum TransportMode: String{
    case Walk = "Walk"
    case Caltrain = "Caltrain"
    case Muni = "Muni"
    case VTA = "VTA"
    case BART = "Bay Area Rapid Transit"
    case Destination = "Destination"
    case Wait = "Wait"
}


struct TripInfoModel {
    var title: String
    var subtitle: String
    var depart: Int
    var arrive: Int
    var snackComparison: String
    var cost: Float
    var illustration: UIImage?
    var tripTimeline: [Int: TransportMode]
    var trip: JSON
}
