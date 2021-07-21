//
//  PlacesViewController.swift
//  CyclingAssistant
//
//  Created by Alla Golovinova on 6/9/21.
//

import UIKit

//For button in PlacesTableViewCell
protocol viewOnMapButtonTappedProtocol: class {
    func viewOnMapButtonTapped(sender: UIButton)
}

class PlacesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, viewOnMapButtonTappedProtocol {
    
    @IBOutlet weak var tableView: UITableView!
    
    var dataManager = DataManager()
    var currentLatitude = Double()
    var currentLongitude = Double()
    var category = String()
    var titleName = String()
    var currentIndex = Int()
    var venues: [Venue] = []
    let spinner = ActivityIndicatorViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = titleName
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 96.0
        tableView.allowsSelection = false
        
        //show activity indicator (spinner) while loading TableView
        createSpinnerView()
        
        //get venues(places) from API Yelp according to latitude, longitude and category
        dataManager.getVenues(latitude: currentLatitude, longitude: currentLongitude, category: category, limit: 20, sortBy: "distance", locale: "en_US") { (response, error) in
            if let response = response {
                self.venues = response
                
                DispatchQueue.main.async { [self] in
                    //reload TableView
                    self.tableView.reloadData()
                    //remove activity indicator (spinner) after loading TableView
                    removeSpinnerView() 
                }
            }
        }
    }
    
    // MARK: TableView
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return venues.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "placesCell", for: indexPath) as! PlacesTableViewCell
        
        cell.companyNameLabel.text = venues[indexPath.row].name
        cell.addressLabel.text = venues[indexPath.row].address
        cell.phoneNumberButton.setTitle(venues[indexPath.row].phone, for: .normal)
        cell.phoneNumberButton.addTarget(self, action: #selector(phoneNumberButtonTapped), for: .touchUpInside)
        cell.image_url = venues[indexPath.row].image_url
        cell.selectedLatitude = venues[indexPath.row].latitude!
        cell.selectedLongitude = venues[indexPath.row].longitude!
        cell.currentTag = indexPath.row
        cell.delegateCell = self
        
        if let url = URL(string: cell.image_url!) {
            let data = try? Data(contentsOf: url)
            cell.imagePlace.image = UIImage(data: data!)
        }
        return cell
    }
    
    
    // MARK: Buttons Tapped
    
    //Make a call
    @objc func phoneNumberButtonTapped(sender: UIButton) {
        if let buttonTitle = sender.title(for: .normal) {
            let encodingPhone = buttonTitle.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
            if let phoneURL = URL(string: "telprompt://" + encodingPhone!) {
                print("callNumber", phoneURL)
                
                let alert = UIAlertController(title: ("Call " + buttonTitle + "?"), message: nil, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Call", style: .default, handler: { (action) in
                    print("alert")
                    UIApplication.shared.open(phoneURL as URL, options: [:], completionHandler: nil)
                }))
                
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    //View location on the Map
    func viewOnMapButtonTapped (sender: UIButton) {
        currentIndex = sender.tag
        performSegue(withIdentifier: "mapSegue", sender: sender)
    }
    
    //Prepare for Segue to "MapViewController" to see Venue on Map
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let mapViewController = segue.destination as? MapViewController
        mapViewController!.selectedLatitude = venues[currentIndex].latitude!
        mapViewController!.selectedLongitude = venues[currentIndex].longitude!
        mapViewController!.companyName = venues[currentIndex].name!
        mapViewController!.address = venues[currentIndex].address!
        mapViewController!.currentLatitude = currentLatitude
        mapViewController!.currentLatitude = currentLatitude
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
