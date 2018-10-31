//
//  ProfileTVC.swift
//  journey
//
//  Created by Mohammad Irteza Khan on 10/30/18.
//  Copyright © 2018 !serious. All rights reserved.
//

import UIKit

class ProfileTVC: UITableViewController {
//    enum ProfileItem: Int {
//        case tableTitle
//        case name
//        case email
//        case primaryHome
//        case work
//    }
//    
//    @IBOutlet var profileTableView: UITableView!
//    @IBOutlet weak var nameLabel: JourneyBodyLabel!
//    @IBOutlet weak var emailLabel: JourneyBodyLabel!
//    @IBOutlet weak var primaryHomeLabel: JourneyBodyLabel!
//    @IBOutlet weak var workLabel: JourneyBodyLabel!
//    @IBOutlet weak var signOutButton: JourneyButton!
//    @IBOutlet weak var saveChangesButton: JourneyButton!
//    @IBOutlet weak var welcomeLabel: JourneyPopupHeadLabel!
//    @IBOutlet weak var welcomeSubtitle: JourneySmallBodyLabel!
//    
//    //    var address: UpdateAddressVC.ResultAddress?
//    //var updatedUserData: [String: Any]?
//    
//    var home1, home2, work: Any?
//    
//    var backButton: UIButton?
//    var height: CGFloat = 0
//    var isUserDataChanged = false {
//        didSet {
//            DispatchQueue.main.async {
//                self.saveChangesButton.makeEnable(self.isUserDataChanged)
//            }
//        }
//    }
//    var isValidUserData = true
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        hideKeyboardWhenTappedAround()
//        
//        profileTableView.separatorColor = UIColor.flatWhite
//        
//        saveChangesButton.makeEnable(false)
//        saveChangesButton.backgroundColor = UIColor.flatGreen
//        
//        signOutButton.layer.borderColor = UIColor.black.cgColor
//        signOutButton.layer.borderWidth = 2
//        signOutButton.backgroundColor = UIColor.white
//        
//        nameLabel.alpha = 0.5
//        emailLabel.alpha = 0.5
//        
//        userDetails = Utilities.retrieveUserDetails()
//        
//        guard let userDetails = userDetails else {
//            return
//        }
//        
//        
//        nameLabel.text = userDetails.name.givenName + " " + userDetails.name.familyName
//        emailLabel.text = userDetails.emails.first?.value
//        
//        for poi in userDetails.pointsOfInterest {
//            switch poi.name {
//            case "home1":
//                primaryHomeLabel.text = Utilities.splitAddress(poi.address)
//                home1 = [
//                    "name": "home1",
//                    "address": "\(poi.address)",
//                    "location": [
//                        "latitude": poi.location.latitude,
//                        "longitude": poi.location.longitude
//                    ]
//                ]
//                
//            case "home2":
//                //                secondaryHomeLabel.text = Utilities.splitAddress(poi.address)
//                home2 = [
//                    "name": "home2",
//                    "address": "\(poi.address)",
//                    "location": [
//                        "latitude": poi.location.latitude,
//                        "longitude": poi.location.longitude
//                    ]
//                ]
//                
//            case "work":
//                workLabel.text = Utilities.splitAddress(poi.address)
//                work = [
//                    "name": "work",
//                    "address": "\(poi.address)",
//                    "location": [
//                        "latitude": poi.location.latitude,
//                        "longitude": poi.location.longitude
//                    ]
//                ]
//                
//            default:
//                break
//            }
//            
//        }
//        
//    }
//    
//    
//    override func viewWillAppear(_ animated: Bool) {
//        let greeting = Utilities.getRandomGreetings()
//        
//        welcomeLabel.text = greeting.greeting
//        welcomeSubtitle.text = "Now you know how to say hello in " + greeting.language + "."
//    }
//    
//    
//    override func viewDidLayoutSubviews() {
//        nameLabel.sizeToFit()
//        emailLabel.sizeToFit()
//        primaryHomeLabel.sizeToFit()
//        workLabel.sizeToFit()
//    }
//    
//    @IBAction func signOutTapped(_ sender: JourneyButton) {
//        
//        Utilities.logout()
//        
//        let sb = UIStoryboard.init(name: "Main", bundle: nil)
//        let mainTabVC = sb.instantiateViewController(withIdentifier: "MainTabVC")
//        present(mainTabVC, animated: true, completion: nil)
//        
//    }
//    
//    
//    @IBAction func tappedOnSaveChanges(_ sender: JourneyButton) {
//        var poi: [Any] = []
//        if let home1 = home1 {
//            poi.append(home1)
//        }
//        if let home2 = home2 {
//            poi.append(home2)
//        }
//        if let work = work {
//            poi.append(work)
//        }
//        
//        //updatedUserData["pointsOfInterest"] = poi
//        
//        
//        let phone = [
//            [
//                "value": userDetails?.phoneNumbers.first?.value
//            ]
//        ]
//        //updatedUserData["phoneNumbers"] = phone as Any
//        //updatedUserData["openToCarpool"] = carpoolingSwitch.isOn
//        
//        let updatedUserData: [String: Any] = [
//            "userName": (userDetails?.userName)!,
//            "name": [
//                "familyName": (userDetails?.name.familyName)!,
//                "givenName": (userDetails?.name.givenName)!
//            ],
//            "emails": [
//                [
//                    "value": (userDetails?.emails.first?.value)!,
//                    "primary": true
//                ]
//            ],
//            "phoneNumbers": phone,
//            "active": true,
//            "verified": true,
//            "pointsOfInterest": poi,
//            //"allowPushNotification": (self.userDetails?.allowPushNotifications)!,
//            "openToCarpool": userDetails?.openToCarpool,
//            "permitActivityDataSharing": self.userDetails?.permitActivityDataSharing,
//            //"slackUserId": self.userDetails?.slackUserId,
//            "onboarded": self.userDetails?.onboarded
//        ]
//        
//        //Log.debug(updatedUserData)
//        
//        if isUserDataChanged {
//            GFLAuth.sharedInstance.updateUserWith(userName: keychain["userName"]!, password: keychain["password"]!, userDetails: updatedUserData){ statusCode, updatedInfo, error in
//                
//                if statusCode != 200 {
//                    Log.error("failed to update user")
//                }
//                else {
//                    Log.debug("Successfully updated user")
//                    
//                    DispatchQueue.main.async {
//                        self.saveChangesButton.makeEnable(false)
//                    }
//                    
//                    GFLAuth.sharedInstance.getUserDetails(userName: keychain["userName"]!, password: keychain["password"]!) { statusCode, userDetails, error in
//                        if statusCode != 200 {
//                            Log.error("Failed to fetch user details")
//                        }
//                        else {
//                            Utilities.storeUserDetails(userDetails)
//                        }
//                    }
//                }
//            }
//        }
//    }
//    
//    
//    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        Log.debug(indexPath.row)
//        guard let selectedRow = ProfileItem(rawValue: indexPath.row) else {
//            return
//        }
//        switch selectedRow {
//        case .primaryHome:
//            let popupVC = UIStoryboard.init(name: "Misc", bundle: nil).instantiateViewController(withIdentifier: "UpdateAddressVC") as! UpdateAddressVC
//            
//            popupVC.heading = "Update home address"
//            popupVC.addressTitle = "Home"
//            let jsonHome = home1 as! [String: Any]
//            popupVC.searchText = jsonHome["address"] as? String
//            popupVC.primaryButtonLabel = "Update"
//            popupVC.modalPresentationStyle = .overCurrentContext
//            popupVC.modalTransitionStyle = .crossDissolve
//            self.present(popupVC, animated: true, completion: nil)
//            popupVC.didSelectAddress = { selectedAddress in
//                self.primaryHomeLabel.text = Utilities.splitAddress(selectedAddress.address)
//                self.isUserDataChanged = true
//                
//                self.home1 = [
//                    //[
//                    "name": "home1",
//                    "address": "\(selectedAddress.address)",
//                    "location": [
//                        "latitude": selectedAddress.location.latitude,
//                        "longitude": selectedAddress.location.longitude
//                    ]
//                    //]
//                ]
//                //self.userData["pointsOfInterest"] = poi
//            }
//            
//        case .work:
//            let popupVC = UIStoryboard.init(name: "Misc", bundle: nil).instantiateViewController(withIdentifier: "UpdateAddressVC") as! UpdateAddressVC
//            
//            popupVC.heading = "Update work address"
//            popupVC.addressTitle = "Work"
//            if let jsonWork = work as? [String: Any] {
//                popupVC.searchText = jsonWork["address"] as? String
//            }
//            popupVC.primaryButtonLabel = "Update"
//            popupVC.modalPresentationStyle = .overCurrentContext
//            popupVC.modalTransitionStyle = .crossDissolve
//            self.present(popupVC, animated: true, completion: nil)
//            popupVC.didSelectAddress = { selectedAddress in
//                self.workLabel.text = Utilities.splitAddress(selectedAddress.address)
//                self.isUserDataChanged = true
//                
//                self.work = [
//                    //[
//                    "name": "work",
//                    "address": "\(selectedAddress.address)",
//                    "location": [
//                        "latitude": selectedAddress.location.latitude,
//                        "longitude": selectedAddress.location.longitude
//                    ]
//                    //]
//                ]
//                //self.userData["pointsOfInterest"] = poi
//            }
//            
//        default:
//            break
//        }
//    }
//    
}

