//
//  ViewController.swift
//  Retrograde
//
//  Created by Hector Delgado on 1/4/21.
//

import UIKit
import CoreLocation
import Alamofire
import SwiftyJSON

class ViewController: UIViewController {
    let manager = CLLocationManager()
    let keyFetcher = KeyFetcher()
    var locationAuthorized = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        manager.delegate = self
        
        print("We're setting things up...")
        
        if (manager.authorizationStatus == .authorizedWhenInUse) {
            print("We are authorized")
            manager.requestLocation()
        } else {
            print("We are not authorized")
            manager.requestWhenInUseAuthorization()
        }
    }
}

extension ViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // Check if we have one good location. Use first location retrieved as our current location.
        if let location = locations.first {
            print("Found users location: \(location)")
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            let appid = keyFetcher.getKeyFor(fileName: "OW-Info", fileType: "plist", keyName: "API_KEY")
            
            // Create GET request to retrieve current weather data.
            AF.request("https://api.openweathermap.org/data/2.5/onecall?lat=\(lat)&lon=\(lon)&appid=\(appid)").validate().responseJSON { response in
                switch response.result {
                case .success(let value):
                    //let json = JSON(value)
                    //print(json)
                    let decoder = JSONDecoder()
                    
                    // Convert data from response into our data model.
                    do {
                        if let jsonData = response.data {
                            let currentForecast = try decoder.decode(CurrentForecast.self, from: jsonData)
                            print("We were able to convert the data")
                            print(currentForecast)
                        } else {
                            print("We failed to convert")
                        }
                    } catch {
                        print("An error occurred")
                    }
                case .failure(let error):
                    print("Error occurred making GET request")
                    print(error)
                }
            }
            return
        }
        
        print("We could not get a location!")
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to find users location: \(error.localizedDescription)")
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        // Update status of location usage authorization
        switch manager.authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            locationAuthorized = true
            manager.requestLocation()
            break
        case .notDetermined, .denied, .restricted:
            locationAuthorized = false
            break
        default:
            locationAuthorized = false
        }
    }
}

