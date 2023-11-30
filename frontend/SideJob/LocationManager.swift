//
//  LocationManager.swift
//  SideJob
//
//  Created by Lars Jensen on 11/30/23.
//

import Foundation
import CoreLocation

class LocationManager: NSObject, CLLocationManagerDelegate {
    var locManager = CLLocationManager()
    var locationServicesEnabled = false
    @Published var location: CLLocation?
    private var completion: ((CLLocation?) -> Void)?

    override init() {
        super.init()
        locManager.delegate = self
        locManager.desiredAccuracy = kCLLocationAccuracyBest
        locManager.requestWhenInUseAuthorization()
        locManager.startUpdatingLocation()
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if manager.authorizationStatus == .authorizedAlways || manager.authorizationStatus == .authorizedWhenInUse {
            locManager.startUpdatingLocation()
            self.locationServicesEnabled = true
            print("Location services enabled")
        } else if manager.authorizationStatus == .denied || manager.authorizationStatus == .notDetermined {
            print("Location services not enabled")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        location = locations.first
    }
    
    func getCurrentLocation(completion: @escaping (CLLocation?) -> Void) {
        self.completion = completion
        locManager.requestLocation()
    }
    
    
    func getLocationZipCode(location: CLLocation, completion: @escaping (String?) -> Void) {
        let geocoder = CLGeocoder()
        
        geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
            if let error = error {
                print("Reverse geocoding failed with error: \(error.localizedDescription)")
                completion(nil)
                return
            }
            
            guard let placemark = placemarks?.first else {
                print("No placemark found.")
                completion(nil)
                return
            }
            
            if let postalCode = placemark.postalCode {
                completion(postalCode)
            } else {
                print("No postal code found.")
                completion(nil)
            }
        }
    }

}
