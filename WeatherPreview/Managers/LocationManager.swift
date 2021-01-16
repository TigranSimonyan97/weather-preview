//
//  LocationManager.swift
//  WeatherPreview
//
//  Created by Tigran Simonyan on 1/14/21.
//

import Foundation
import CoreLocation
import RxSwift

enum LocationError : Error {
    case missingAuthorization
    case other(Error)
    
    static func map(_ error: Error) -> LocationError {
      return (error as? LocationError) ?? .other(error)
    }

}

class LocationManager : NSObject {
    private let locationManager = CLLocationManager()
    
    var currentLocation: BehaviorSubject<CLLocation?> = BehaviorSubject(value: nil)
    
    func determineCurrentLocation() throws {

        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        
        let hasAuthorizedAccess = hasLocationAuthorizedAccess()
        
        if hasAuthorizedAccess {
            locationManager.startUpdatingLocation()
        } else {
            throw LocationError.missingAuthorization
        }
    }
    
    private func hasLocationAuthorizedAccess() -> Bool {
        var hasAccess = false
        
        if CLLocationManager.locationServicesEnabled() {
            switch locationManager.authorizationStatus {
            case .notDetermined, .restricted, .denied:
                hasAccess = false
            case .authorizedAlways, .authorizedWhenInUse:
                hasAccess = true
            @unknown default:
                break
            }
        } else {
            hasAccess = false
        }
        
        return hasAccess
    }
}

extension LocationManager : CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let newLocation = locations.first
        currentLocation.onNext(newLocation)
        if newLocation != nil {
            locationManager.stopUpdatingLocation()
        }
    }
}
