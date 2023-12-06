//
//  LocationManager.swift
//  SideJob
//
//  Created by Lars Jensen on 11/30/23.
//

import Foundation
import CoreLocation

class LocationManager: NSObject, CLLocationManagerDelegate, ObservableObject {
    var locManager = CLLocationManager()
    var locationServicesEnabled = false
    @Published var location: CLLocation?
    private var completion: ((CLLocation?) -> Void)?
    var userZipCode = ""
    var searchRadius = 100000000 //big number

    override init() {
        super.init()
        locManager.delegate = self
        locManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if manager.authorizationStatus == .authorizedAlways || manager.authorizationStatus == .authorizedWhenInUse {
            self.locationServicesEnabled = true
            print("Location services enabled")
        } else if manager.authorizationStatus == .denied || manager.authorizationStatus == .notDetermined {
            print("Location services not enabled")
        }
    }
    func requestAuthorization() {
        locManager.requestWhenInUseAuthorization()
        locManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        location = locations.first
    }
    
    func getLocationZipCode(completion: @escaping (String?) -> Void) {
        let geocoder = CLGeocoder()
        
        if let currentLoc = location {
            geocoder.reverseGeocodeLocation(currentLoc) { (placemarks, error) in
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
    
    func getLocationFromZipCode(from zipCode: String, completion: @escaping (CLLocation?) -> Void) {
        let geocoder = CLGeocoder()

        geocoder.geocodeAddressString(zipCode) { (placemarks, error) in
            if let error = error {
                print("Geocoding failed with error: \(error.localizedDescription)")
                completion(nil)
                return
            }

            guard let location = placemarks?.first?.location else {
                print("No location found.")
                completion(nil)
                return
            }

            completion(location)
        }
    }
}
