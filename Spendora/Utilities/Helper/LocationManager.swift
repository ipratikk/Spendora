//
//  LocationManager.swift
//  Utilities
//
//  Created by Goel, Pratik | RIEPL on 23/04/23.
//

import Foundation
import CoreLocation
import RxSwift
import RxCocoa

public class LocationManager: NSObject, CLLocationManagerDelegate {

    public static let shared = LocationManager()

    private let locationManager = CLLocationManager()

    var completion: ((String?) -> Void)?

    public func getUserLocation(completion: @escaping ((String?) -> Void)) {
        self.completion = completion
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
    }

    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        let geoCoder = CLGeocoder()
        geoCoder.reverseGeocodeLocation(location) { (placemark, _) in
            guard let currentLocPlacemark = placemark?.first else { return }
            print("Current Location Mark: \(currentLocPlacemark.isoCountryCode)")
            self.completion?(currentLocPlacemark.isoCountryCode)
        }
        locationManager.stopUpdatingLocation()
    }
}
