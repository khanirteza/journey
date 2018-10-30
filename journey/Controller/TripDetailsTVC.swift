//
//  TripDetailsTVC.swift
//  journey
//
//  Created by Mohammad Irteza Khan on 10/30/18.
//  Copyright © 2018 !serious. All rights reserved.
//

import UIKit
import SwiftyJSON
import MapKit
import Polyline

class AnnotationPoint: NSObject, MKAnnotation {
    let title: String?
    let subtitle: String?
    let coordinate: CLLocationCoordinate2D
    
    init(title: String, subtitle: String, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.subtitle = subtitle
        self.coordinate = coordinate
        
        super.init()
    }
}

class TripDetailsTVC: UITableViewController {
    
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var titleLabel: JourneyHeadlineLabel!
    @IBOutlet weak var subtitleLabel: JourneyBodyLabel!
    @IBOutlet weak var toWhereLabel: JourneyTitleLabel!
    @IBOutlet weak var destinationLabel: UILabel!
    @IBOutlet weak var sourceLabel: UILabel!
    @IBOutlet weak var timeframeLabel: JourneyPopupHeadLabel!
    @IBOutlet weak var timeSnacksLabel: JourneySmallBodyLabel!
    @IBOutlet weak var costLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var favoriteButton: UIButton!
    
    
    //var detailTripTimelineView: DetailTripTimelineView
    
    
    var heading: String?
    var subtitle: String?
    var toWhere: String?
    var sourceTitle: String?
    var destinationTitle: String?
    var destinationAddress: String?
    var sourceAddress: String?
    var timeFrame: String?
    var timeSnacks: String?
    var cost: String?
    //    var sourceLocation: CLLocationCoordinate2D?
    //    var destinationLocation: CLLocationCoordinate2D?
    
    var startLocation: CLLocationCoordinate2D?
    var destinationLocation: CLLocationCoordinate2D?
    
    var trip: JSON?
    var segmentTemplates: [Int: JSON]?
    var detailTripTimeline: [Int: JSON]?
    var tripTimeline: [Int: TransportMode]?
    var tripSegments: [Int: JSON]?
    var sortedKeys: [Int]?
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        //trip = try! JSON.init(data: MockData.mockTripJSON!)
        detailTripTimeline =  Utilities.getDetailTripTimelineFrom(trip: trip!, segmentTemplate: segmentTemplates!)
        sortedKeys = Array(detailTripTimeline!.keys).sorted(by: <)
        
        tripTimeline = Utilities.getTripTimelineFrom(trip: trip!, segmentTemplate: segmentTemplates!)
        tripSegments = Utilities.getTripSegmentsFrom(trip: trip!)
        
        guard let trip = trip else {return}
        
        headerView.autoresizingMask = []
        favoriteButton.tintColor = UIColor.flatGreen
        
        let totalTime = trip["arrive"].intValue - trip["depart"].intValue
        
        let timelineFrame = CGRect.init(x: 0, y: 0, width: view.frame.width, height: CGFloat(totalTime/3) + 200)
        
        //timelineView = DetailTripTimelineView.init(trip: trip, frame: timelineFrame)
        var startingPlace: (name: String, address: String)
        var destinationPlace: (name: String, address: String)
        
        
        
        //        if toWhere == "To work" {
        //            startingPlace = (name: "Home", address: sourceAddress!)
        //            destinationPlace = (name: "Work", address: destinationAddress!)
        //
        //            startLocation = homeLocation
        //            destinationLocation = workLocation
        //        }
        //        else {
        //            startingPlace = (name: "Work", address: sourceAddress!)
        //            destinationPlace = (name: "Home", address: destinationAddress!)
        //
        //            startLocation = workLocation
        //            destinationLocation = homeLocation
        //        }
        
        //        startLocation = startLocation
        //        destinationLocation =
        
        titleLabel.text = self.heading
        subtitleLabel.text = self.subtitle
        toWhereLabel.text = self.toWhere
        sourceLabel.text = self.sourceAddress
        destinationLabel.text = self.destinationAddress
        timeframeLabel.text = self.timeFrame
        costLabel.text = self.cost
        timeSnacksLabel.text = self.timeSnacks
        
        // Setting up the mapView delgate
        mapView.delegate = self
        
        // Drawing the trip waypoints on mapView
        
        let regionRadius: CLLocationDistance = 1000
        
        
        let coordinateRegion = MKCoordinateRegion(center: startLocation!, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)
        
        for segment in detailTripTimeline! {
            if segment.1["action"] == "<TIME>: Walk" {
                var coordinates: [CLLocationCoordinate2D]? = decodePolyline(segment.1["streets"].first!.1["encodedWaypoints"].stringValue)
                let polyline = MKPolyline.init(coordinates: &coordinates!, count: (coordinates?.count)!)
                //mapView.add(polyline)
                mapView.addOverlay(polyline, level: .aboveRoads)
            }
            else {
                for shape in segment.1["shapes"].arrayValue {
                    if shape["travelled"].bool! {
                        var coordinates: [CLLocationCoordinate2D]? = decodePolyline(shape["encodedWaypoints"].stringValue)
                        let polyline = MKPolyline.init(coordinates: &coordinates!, count: (coordinates?.count)!)
                        mapView.addOverlay(polyline)
                    }
                }
            }
        }
        
        
        // Showing the annotation on mapView
        for key in sortedKeys! {
            
            Log.debug(tripSegments![key])
            
            //            if key == sortedKeys?.first {
            //                //Log.debug(detailTripTimeline![key]!["from"])
            //                let coordinate = CLLocationCoordinate2D.init(latitude: detailTripTimeline![key]!["from"]["lat"].doubleValue, longitude: detailTripTimeline![key]!["from"]["lng"].doubleValue)
            //                let annotation = AnnotationPoint.init(title: sourceTitle!, subtitle: sourceAddress!, coordinate: coordinate)
            //                mapView.addAnnotation(annotation)
            //            }
            //
            //            else if key == sortedKeys?.last {
            //                let coordinate = CLLocationCoordinate2D.init(latitude: detailTripTimeline![key]!["to"]["lat"].doubleValue, longitude: detailTripTimeline![key]!["to"]["lng"].doubleValue)
            //                let annotation = AnnotationPoint.init(title: destinationTitle!, subtitle: destinationAddress!, coordinate: coordinate)
            //                mapView.addAnnotation(annotation)
            //            }
            //
            //            else {
            //Log.verbose(detailTripTimeline![key]!["from"])
            let coordinate = CLLocationCoordinate2D.init(latitude: detailTripTimeline![key]!["from"]["lat"].doubleValue, longitude: detailTripTimeline![key]!["from"]["lng"].doubleValue)
            let annotationTitle = detailTripTimeline![key]!["from"]["address"].stringValue
            let annotationSubtitle = "Take " + tripSegments![key]!["serviceNumber"].stringValue + " towards " + tripSegments![key]!["serviceDirection"].stringValue
            
            //                    Log.verbose(tripSegments![key]!["serviceNumber"].stringValue)
            //                    Log.debug(tripSegments![key]!["serviceDirection"].stringValue)
            //
            //
            //                    Log.debug(subtitle)
            //                    Log.debug(coordinate)
            
            let annotation = AnnotationPoint.init(title: annotationTitle, subtitle: annotationSubtitle, coordinate: coordinate)
            Log.debug(annotation.title)
            Log.debug(annotation.subtitle)
            Log.debug(annotation.coordinate)
            
            mapView.addAnnotation(annotation)
            //            }
        }
        
        
    }
    
    
    @IBAction func closeButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        //        if indexPath.row == 1 {
        //            return timelineView.frame.height
        //        }
        //        if indexPath.row == 0 {
        //            return 650
        //        }
        //        else {
        return 100
        //        }
        
        
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //        if section == 0 {
        //            return 1
        //        }
        //        else {
        return trip!["segments"].count + 1
        //        }
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "regularTimelineCell", for: indexPath) as! TimelineRegularTableViewCell
        
        cell.selectionStyle = .none
        
        
        //        if indexPath.section == 1 {
        if indexPath.row == 0 {
            //cell = tableView.dequeueReusableCell(withIdentifier: "regularTimelineCell", for: indexPath) as! TimelineRegularTableViewCell
            cell.titleLabel.text = "Journey starts from"
            
            //            cell.titleLabel.text = sourceTitle!
            
            cell.subtitleLabel.text = sourceAddress!
            cell.timeLabel.text = Utilities.getHumanDate(timestamp: Double(sortedKeys![indexPath.row]), withoutAM: true)
            cell.transportModeImageView.image = UIImage.init(named: "ic_journey_current-location")
            
            let bottomStartPoint = CGPoint.init(x: cell.bottomLineView.bounds.origin.x, y: cell.bottomLineView.bounds.origin.y)
            let bottomEndPoint = CGPoint.init(x: cell.bottomLineView.bounds.origin.x, y: cell.bottomLineView.bounds.maxY)
            
            if tripTimeline![sortedKeys![indexPath.row]]! == TransportMode.Walk {
                Utilities.drawLineFromPointToPoint(startPoint: bottomStartPoint, endPoint: bottomEndPoint, ofColor: UIColor.flatPurpleDark, widthOfLine: 2, inView: cell.bottomLineView, atLevel: 0, dashed: true)
            }
            else {
                Utilities.drawLineFromPointToPoint(startPoint: bottomStartPoint, endPoint: bottomEndPoint, ofColor: UIColor.flatPurpleDark, widthOfLine: 2, inView: cell.bottomLineView, atLevel: 0)
            }
            
        }
            
        else if indexPath.row == trip!["segments"].count {
            //cell = tableView.dequeueReusableCell(withIdentifier: "regularTimelineCell", for: indexPath) as! TimelineRegularTableViewCell
            cell.titleLabel.text = "Arrive at"
            
            //            cell.titleLabel.text = destinationTitle!
            
            cell.subtitleLabel.text = destinationAddress!
            cell.timeLabel.text = Utilities.getHumanDate(timestamp: Double(trip!["arrive"].intValue), withoutAM: true)
            cell.transportModeImageView.image = UIImage.init(named: "ic_journey_destination")
            
            let topStartPoint = CGPoint.init(x: cell.topLineView.bounds.origin.x, y: cell.topLineView.bounds.origin.y)
            let topEndPoint = CGPoint.init(x: cell.topLineView.bounds.origin.x, y: cell.topLineView.bounds.maxY)
            
            if tripTimeline![sortedKeys![indexPath.row - 1]]! == TransportMode.Walk {
                Utilities.drawLineFromPointToPoint(startPoint: topStartPoint, endPoint: topEndPoint, ofColor: UIColor.flatPurpleDark, widthOfLine: 2, inView: cell.topLineView, atLevel: 0, dashed: true)
            }
            else {
                Utilities.drawLineFromPointToPoint(startPoint: topStartPoint, endPoint: topEndPoint, ofColor: UIColor.flatPurpleDark, widthOfLine: 2, inView: cell.topLineView, atLevel: 0)
            }
            
        }
            
        else {
            //cell = tableView.dequeueReusableCell(withIdentifier: "regularTimelineCell", for: indexPath) as! TimelineRegularTableViewCell
            if detailTripTimeline![sortedKeys![indexPath.row]]!["action"].stringValue != "<TIME>: Wait " {
                if detailTripTimeline![sortedKeys![indexPath.row - 1]]!["action"].stringValue == "<TIME>: Wait " {
                    cell.titleLabel.text =  detailTripTimeline![sortedKeys![indexPath.row]]!["from"]["address"].stringValue
                }
                else {
                    cell.titleLabel.text =  detailTripTimeline![sortedKeys![indexPath.row - 1]]!["to"]["address"].stringValue
                }
                cell.titleLabel.sizeToFit()
            }
            else {
                cell.titleLabel.text = nil
                cell.titleLabel.sizeToFit()
            }
            
            cell.timeLabel.text = Utilities.getHumanDate(timestamp: Double(sortedKeys![indexPath.row]), withoutAM: true)
            
            if detailTripTimeline![sortedKeys![indexPath.row]]!["action"].stringValue == "<TIME>: Take <NUMBER>" {
                cell.subtitleLabel.text = "Take " + tripSegments![sortedKeys![indexPath.row]]!["serviceNumber"].stringValue + " towards " + tripSegments![sortedKeys![indexPath.row]]!["serviceDirection"].stringValue
            }
            else {
                let time = (tripSegments![sortedKeys![indexPath.row]]!["endTime"].intValue - tripSegments![sortedKeys![indexPath.row]]!["startTime"].intValue) / 60
                cell.subtitleLabel.text = String(time) + " min " + detailTripTimeline![sortedKeys![indexPath.row]]!["mini"]["instruction"].stringValue.lowercased()
                
                //                    cell.subtitleLabel.textColor = UIColor.init(named: "deepLilac")
            }
            
            cell.subtitleLabel.sizeToFit()
            
            //Log.verbose(detailTripTimeline![sortedKeys![indexPath.row]]!["action"].stringValue)
            //Log.verbose(detailTripTimeline![sortedKeys![indexPath.row]]!["mini"]["instruction"].stringValue)
            
            
            switch tripTimeline![sortedKeys![indexPath.row]]! {
            case .BART:
                cell.transportModeImageView.image = UIImage.init(named: "ic_journey_bart-logo")
                
            case .Caltrain:
                cell.transportModeImageView.image = UIImage.init(named: "ic_journey_caltrain-logo")
                
            case .Muni:
                cell.transportModeImageView.image = UIImage.init(named: "ic_journey_muni")
                
            case .VTA:
                cell.transportModeImageView.image = UIImage.init(named: "ic_journey_vta")
                
            case .Walk:
                cell.transportModeImageView.image = UIImage.init(named: "ic_journey_walk")
            case .Wait:
                cell.transportModeImageView.image = UIImage.init(named: "ic_journey_dot")
                //shouldDrawLine = false
                
            case .Destination:
                cell.transportModeImageView.image = UIImage.init(named: "ic_journey_destination")
            }
            
            let topStartPoint = CGPoint.init(x: cell.topLineView.bounds.origin.x, y: cell.topLineView.bounds.origin.y)
            let topEndPoint = CGPoint.init(x: cell.topLineView.bounds.origin.x, y: cell.topLineView.bounds.maxY)
            
            let bottomStartPoint = CGPoint.init(x: cell.bottomLineView.bounds.origin.x, y: cell.bottomLineView.bounds.origin.y)
            let bottomEndPoint = CGPoint.init(x: cell.bottomLineView.bounds.origin.x, y: cell.bottomLineView.bounds.maxY)
            
            if tripTimeline![sortedKeys![indexPath.row - 1]]! == TransportMode.Walk {
                Utilities.drawLineFromPointToPoint(startPoint: topStartPoint, endPoint: topEndPoint, ofColor: UIColor.flatPurpleDark, widthOfLine: 2, inView: cell.topLineView, atLevel: 0, dashed: true)
                //Log.verbose(tripTimeline![sortedKeys![indexPath.row - 1]])
            }
            else if tripTimeline![sortedKeys![indexPath.row - 1]]! != TransportMode.Wait{
                Utilities.drawLineFromPointToPoint(startPoint: topStartPoint, endPoint: topEndPoint, ofColor: UIColor.flatPurpleDark, widthOfLine: 2, inView: cell.topLineView, atLevel: 0)
                //Log.verbose(tripTimeline![sortedKeys![indexPath.row - 1]])
            }
            
            if tripTimeline![sortedKeys![indexPath.row]]! == TransportMode.Walk {
                Utilities.drawLineFromPointToPoint(startPoint: bottomStartPoint, endPoint: bottomEndPoint, ofColor: UIColor.flatPurpleDark, widthOfLine: 2, inView: cell.bottomLineView, atLevel: 0, dashed: true)
                //Log.verbose(tripTimeline![sortedKeys![indexPath.row]])
            }
            else if tripTimeline![sortedKeys![indexPath.row]]! != TransportMode.Wait{
                Utilities.drawLineFromPointToPoint(startPoint: bottomStartPoint, endPoint: bottomEndPoint, ofColor: UIColor.flatPurpleDark, widthOfLine: 2, inView: cell.bottomLineView, atLevel: 0)
                //Log.verbose(tripTimeline![sortedKeys![indexPath.row]])
            }
            //}
            
            
            return cell
        }
        //        }
        
        return UITableViewCell.init()
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let regionRadius: CLLocationDistance = 200
        
        if indexPath.row < trip!["segments"].count {
            var coordinate: CLLocationCoordinate2D?
            if detailTripTimeline![sortedKeys![indexPath.row]]!["action"].stringValue == "<TIME>: Wait " {
                coordinate = CLLocationCoordinate2D.init(latitude: detailTripTimeline![sortedKeys![indexPath.row]]!["location"]["lat"].doubleValue, longitude: detailTripTimeline![sortedKeys![indexPath.row]]!["location"]["lng"].doubleValue)
            }
            else {
                coordinate = CLLocationCoordinate2D.init(latitude: detailTripTimeline![sortedKeys![indexPath.row]]!["from"]["lat"].doubleValue, longitude: detailTripTimeline![sortedKeys![indexPath.row]]!["from"]["lng"].doubleValue)
            }
            
            let coordinateRegion = MKCoordinateRegion(center: coordinate!, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
            mapView.setRegion(coordinateRegion, animated: true)
            
            tableView.scrollRectToVisible(CGRect.init(x: 0, y: 0, width: 1, height: 1), animated: true)
        }
        else if indexPath.row == trip!["segments"].count {
            let coordinateRegion = MKCoordinateRegion(center: destinationLocation!, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
            mapView.setRegion(coordinateRegion, animated: true)
            
            tableView.scrollRectToVisible(CGRect.init(x: 0, y: 0, width: 1, height: 1), animated: true)
            //tableView.reloadRows(at: [indexPath], with: .automatic)
        }
    }
}


extension TripDetailsTVC: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        //renderer.fillColor = UIColor.black.withAlphaComponent(0.5)
        renderer.strokeColor = UIColor.flatGreen
        renderer.lineWidth = 3
        return renderer
    }
    
    
    
}
