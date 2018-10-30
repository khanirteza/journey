//
//  MainTabVC.swift
//  journey
//
//  Created by Mohammad Irteza Khan on 10/30/18.
//  Copyright © 2018 !serious. All rights reserved.
//

import UIKit
import CoreLocation
import Analytics


class MainTabVC: UITabBarController {
    var currentTripState = "Trip state: "
    
    var batteryLevel: Float {
        return UIDevice.current.batteryLevel
    }
    
    
    let locationManager = CLLocationManager()
    
    var inWorkOrHomeRegion = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        locationManager.requestAlwaysAuthorization()
        
        self.tabBar.tintColor = UIColor.flatGreen
        
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        
        let journeyPlanningVC = storyboard.instantiateViewController(withIdentifier: "JourneyPlanningVC")
        journeyPlanningVC.tabBarItem = UITabBarItem.init(title: "Journey Planning", image: UIImage.init(named: "ic_directions"), tag: 0)
        
        //        let profileVC: UIViewController
        
        var viewControllerList = [UIViewController]()
        
        
            let profileVC = storyboard.instantiateViewController(withIdentifier: "LoginVC")
            profileVC.tabBarItem = UITabBarItem.init(title: "Profile", image: UIImage.init(named: "ic_account"), tag: 1)
            
            viewControllerList = [journeyPlanningVC, profileVC]
        
        viewControllers = viewControllerList
        
        
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    func stopMonitoring(forRegion: CLCircularRegion) {
        for region in locationManager.monitoredRegions {
            guard let circularRegion = region as? CLCircularRegion else { continue }
            if circularRegion.identifier == forRegion.identifier {
                locationManager.stopMonitoring(for: circularRegion)
            }
        }
    }
    
    func removeTab(at index: Int) {
        guard let viewControllers = self.tabBarController?.viewControllers as? NSMutableArray else { return }
        viewControllers.removeObject(at: index)
        self.tabBarController?.viewControllers = (viewControllers as! [UIViewController])
    }
    
    
}
