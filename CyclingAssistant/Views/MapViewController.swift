//
//  MapViewController.swift
//  CyclingAssistant
//
//  Created by Alla Golovinova on 6/9/21.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {
    
    var selectedLatitude = Double()
    var selectedLongitude = Double()
    var currentLatitude = Double()
    var currentLongitude = Double()
    var companyName: String?
    var address = String()
    
    @IBOutlet weak var currentAddressLabel: UILabel!
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = companyName
        
        //Center location on Map
        let initialLocation = CLLocation(latitude: selectedLatitude, longitude: selectedLongitude)
        mapView.centerToLocation(initialLocation)
        
        currentAddressLabel.text = address
        
        // Marker on map
        let place = MKPointAnnotation()
        place.title = companyName
        place.coordinate = CLLocationCoordinate2D(latitude: selectedLatitude, longitude: selectedLongitude)
        mapView.addAnnotation(place)
    }
    
    //Recenter location on Map Button
    @IBAction func recenterMapTapped(_ sender: Any) {
        let initialLocation = CLLocation(latitude: selectedLatitude, longitude: selectedLongitude)
        mapView.centerToLocation(initialLocation)
    }
}

// MARK: Center location on the map.
// Get from https://www.raywenderlich.com/7738344-mapkit-tutorial-getting-started
private extension MKMapView {
    func centerToLocation(
        _ location: CLLocation,
        regionRadius: CLLocationDistance = 500
    ) {
        let coordinateRegion = MKCoordinateRegion(
            center: location.coordinate,
            latitudinalMeters: regionRadius,
            longitudinalMeters: regionRadius)
        setRegion(coordinateRegion, animated: true)
    }
    
}
