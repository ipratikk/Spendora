//
//  LocationManager.swift
//  Utilities
//
//  Created by Goel, Pratik | RIEPL on 23/04/23.
//

import Foundation
import CoreLocation

public class LocationManager: NSObject, CLLocationManagerDelegate {

    private let locationManager = CLLocationManager()

    public override init() {
        super.init()

        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }

    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }

            // Fetch country code from country model
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { placemarks, error in
            guard let placemark = placemarks?.first, error == nil else { return }

            let countryCode = placemark.isoCountryCode
            print(countryCode ?? "Unknown")
        }

        locationManager.stopUpdatingLocation()
    }
}
