//
//  AddressSelectionVC.swift
//  journey
//
//  Created by Mohammad Irteza Khan on 10/30/18.
//  Copyright © 2018 !serious. All rights reserved.
//

import UIKit
import MapKit

class AddressSelectionVC: UIViewController {
    
    struct ResultAddress {
        var address: String
        var location: CLLocationCoordinate2D
    }
    
    var searchCompleter = MKLocalSearchCompleter()
    var searchResults = [MKLocalSearchCompletion]()
    
    var didSelectAddress:((_ selectedAddress: ResultAddress) -> ())?
    
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var addressTextField: JourneyTextField!
    @IBOutlet weak var searchResultTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        searchCompleter.delegate = self
        searchResultTableView.delegate = self
        searchResultTableView.dataSource = self
        
        self.hideKeyboardWhenTappedAround()
        
        addressTextField.becomeFirstResponder()
        
        headerView.backgroundColor = UIColor.flatGreen
        addressTextField.backgroundColor = UIColor.white
    }
    
    @IBAction func tappedOnCancel(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func textChanged(_ sender: JourneyTextField) {
        searchCompleter.queryFragment = addressTextField.text!
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}


extension AddressSelectionVC: MKLocalSearchCompleterDelegate{
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        searchResults = completer.results
        searchResultTableView.reloadData()
    }
    
    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        // handle error
    }
}

extension AddressSelectionVC: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let searchResult = searchResults[indexPath.row]
        //let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil) as! SearchResultTableViewCell
        let cell = searchResultTableView.dequeueReusableCell(withIdentifier: "resultCellID", for: indexPath) as! SearchResultTableViewCell
        cell.titleLabel?.text = searchResult.title
        cell.subtitleLabel?.text = searchResult.subtitle
        cell.backgroundColor = UIColor.clear
        return cell
    }
}

extension AddressSelectionVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let completion = searchResults[indexPath.row]
        
        let searchRequest = MKLocalSearch.Request(completion: completion)
        let search = MKLocalSearch(request: searchRequest)
        search.start { (response, error) in
            let coordinate = response?.mapItems[0].placemark.coordinate
            // removing the country name from the last part of the address line
            let fullAddressLine = response?.mapItems[0].placemark.title
            var components = fullAddressLine?.components(separatedBy: ",")
            components?.removeLast()
            let addressLine = components?.joined(separator: ",")
            Log.debug(addressLine)
            
            let resultAddress = ResultAddress.init(address: addressLine!, location: coordinate!)
            self.didSelectAddress?(resultAddress)
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
}
