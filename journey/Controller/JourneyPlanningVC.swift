//
//  JourneyPlanningVC.swift
//  journey
//
//  Created by Mohammad Irteza Khan on 10/30/18.
//  Copyright © 2018 !serious. All rights reserved.
//

import UIKit
import CoreLocation
import SwiftyJSON
import SwiftDate


class JourneyPlanningVC: UIViewController {
    
    enum TripState: UInt {
        case starting
        case started
        case paused
        case resumed
        case ended
    }
    
    
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var fromButton: UIButton!
    @IBOutlet weak var toButton: UIButton!
    @IBOutlet weak var selectTimeButton: UIButton!
    @IBOutlet weak var routeButton: UIButton!
    @IBOutlet weak var commuteCardTableView: UITableView!
    @IBOutlet weak var tableEmptyView: UIView!
    
    //    var mobilityManager: MobilityManager?
    //    var previousState = TripState.ended
    //    var currentTripState = "Trip state: "
    //
    //    var batteryLevel: Float {
    //        return UIDevice.current.batteryLevel
    //    }
    //
    //    var reachability = Reachability()!
    
    
    var fromAddress: AddressSelectionVC.ResultAddress? {
        didSet {
            self.getRoute()
        }
    }
    
    var toAddress: AddressSelectionVC.ResultAddress? {
        didSet {
            self.getRoute()
        }
    }
    var time: Date?
    var timeType: APIManager.TimeType = .leaveNow
    
    let locationManager = CLLocationManager()
    
    var trips: [JSON]?
    var segmentTemplates: [Int: JSON]?
    var filteredTrips = [Utilities.TripCriteria: TripInfoModel]()
    
    var defaultFromText = "Where are you starting from?"
    var defaultToText = "Where do you want to go?"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        headerView.backgroundColor = UIColor.flatGreen
        selectTimeButton.contentEdgeInsets = UIEdgeInsets.init(top: 4, left: 8, bottom: 4, right: 8)
        selectTimeButton.tintColor = UIColor.white
        selectTimeButton.setTitle("Leave now", for: .normal)
        
        fromButton.setTitle(defaultFromText, for: .normal)
        toButton.setTitle(defaultToText, for: .normal)
        
        commuteCardTableView.backgroundColor = UIColor.flatWhite
        tableEmptyView.backgroundColor = UIColor.flatWhite
        
        //        locationManager.requestAlwaysAuthorization()
        
        //        if CLLocationManager.locationServicesEnabled() {
        //            locationManager.delegate = self
        //            locationManager.desiredAccuracy = kCLLocationAccuracyBest
        //            locationManager.startUpdatingLocation()
        //        }
        
        //        if Utilities.isLoggedIn() {
        //            let userDetails = Utilities.retrieveUserDetails()
        //            var home, work: AddressSelectionVC.ResultAddress?
        //
        //            guard let pointsOfInterest = userDetails?.pointsOfInterest else {return}
        //
        //            for poi in pointsOfInterest {
        //                switch poi.name {
        //                case "home1":
        //                    home = AddressSelectionVC.ResultAddress.init(address: poi.address, location: CLLocationCoordinate2D.init(latitude: poi.location.latitude, longitude: poi.location.longitude))
        //
        //                case "work":
        //                    work = AddressSelectionVC.ResultAddress.init(address: poi.address, location: CLLocationCoordinate2D.init(latitude: poi.location.latitude, longitude: poi.location.longitude))
        //
        //                default:
        //                    break;
        //                }
        //            }
        //
        //            guard let homeAddress = home, let workAddress = work else { return }
        //
        //            if Date().hour >= 5 && Date().hour <= 12 {
        //                if let fromAddress = fromAddress {
        //                    let fromLocation = CLLocation.init(latitude: fromAddress.location.latitude, longitude: fromAddress.location.longitude)
        //                    let workLocation = CLLocation.init(latitude: workAddress.location.latitude, longitude: workAddress.location.longitude)
        //                    if fromLocation.distance(from: workLocation) > 1000 {
        //                        toAddress = workAddress
        //                        toButton.setTitle(toAddress?.address, for: .normal)
        //                    }
        //                }
        //
        //            }
        //            else if Date().hour >= 15 && Date().hour <= 20 {
        //                toAddress = homeAddress
        //                toButton.setTitle(toAddress?.address, for: .normal)
        //            }
        //        }
        
        routeButton.backgroundColor = UIColor.flatRedDark
        routeButton.tintColor = UIColor.init(contrastingBlackOrWhiteColorOn: routeButton.backgroundColor!, isFlat: true)
        routeButton.contentEdgeInsets = UIEdgeInsets.init(top: 4, left: 4, bottom: 4, right: 4)
        
        commuteCardTableView.delegate = self
        commuteCardTableView.dataSource = self
        
        UIDevice.current.isBatteryMonitoringEnabled = true
        
        
        //        startLogging()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
    }
    
    @IBAction func tappedOnSwapAddress(_ sender: UIButton) {
        swap(&fromAddress, &toAddress)
        var fromButtonTitle = fromButton.titleLabel?.text
        var toButtonTitle = toButton.titleLabel?.text
        
        swap(&fromButtonTitle, &toButtonTitle)
        
        if fromButtonTitle == defaultToText {
            fromButton.setTitle(defaultFromText, for: .normal)
        }
        else {
            fromButton.setTitle(fromButtonTitle, for: .normal)
        }
        
        if toButtonTitle == defaultFromText {
            toButton.setTitle(defaultToText, for: .normal)
        }
        else {
            toButton.setTitle(toButtonTitle, for: .normal)
        }
        
        //        getRoute()
    }
    
    @IBAction func showAddressSelectionVC(_ sender: JourneyAddressSelectionButton) {
        let addressSelectionVC = UIStoryboard.init(name: "Misc", bundle: nil).instantiateViewController(withIdentifier: "AddressSelectionVC") as! AddressSelectionVC
        
        present(addressSelectionVC, animated: true, completion: nil)
        
        addressSelectionVC.didSelectAddress = { selectedAddress in
            if sender == self.fromButton {
                self.fromAddress = selectedAddress
                sender.setTitle(self.fromAddress?.address, for: .normal)
            }
            else if sender == self.toButton {
                self.toAddress = selectedAddress
                sender.setTitle(self.toAddress?.address, for: .normal)
            }
            
            //            self.getRoute()
        }
    }
    
    @IBAction func tappedOnSelectTime(_ sender: UIButton) {
        let timeSelectionVC = UIStoryboard.init(name: "Misc", bundle: nil).instantiateViewController(withIdentifier: "TimeSelectionVC") as! TimeSelectionVC
        
        //        show(timeSelectionVC, sender: self)
        present(timeSelectionVC, animated: true, completion: nil)
        
        timeSelectionVC.didSelectTime = { selectedTime, timeType in
            self.time = selectedTime
            self.timeType = timeType
            Log.debug(self.time)
            Log.debug(self.timeType)
            
            let dateFormatter = DateFormatter()
            
            //dateFormatter.dateFormat = "MM-dd-yyyy hh:mm a"
            dateFormatter.dateStyle = .medium
            dateFormatter.timeStyle = .short
            dateFormatter.doesRelativeDateFormatting = true
            let dateInFormat = dateFormatter.string(from: self.time!)
            
            switch self.timeType {
            case .leaveNow:
                self.selectTimeButton.setTitle("Leave now", for: .normal)
                
            case .departAfter:
                self.selectTimeButton.setTitle("Leave at: \(dateInFormat)", for: .normal)
                
            case .arriveBefore:
                self.selectTimeButton.setTitle("Arrive by: \(dateInFormat)", for: .normal)
            }
            
            self.getRoute()
        }
    }
    
    @IBAction func tappedOnRoute(_ sender: UIButton) {
        
        getRoute()
    }
    
    
    @objc func showTripDetails(sender: UIButton){
        let tripDetailsTVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TripDetailsTVC") as! TripDetailsTVC
        
        //        Log.verbose(sender.tag)
        
        if let tripInfo = filteredTrips[Utilities.TripCriteria(rawValue: sender.tag)!] {
            
            tripDetailsTVC.trip = tripInfo.trip
            tripDetailsTVC.segmentTemplates = segmentTemplates
            
            //tripDetailsTVC.tripTimeline = tripInfo.tripTimeline
            tripDetailsTVC.heading = tripInfo.title
            tripDetailsTVC.subtitle = tripInfo.subtitle
            
            
            // change the destination based on current selection. if user choice is "Leave from: than place will be different. Else it will be same as placeSelectionButton title
            if timeType == .leaveNow || timeType == .departAfter {
                tripDetailsTVC.destinationAddress = toAddress?.address
                tripDetailsTVC.sourceAddress = fromAddress?.address
                
                tripDetailsTVC.destinationLocation = toAddress?.location
                tripDetailsTVC.startLocation = fromAddress?.location
            }
            else {
                tripDetailsTVC.destinationAddress = fromAddress?.address
                tripDetailsTVC.sourceAddress = toAddress?.address
                
                tripDetailsTVC.destinationLocation = fromAddress?.location
                tripDetailsTVC.startLocation = toAddress?.location
            }
            
            
            
            tripDetailsTVC.timeFrame = "\(Utilities.getHumanDate(timestamp: Double(tripInfo.depart))) - \(Utilities.getHumanDate(timestamp: Double(tripInfo.arrive)))"
            tripDetailsTVC.cost = "$" + String(format: "%.2f", tripInfo.cost)
            let commuteTime = Utilities.secondsToHourMin(seconds: tripInfo.arrive - tripInfo.depart)
            
            tripDetailsTVC.timeSnacks = "\(commuteTime.hour) h \(commuteTime.minute) min ・ \(tripInfo.snackComparison)"
            
            self.present(tripDetailsTVC, animated: true, completion: nil)
        }
    }
    
    
    func getRoute(){
        guard let fromAddress = fromAddress, let toAddress = toAddress else {return}
        
        //        // this block whill check if the distance between fromAddress and toAddress is less than 1000 meteres. It will query route only if distance is greater than 1000 meter
        //        let fromLocation = CLLocation.init(latitude: fromAddress.location.latitude, longitude: fromAddress.location.longitude)
        //        let toLocation = CLLocation.init(latitude: toAddress.location.latitude, longitude: toAddress.location.longitude)
        //
        //        if fromLocation.distance(from: toLocation) < 1000 {
        //            return
        //        }
        
        if timeType == .leaveNow {
            let currentTimeStamp = Int(Date().timeIntervalSince1970)
            APIManager.getTripData(from: fromAddress.location, to: toAddress.location, timeChoice: .departAfter, time: currentTimeStamp, boundaryChoice: .arriveBefore, boundaryTime: currentTimeStamp + 7200) { statusCode, trips, templateSegments in
                if statusCode != 200 {
                    Log.error("can't get trip data")
                }
                else {
                    //Log.debug(trips)
                    self.trips = trips!
                    self.segmentTemplates = templateSegments!
                    
                    if self.trips!.count > 0 {
                        DispatchQueue.main.async { [unowned self] in
                            self.tableEmptyView.isHidden = true
                            self.commuteCardTableView.reloadData()
                            self.commuteCardTableView.beginUpdates()
                            self.commuteCardTableView.endUpdates()
                        }
                    }
                }
                
            }
        }
        else {
            let timeStamp = Int((time?.timeIntervalSince1970)!)
            var boundaryTime = timeStamp
            var timeChoice: APIManager.TimeType
            var boundaryChoice: APIManager.TimeType
            
            if timeType == .departAfter {
                boundaryTime += 7200
                timeChoice = .departAfter
                boundaryChoice = .arriveBefore
            }
            else {
                boundaryTime -= 7200
                timeChoice = .arriveBefore
                boundaryChoice = .departAfter
            }
            APIManager.getTripData(from: fromAddress.location, to: toAddress.location, timeChoice: timeChoice, time: timeStamp, boundaryChoice: boundaryChoice, boundaryTime: boundaryTime) { statusCode, trips, templateSegments in
                if statusCode != 200 {
                    Log.error("can't get trip data")
                }
                else {
                    Log.debug(trips)
                    self.trips = trips!
                    self.segmentTemplates = templateSegments!
                    DispatchQueue.main.async { [unowned self] in
                        self.commuteCardTableView.reloadData()
                        self.commuteCardTableView.beginUpdates()
                        self.commuteCardTableView.endUpdates()
                    }
                }
            }
        }
    }
    
    
    
    //    /// Start logging the location service
    //    func startLogging(){
    //        if !Utilities.isLoggedIn() {
    //            return
    //        }
    //
    //        let userDetails = Utilities.retrieveUserDetails()
    //        // this will make sure that only one Log file is in the active_log directory. If there is any Log file remained from previous session due to app crashing it will archived the file first before creating new file
    //        Utilities.stopLoggingFor((userDetails?.id)!)
    //
    //        mobilityManager = MobilityManager.sharedManager() as? MobilityManager
    //        var error: NSError?
    //
    //        switch CLLocationManager.authorizationStatus() {
    //        case .authorizedAlways, .authorizedWhenInUse:
    //            Log.debug("Location authorized")
    //
    //            mobilityManager?.subscribe(toMeasurement: iOSLocation.self, withDelegate: self, error: &error)
    //
    //            mobilityManager?.createTripDetector(self)
    //            mobilityManager?.startFileRecording(withDirectory: "\((userDetails?.id)!)/active_log", andFileName: nil)
    //            mobilityManager?.startLocation(withMinDisplacement: -1.0, headingUpdates: -1.0, andTripDetection: true, withBackgroundUpdates: true)
    //
    //        case .notDetermined:
    //            locationManager.requestAlwaysAuthorization()
    //
    //        default:
    //            Log.debug("Location not authorized")
    //            Utilities.stopLoggingFor((userDetails?.id)!)
    //        }
    //
    //    }
    
}


extension JourneyPlanningVC: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locationManager.stopUpdatingLocation()
        guard let currentLocation = locations.last?.coordinate else {return}
        fromAddress = AddressSelectionVC.ResultAddress.init(address: "Current location", location: currentLocation)
        
        //DispatchQueue.main.async {
        self.fromButton.setTitle(self.fromAddress?.address, for: .normal)
        //}
        Log.debug(fromAddress)
        
        if Utilities.isLoggedIn() {
            var home, work: AddressSelectionVC.ResultAddress?
            
            
            
            guard let fromAddress = fromAddress else { return }
            guard let homeAddress = home, let workAddress = work else { return }
            
            let fromLocation = CLLocation.init(latitude: fromAddress.location.latitude, longitude: fromAddress.location.longitude)
            
            if Date().hour >= 5 && Date().hour <= 11 {
                let workLocation = CLLocation.init(latitude: workAddress.location.latitude, longitude: workAddress.location.longitude)
                if fromLocation.distance(from: workLocation) > 1000 {
                    toAddress = workAddress
                    toButton.setTitle(toAddress?.address, for: .normal)
                }
                
            }
            else if Date().hour >= 15 && Date().hour <= 20 {
                let homeLocation = CLLocation.init(latitude: homeAddress.location.latitude, longitude: homeAddress.location.longitude)
                if fromLocation.distance(from: homeLocation) > 1000 {
                    toAddress = homeAddress
                    toButton.setTitle(toAddress?.address, for: .normal)
                }
            }
        }
        
    }
    
    
}

extension JourneyPlanningVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let trips = trips {
            if trips.count > 0 {
                return 4
            }
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = commuteCardTableView.dequeueReusableCell(withIdentifier: "cellID", for: indexPath) as? CommuteCardTableViewCell else {
            fatalError("Error dequeuing commute card cell")
        }
        
        switch indexPath.row {
        case 0:
            if let trips = trips, let segmentTemplates = segmentTemplates {
                let trip = Utilities.getDesiredTripFor(criteria: .fastest, from: trips)
                let tripTimeline = Utilities.getTripTimelineFrom(trip: trip!, segmentTemplate: segmentTemplates)
                //Log.debug(tripTimeline)
                let cardInfo = TripInfoModel.init(title: "Get there fast", subtitle: "This is predicted to be the  most reliable and efficient commute for you.", depart: trip!["depart"].intValue, arrive: trip!["arrive"].intValue, snackComparison: "8 Reeses", cost: trip!["moneyCost"].floatValue, illustration: UIImage.init(named: "Journey-fast")!, tripTimeline: tripTimeline, trip: trip!)
                
                let commuteInfoCardView = CommuteInfoCardView.init(cardInfo: cardInfo, frame: CGRect.init(x: cell.contentView.bounds.origin.x + 8, y: cell.contentView.bounds.origin.y, width: cell.contentView.bounds.width - 16, height: 460))
                
                filteredTrips[.fastest] = cardInfo
                commuteInfoCardView.detailButton.tag = Utilities.TripCriteria.fastest.rawValue
                commuteInfoCardView.detailButton.addTarget(nil, action: #selector(showTripDetails(sender:)), for: .touchDown)
                
                cell.contentView.addSubview(commuteInfoCardView)
            }
            return cell
            
        case 1:
            if let trips = trips, let segmentTemplates = segmentTemplates {
                let trip = Utilities.getDesiredTripFor(criteria: .mostCalories, from: trips)
                let tripTimeline = Utilities.getTripTimelineFrom(trip: trip!, segmentTemplate: segmentTemplates)
                //Log.debug(tripTimeline)
                let cardInfo = TripInfoModel.init(title: "Burn calories", subtitle: "Adding extra time for walking will help you feel most relaxed as you arrive to work.", depart: trip!["depart"].intValue, arrive: trip!["arrive"].intValue, snackComparison: "8 Reeses", cost: trip!["moneyCost"].floatValue, illustration: UIImage.init(named: "Journey-health")!, tripTimeline: tripTimeline, trip: trip!)
                
                let commuteInfoCardView = CommuteInfoCardView.init(cardInfo: cardInfo, frame: CGRect.init(x: cell.contentView.bounds.origin.x + 8, y: cell.contentView.bounds.origin.y, width: cell.contentView.bounds.width - 16, height: 460))
                
                filteredTrips[.mostCalories] = cardInfo
                commuteInfoCardView.detailButton.tag = Utilities.TripCriteria.mostCalories.rawValue
                commuteInfoCardView.detailButton.addTarget(nil, action: #selector(showTripDetails(sender:)), for: .touchDown)
                
                cell.contentView.addSubview(commuteInfoCardView)
            }
            return cell
            
        case 2:
            if let trips = trips, let segmentTemplates = segmentTemplates {
                let trip = Utilities.getDesiredTripFor(criteria: .cheapest, from: trips)
                let tripTimeline = Utilities.getTripTimelineFrom(trip: trip!, segmentTemplate: segmentTemplates)
                //Log.debug(tripTimeline)
                let cardInfo = TripInfoModel.init(title: "Cheapest trip", subtitle: "Taking this commute saves your hard earned money.", depart: trip!["depart"].intValue, arrive: trip!["arrive"].intValue, snackComparison: "8 Reeses", cost: trip!["moneyCost"].floatValue, illustration: UIImage.init(named: "Journey-cheap")!, tripTimeline: tripTimeline, trip: trip!)
                
                let commuteInfoCardView = CommuteInfoCardView.init(cardInfo: cardInfo, frame: CGRect.init(x: cell.contentView.bounds.origin.x + 8, y: cell.contentView.bounds.origin.y, width: cell.contentView.bounds.width - 16, height: 460))
                
                filteredTrips[.cheapest] = cardInfo
                commuteInfoCardView.detailButton.tag = Utilities.TripCriteria.cheapest.rawValue
                commuteInfoCardView.detailButton.addTarget(nil, action: #selector(showTripDetails(sender:)), for: .touchDown)
                
                cell.contentView.addSubview(commuteInfoCardView)
            }
            
            return cell
            
        case 3:
            if let trips = trips, let segmentTemplates = segmentTemplates {
                let trip = Utilities.getDesiredTripFor(criteria: .ecoTrip, from: trips)
                let tripTimeline = Utilities.getTripTimelineFrom(trip: trip!, segmentTemplate: segmentTemplates)
                //Log.debug(tripTimeline)
                let cardInfo = TripInfoModel.init(title: "Eco trip", subtitle: "This trip is the most ecological trip to work.", depart: trip!["depart"].intValue, arrive: trip!["arrive"].intValue, snackComparison: "8 Reeses", cost: trip!["moneyCost"].floatValue, illustration: UIImage.init(named: "Journey-sustainable")!, tripTimeline: tripTimeline, trip: trip!)
                
                let commuteInfoCardView = CommuteInfoCardView.init(cardInfo: cardInfo, frame: CGRect.init(x: cell.contentView.bounds.origin.x + 8, y: cell.contentView.bounds.origin.y, width: cell.contentView.bounds.width - 16, height: 460))
                
                filteredTrips[.ecoTrip] = cardInfo
                commuteInfoCardView.detailButton.tag = Utilities.TripCriteria.ecoTrip.rawValue
                commuteInfoCardView.detailButton.addTarget(nil, action: #selector(showTripDetails(sender:)), for: .touchDown)
                
                cell.contentView.addSubview(commuteInfoCardView)
            }
            
            return cell
            
        default:
            return UITableViewCell.init()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 475
    }
    
}

extension JourneyPlanningVC: UITableViewDelegate {
    
}
