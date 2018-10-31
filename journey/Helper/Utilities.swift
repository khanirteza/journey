//
//  Utilities.swift
//  journey
//
//  Created by Mohammad Irteza Khan on 10/29/18.
//  Copyright © 2018 !serious. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import KeychainAccess
import Polyline

/// This class provides utility functions and enums for used in the project. All the functions are static so there is no need to declare an object for this class.

class Utilities{
    //MARK: Enums
    enum Keys: String {
        case HereMapAppID
        case HereMapAppCode
        case HockeyID
        case MixpanelToken
        case IntercomAPIKey
        case IntercomAppID
        case TripGoKey
        case SegmentWriteKey
    }
    
    enum Fonts: String {
        case calibreRegular = "CalibreTest-Regular"
        case calibreBold = "CalibreTest-Bold"
        case calibreLight = "CalibreTest-Light"
        case calibreSemiBold = "CalibreTest-SemiBold"
    }
    
    enum TripCriteria: Int {
        case fastest
        case productive
        case mostCalories
        case together
        case social
        case mostWalking
        case cheapest
        case quiet
        case ecoTrip
        case convenient
        case alone
    }
    
    enum RegionId: String {
        case homeRegion
        case workRegion
    }
    
    // MARK: Functions
    
    /// Validate email string
    ///
    /// - Parameter email: A String that represent an email address.
    /// - Returns: Boolean value indicating whether an email is valid or not.
    static func isValid(email: String?) -> Bool {
        let emailRegEx = "(?:[a-z0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[a-z0-9!#$%\\&'*+/=?\\^_`{|}"+"~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\"+"x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[a-z0-9](?:[a-"+"z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\\[(?:(?:25[0-5"+"]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-"+"9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21"+"-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])"
        
        let emailTest = NSPredicate(format:"SELF MATCHES[c] %@", emailRegEx)
        return emailTest.evaluate(with: email)
    }
    
    
    /// Retrieve key from the plist file.
    ///
    /// - Parameter named: Name of the the key to be retrived.
    /// - Returns: Key in string format, return nil if key not found
    static func retrieveKeyFor(_ named: Keys) -> String? {
        guard let path = Bundle.main.path(forResource: "Keys", ofType: "plist") else {
            fatalError("Keys plist not found")
        }
        let data = FileManager.default.contents(atPath: path)
        var format = PropertyListSerialization.PropertyListFormat.xml
        do{
            let keys = try PropertyListSerialization.propertyList(from: data!, options: [], format: &format) as! [String:String]
            return keys[named.rawValue]
        } catch let error{
            print(error)
        }
        
        return nil
    }
    
    
    /// Return the specified font
    ///
    /// - Parameters:
    ///   - name: name of the font. Be sure to add a enum Fonts: String at the top of the file
    ///   - size: desired font size
    /// - Returns: return the desired font in specified size
    static func getFont(_ name: Fonts, size: CGFloat) -> UIFont {
        guard let font = UIFont(name: name.rawValue, size: size) else {
            fatalError("Failed to load the font named \(name.rawValue)")
        }
        
        if #available(iOS 11.0, *) {
            return UIFontMetrics.default.scaledFont(for: font)
        } else {
            return font
        }
    }
    
    
    /// Check if input contains alphabet and space only. Having space in front and end of string also fails.
    ///
    /// - Parameter input: input string
    /// - Returns: returns true if input contains only alphabet else return false
    static func isAlphaSpace(_ input: String) -> Bool{
        return !input.isEmpty && input.range(of: "^[a-zA-Z]+(?: [a-zA-Z]+)*$", options: .regularExpression) != nil
    }
    
    
    /// Check if input contains number and space only. Having space in fornt and end fo string also fails.
    ///
    /// - Parameter input: input number
    /// - Returns: return true if input contains only number and space, else return false
    static func isNumSpace(_ input: String) -> Bool{
        return !input.isEmpty && input.range(of: "^[0-9]+(?: [0-9]+)*$", options: .regularExpression) != nil
    }
    
    
    /// Split address in two lines by putting the street address in first line and rest in the second line.
    ///
    /// - Parameter address: Full address in string format
    /// - Returns: returns the splitted address
    static func splitAddress(_ address: String) -> String {
        // spliting the address in two lines
        let components = address.components(separatedBy: ",")
        let firstComponent = components.first
        var lastComponents = Array(components.dropFirst())
        lastComponents[0].removeFirst()
        
        let resultAddress = firstComponent! + "\n" + lastComponents.joined(separator: ",")
        
        return resultAddress
    }
    
    
    /// Draw a line with specified properties
    ///
    /// - Parameters:
    ///   - startPoint: starting point of the line
    ///   - endPoint: ending point of the line
    ///   - lineColor: color of the line
    ///   - lineWidth: width of the line
    ///   - view: the view that will contain the line
    ///   - atLevel: level of the draw layer. 0 will draw at bottom layer; a higher number will draw at top layer
    static func drawLineFromPointToPoint(startPoint: CGPoint, endPoint: CGPoint, ofColor lineColor: UIColor, widthOfLine lineWidth: CGFloat, inView view: UIView, atLevel: UInt32, dashed: Bool? = nil) {
        
        let path = UIBezierPath()
        path.move(to: startPoint)
        path.addLine(to: endPoint)
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.strokeColor = lineColor.cgColor
        shapeLayer.lineWidth = lineWidth
        shapeLayer.lineCap = CAShapeLayerLineCap.round
        
        if dashed == true{
            shapeLayer.lineDashPattern = [2, 6]
        }
        
        
        
        //view.layer.addSublayer(shapeLayer)
        view.layer.insertSublayer(shapeLayer, at: atLevel)
    }
    
    
    /// Get the next available unix time. If the specified time already passed it will return the next available time at next day.
    ///
    /// - Parameters:
    ///   - targetHour: desired hour
    ///   - targetMinute: desired minute
    /// - Returns: returns the avalable time in unix epoch
    static func getNextAvailableTimeFor(targetHour: Int, targetMinute: Int) -> Double? {
        return Calendar.current.nextDate(after: Date(), matching: DateComponents(hour: targetHour, minute: targetMinute), matchingPolicy: .nextTime)?.timeIntervalSince1970
    }
    
    /// Convert a unix timestamp in human date format
    ///
    /// - Parameters:
    ///   - timestamp: timestamp: unix timestamp
    ///   - withoutAM: if provided 'true' time format will be in h:mm format. Default value is false
    /// - Returns: return string date in "h:mm a" format
    static func getHumanDate(timestamp: Double, withoutAM: Bool = false) -> String {
        let date = Date.init(timeIntervalSince1970: timestamp)
        let dateFormatter = DateFormatter()
        if withoutAM {
            dateFormatter.dateFormat = "h:mm"
        }
        else {
            dateFormatter.dateFormat = "h:mm a"
        }
        
        return dateFormatter.string(from: date).lowercased()
    }
    
    
    static func getDesiredTripFor(criteria: TripCriteria, from trips: [JSON]?) -> JSON? {
        guard let trips = trips else {
            return nil
        }
        
        switch criteria {
        case .fastest:
            var totalTimes = [Int: Int]()
            
            for i in 0..<trips.count {
                totalTimes[trips[i]["arrive"].intValue - trips[i]["depart"].intValue] = i
                //totalTimes.append(trip["arrive"].int! - trip["depart"].int!)
            }
            
            let sortedTimes = totalTimes.sorted(by: <)
            
            return trips[(sortedTimes.first?.value)!]
            
        case .cheapest:
            var priceCost = [Float: Int]()
            
            for i in 0..<trips.count {
                priceCost[trips[i]["moneyCost"].floatValue] = i
            }
            
            let sortedPrice = priceCost.sorted(by: <)
            
            return trips[(sortedPrice.first?.value)!]
            
        case .ecoTrip:
            var carbonCost = [Double: Int]()
            
            for i in 0..<trips.count {
                carbonCost[trips[i]["carbonCost"].doubleValue] = i
            }
            
            let sortedCarbonCost = carbonCost.sorted(by: <)
            //Log.debug(sortedCarbonCost)
            
            return trips[(sortedCarbonCost.first?.value)!]
            
        case .mostCalories:
            var calories = [Float: Int]()
            
            for i in 0..<trips.count {
                calories[trips[i]["caloriesCost"].floatValue] = i
            }
            
            let sortedCalories = calories.sorted(by: >)
            //Log.debug(sortedCalories)
            
            return trips[(sortedCalories.first?.value)!]
            
        default:
            break
        }
        
        return nil
    }
    
    
    /// Create a timeline of trip
    ///
    /// - Parameters:
    ///   - trip: detail of the trip returned from TripGo API
    ///   - segmentTemplate: segmentTemplate returned from the TripGo API
    /// - Returns: returnes trip timeline in [Int: TransportMode] format, where key will be the unix time
    static func getTripTimelineFrom(trip: JSON, segmentTemplate: [Int: JSON]) -> [Int: TransportMode] {
        var tripTimeline = [Int: TransportMode]()
        
        for segment in trip["segments"] {
            //Log.debug(segmentTemplate[segment.1["segmentTemplateHashCode"].intValue])
            if segmentTemplate[segment.1["segmentTemplateHashCode"].intValue]!["modeIdentifier"].stringValue == "wa_wal" {
                tripTimeline[segment.1["startTime"].intValue] = TransportMode.Walk
            }
            else if segmentTemplate[segment.1["segmentTemplateHashCode"].intValue]!["action"].stringValue == "<TIME>: Wait " {
                tripTimeline[segment.1["startTime"].intValue] = TransportMode.Wait
            }
            else {
                tripTimeline[segment.1["startTime"].intValue] = TransportMode(rawValue: segmentTemplate[segment.1["segmentTemplateHashCode"].intValue]!["serviceOperator"].stringValue)
            }
        }
        
        return tripTimeline
    }
    
    
    static func getDetailTripTimelineFrom(trip: JSON, segmentTemplate: [Int: JSON]) -> [Int: JSON] {
        var tripTimeline =  [Int: JSON]()
        
        for segment in trip["segments"] {
            tripTimeline[segment.1["startTime"].intValue] = segmentTemplate[segment.1["segmentTemplateHashCode"].intValue]
        }
        
        //var returnValue = tripTimeline.sorted{$0.key < $1.key}
        return tripTimeline
    }
    
    static func getTripSegmentsFrom(trip: JSON) -> [Int: JSON] {
        var segments = [Int: JSON]()
        
        for segment in trip["segments"] {
            segments[segment.1["startTime"].intValue] = segment.1
        }
        
        return segments
    }
    
    
    /// Convert passed seconds to hour and minute format
    ///
    /// - Parameter seconds: amount of seconds to convert
    /// - Returns: tuple in (hour, min) format
    static func secondsToHourMin(seconds: Int) -> (hour: Int, minute: Int) {
        var tempSeconds = seconds
        let hour = Int(tempSeconds / 3600)
        tempSeconds %= 3600
        let min = Int(tempSeconds / 60)
        
        return (hour: hour, minute: min)
    }
    
    
    static func getRandomGreetings() -> (greeting: String, language: String) {
        guard let path = Bundle.main.path(forResource: "greetings", ofType: "json")
            else {
                Log.error("greetings.json file not found")
                return ("Hello", "English")
        }
        
        let data = FileManager.default.contents(atPath: path)
        
        do {
            let jsonGreetings = try JSON.init(data: data!)
            let randomIndex = arc4random_uniform(UInt32(jsonGreetings["greetings"].count))
            
            let greeting = jsonGreetings["greetings"].arrayValue[Int(randomIndex)]
            
            //            Log.debug(type(of:greeting["greeting"].stringValue))
            
            return (greeting["greeting"].stringValue, greeting["language"].stringValue)
        } catch let error {
            Log.error(error)
        }
        
        return ("Hello", "English")
    }
    
    
    static func isLoggedIn() -> Bool {
        if (keychain["userName"] != nil) && (keychain["password"] != nil) {
            return true
        }
        else {
            return false
        }
    }
    
    
    
    
    
    /// Convert a unix timestamp in human date format
    ///
    /// - Parameters:
    ///   - timestamp: timestamp: unix timestamp
    ///   - withoutAM: if provided 'true' time format will be in h:mm format. Default value is false
    /// - Returns: return string date in "h:mm a" format
    static func getHumanDateTime(timestamp: Double, withoutAM: Bool = false) -> String {
        let date = Date.init(timeIntervalSince1970: timestamp)
        let dateFormatter = DateFormatter()
        if withoutAM {
            dateFormatter.dateFormat = "yyyy-MM-dd h:mm"
        }
        else {
            dateFormatter.dateFormat = "yyyy-MM-dd h:mm a"
        }
        
        return dateFormatter.string(from: date).lowercased()
    }
    
    
    static func getFormattedDateTimeFrom(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .full
        dateFormatter.timeStyle = .medium
        dateFormatter.locale = Locale(identifier: "en_US")
        
        return dateFormatter.string(from:date)
    }
    
    
    /// logout the current user and removes all related info from the keychain and userDetails
    static func logout(){
        keychain["userName"] = nil
        keychain["password"] = nil
        
        let userDefaults = UserDefaults.standard
        userDefaults.removeObject(forKey: "userInfo")
        userDefaults.removeObject(forKey: "userDetails")
        userDefaults.synchronize()
        
    }
    
}

