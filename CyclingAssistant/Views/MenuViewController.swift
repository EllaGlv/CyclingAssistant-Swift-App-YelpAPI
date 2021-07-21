//
//  MenuViewController.swift
//  CyclingAssistant
//
//  Created by Alla Golovinova on 6/9/21.
//

import UIKit
import CoreLocation

class MenuViewController: UIViewController {
    
    @IBOutlet weak var currentAddressLabel: UILabel!
    
    var currentLatitude = Double()
    var currentLongitude = Double()
    let locationManger = CLLocationManager()
    var titleOfButtonPressed = String()
    let spinner = ActivityIndicatorViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //get current location
        locationManger.delegate = self
        locationManger.requestWhenInUseAuthorization()
        locationManger.requestLocation()
        
        //show activity indicator (spinner) while loading current location
        createSpinnerView()
        
    }
    
    // MARK: Current Location: Reload Location and Get Address in String
    
    // Reload Location Data
    @IBAction func reloadCurrentLocationButtonTapped(_ sender: Any) {
        locationManger.requestLocation()
    }
    
    // Get the address in String from Location Data
    func getAddressName(lat: Double, lon: Double, completion: (_ success: Bool) -> Void) {
        
        let ceo: CLGeocoder = CLGeocoder()
        let loc: CLLocation = CLLocation(latitude: lat, longitude: lon)
        
        ceo.reverseGeocodeLocation(loc, completionHandler: {(placemarks, error) in
            if (error != nil) {
                print("reverse geodcode fail: \(error!.localizedDescription)")
            }
            let pm = placemarks! as [CLPlacemark]
            
            if pm.count > 0 {
                let pm = placemarks![0]
                
                var addressString : String = ""
                if pm.subLocality != nil {
                    addressString = addressString + pm.subThoroughfare! + ", "
                }
                if pm.thoroughfare != nil {
                    addressString = addressString + pm.thoroughfare! + ", "
                }
                if pm.locality != nil {
                    addressString = addressString + pm.locality! + ", "
                }
                if pm.country != nil {
                    addressString = addressString + pm.country! + ", "
                }
                if pm.postalCode != nil {
                    addressString = addressString + pm.postalCode! + " "
                }
                self.currentAddressLabel.text = addressString
                print(addressString)
            }
        })
        completion(true)
    }
    
    // MARK: Menu Buttons Tapped
    
    @IBAction func menuButtonTapped(_ sender: UIButton) {
        if let buttonTitle = sender.title(for: .normal) {
            titleOfButtonPressed = buttonTitle
        }
        performSegue(withIdentifier: "placesSegue", sender: sender)
    }
    
    // Prepare for Segue to "PlacesViewController"
    // Categories were chosen from https://www.yelp.com/developers/documentation/v3/all_category_list
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "placesSegue" {
            let placesViewController = segue.destination as? PlacesViewController
            placesViewController!.currentLatitude = currentLatitude
            placesViewController!.currentLongitude = currentLongitude
            
            switch titleOfButtonPressed {
            case "Buy": do {
                placesViewController!.category = "bikes"
                placesViewController!.titleName = "Buy"
            }
            
            case "Rent": do {
                placesViewController!.category = "bikerentals"
                placesViewController!.titleName = "Rent"
            }
            
            case "Repair": do {
                placesViewController!.category = "bike_repair_maintenance"
                placesViewController!.titleName = "Repair"
            }
            case "Tours": do {
                placesViewController!.category = "biketours"
                placesViewController!.titleName = "Tours"
            }
            default:
                print ("default")
            }
        }
    }
    
    
    // MARK: Activity Indicator (Spinner) functions
    
    func createSpinnerView() {
        addChild(spinner)
        spinner.view.frame = view.frame
        view.addSubview(spinner.view)
        spinner.didMove(toParent: self)
    }
    
    func removeSpinnerView() {
        spinner.willMove(toParent: nil)
        spinner.view.removeFromSuperview()
        spinner.removeFromParent()
    }
    
}

// MARK: CLLocationManagerDelegate

extension MenuViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if let location = locations.last {
            locationManger.stopUpdatingLocation()
            currentLatitude = location.coordinate.latitude
            currentLongitude = location.coordinate.longitude
            
            getAddressName(lat: currentLatitude, lon: currentLongitude, completion: { (success) -> Void in
                if success {
                    //remove activity indicator (spinner) after loading current location in String
                    removeSpinnerView()
                }
            })
            print(currentLatitude)
            print(currentLongitude)
        }
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}
