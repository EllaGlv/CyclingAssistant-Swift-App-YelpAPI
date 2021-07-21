//
//  DataManager.swift
//  CyclingAssistant
//
//  Created by Alla Golovinova on 6/9/21.
//

import Foundation

struct DataManager {
    
    func getVenues(latitude: Double,
                   longitude: Double,
                   category: String,
                   limit: Int,
                   sortBy: String,
                   locale: String,
                   completionHandler: @escaping ([Venue]?, Error?) -> Void) {
        
        let apikey = MyYelpApiKey
        
        // Create a URL
        let baseURL = "https://api.yelp.com/v3/businesses/search?latitude=\(latitude)&longitude=\(longitude)&categories=\(category)&limit=\(limit)&sort_by=\(sortBy)&locale=\(locale)"
        let url = URL(string: baseURL)
        
        // Creating request
        var request = URLRequest(url: url!)
        request.setValue("Bearer \(apikey)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
        
        // Initialize session and task
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completionHandler(nil, error)
            }
            do {
                
                // Read data as JSON
                let json = try JSONSerialization.jsonObject(with: data!, options: [])
                
                // Main dictionary
                guard let resp = json as? NSDictionary else { return }
                
                // Businesses
                guard let businesses = resp.value(forKey: "businesses") as? [NSDictionary] else { return }
                
                var venuesList: [Venue] = []
                
                // Accessing each business
                for business in businesses {
                    var venue = Venue()
                    venue.name = business.value(forKey: "name") as? String
                    venue.id = business.value(forKey: "id") as? String
                    venue.rating = business.value(forKey: "rating") as? Float
                    venue.price = business.value(forKey: "price") as? String
                    venue.is_closed = business.value(forKey: "is_closed") as? Bool
                    venue.distance = business.value(forKey: "distance") as? Double
                    let address = business.value(forKeyPath: "location.display_address") as? [String]
                    venue.address = address?.joined(separator: "\n")
                    venue.latitude = business.value(forKeyPath: "coordinates.latitude") as? Double
                    venue.longitude = business.value(forKeyPath: "coordinates.longitude") as? Double
                    venue.phone = business.value(forKey: "display_phone") as? String
                    venue.image_url =  business.value(forKey: "image_url") as? String
                    
                    venuesList.append(venue)
                    
                }
                
                completionHandler(venuesList, nil)
                
            } catch {
                print("Caught error")
                completionHandler(nil, error)
            }
            //Start the task
        }.resume()
    }
}


