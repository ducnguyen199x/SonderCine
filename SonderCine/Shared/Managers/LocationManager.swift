//
//  LocationManager.swift
//  SonderCine
//
//  Created by Nguyen Thanh Duc on 30/8/21.
//

import Foundation
import CoreLocation

class LocationManager: NSObject {
    static let shared = LocationManager()
    private let clLocationManager = CLLocationManager()
    @Relay var currentCoordinate = Coordinate(lat: -34, lng: 151)
    
    private override init() {
        super.init()
        clLocationManager.requestWhenInUseAuthorization()
        clLocationManager.delegate = self
        clLocationManager.distanceFilter = 10
        clLocationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func updateLocation() {
        if CLLocationManager.locationServicesEnabled() {
            if let coordinate = clLocationManager.location?.coordinate {
                currentCoordinate = Coordinate(lat: coordinate.latitude, lng: coordinate.longitude)
            }
            clLocationManager.startUpdatingLocation()
        }
    }
    
    func stopUpdateLocation() {
        clLocationManager.delegate = nil
        clLocationManager.stopUpdatingLocation()
    }
}
extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let coordinate = manager.location?.coordinate else { return }
        currentCoordinate = Coordinate(lat: coordinate.latitude, lng: coordinate.longitude)
        stopUpdateLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            updateLocation()
        default: break
        }
    }
}
