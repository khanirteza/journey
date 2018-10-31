//
//  APIManager.swift
//  journey
//
//  Created by Mohammad Irteza Khan on 10/30/18.
//  Copyright © 2018 !serious. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import CoreLocation


class APIManager {
    
    enum TimeType: String {
        case leaveNow
        case departAfter
        case arriveBefore
    }
    
    static func getTripData(from: CLLocationCoordinate2D, to: CLLocationCoordinate2D, timeChoice: TimeType, time: Int, boundaryChoice: TimeType, boundaryTime: Int, preference: (Float, Float, Float, Float)? = nil, completion: @escaping (Int?, [JSON]?, [Int: JSON]?) -> ()){
        let baseURL = "https://api.tripgo.com/v1/routing.json"
        var urlComponents = URLComponents(string: baseURL)
        let queryItems = [URLQueryItem.init(name: "from", value: "(\(from.latitude),\(from.longitude))"),
                          URLQueryItem.init(name: "to", value: "(\(to.latitude),\(to.longitude))"),
                          URLQueryItem.init(name: timeChoice.rawValue, value: "\(time)"),
                          URLQueryItem.init(name: boundaryChoice.rawValue, value: "\(boundaryTime)"),
                          URLQueryItem.init(name: "modes[]", value: "pt_pub"),
                          URLQueryItem.init(name: "v", value: "11"),
                          URLQueryItem.init(name: "locale", value: "en")
        ]
        
        //        if let preference = preference {
        //            queryItems.append(URLQueryItem.init(name: "wp", value: "\(preference)"))
        //        }
        
        urlComponents?.queryItems = queryItems
        
        guard let tripGoURL = urlComponents?.url else{
            return
        }
        
        //        Log.debug(tripGoURL)
        
        let headers: HTTPHeaders = [
            "Accept": "application/json",
            "X-TripGo-Key": Utilities.retrieveKeyFor(.TripGoKey)!
        ]
        
        Alamofire.request(tripGoURL, method: .get, headers: headers).responseData { response in
            
            let statusCode = response.response?.statusCode
            
            if statusCode != 200 {
                Log.error("request failed with \(String(describing: statusCode))")
                completion(statusCode, nil, nil)
            }
            else {
                
                let json = try! JSON.init(data: response.value!)
                //Log.debug(json["groups"][0]["trips"][0]["segments"][0]["startTime"])
                
                //let trip = [json["groups"][0]["trips"][0]]
                var trips = [JSON]()
                
                for group in json["groups"] {
                    //Log.debug(group.1["trips"].count)
                    for trip in group.1["trips"] {
                        if timeChoice == .departAfter {
                            if trip.1["depart"].intValue >= time && trip.1["arrive"].intValue <= boundaryTime {
                                trips.append(trip.1)
                            }
                        }
                        else if timeChoice == .arriveBefore {
                            if trip.1["arrive"].intValue <= time && trip.1["depart"].intValue >= boundaryTime {
                                trips.append(trip.1)
                            }
                        }
                        //trips.append(trip.1)
                    }
                    //trips.append(group.1["trips"])
                }
                
                //Log.debug(trips)
                // convert segmentTemplates from response to [hashCode: segment] dictionary to easily retrieve segment using their hashcode
                var segmentTemplates: [Int: JSON] = [Int: JSON]()
                
                for segment in json["segmentTemplates"] {
                    segmentTemplates[segment.1["hashCode"].intValue] = segment.1
                }
                
                completion(statusCode!, trips, segmentTemplates)
                
            }
        }
    }
}
