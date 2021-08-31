//
//  CineMapViewController.swift
//  SonderCine
//
//  Created by Nguyen Thanh Duc on 30/8/21.
//

import UIKit
import MapKit

protocol CineMapViewControllerDelegate: ViewControllerDelegate {}

final class CineMapViewController: BaseViewController {
    var viewModel: CineMapViewModel!
    weak var delegate: CineMapViewControllerDelegate?
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var searchTableView: UITableView!
    @IBOutlet weak var searchTableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var dismissSearchButton: UIButton!

    private let locationManager = CLLocationManager()
    private let regionInMeters: Double = 1000
    var currentCoordinate: CLLocationCoordinate2D?
    
    override func setupView() {
        super.setupView()
        searchBar.delegate = self
        setupMap()
        setupTableView()
    }
    
    private func setupMap() {
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        locationManager.distanceFilter = 10
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        mapView.showsUserLocation = true
        mapView.showsCompass = false
        mapView.delegate = self
        
        // Add Compass
        let compassButton = MKCompassButton(mapView: mapView)
        compassButton.compassVisibility = .visible
        mapView.addSubview(compassButton)
        compassButton.topToSuperview(offset: 15)
        compassButton.trailingToSuperview(offset: 15)
        
        // Add UserTrackingButton
        let trackingButton = MKUserTrackingButton(mapView: mapView)
        mapView.addSubview(trackingButton)
        trackingButton.topToBottom(of: compassButton, offset: 5)
        trackingButton.trailingToSuperview(offset: 15)
    }
    
    private func setupTableView() {
        searchTableView.roundCorners([.bottomLeft, .bottomRight], radius: 10)
    }
    
    override func bindViewModel() {
        super.bindViewModel()
    }
    
    override func willDeinit() {
        delegate?.viewControllerWillDeinit()
    }
    
    private func showSearchResults(_ shouldShow: Bool = true) {
        dismissSearchButton.isHidden = !shouldShow
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseInOut) {
            self.searchTableViewHeight.constant = shouldShow ? 250 : 0
            self.searchTableView.alpha = shouldShow ? 1 : 0
            self.view.layoutIfNeeded()
        }
    }
    
    private func trackingLocation() {
        if CLLocationManager.locationServicesEnabled() {
            centerViewOnUserLocation()
            locationManager.startUpdatingLocation()
        }
    }
    
    private func stopUpdateLocation() {
        locationManager.delegate = nil
        locationManager.stopUpdatingLocation()
    }
    
    private func centerViewOnUserLocation() {
        if let location = locationManager.location?.coordinate {
            let region = MKCoordinateRegion.init(center: location, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
            mapView.setRegion(region, animated: true)
        }
    }
    
    private func getCenterLocation() -> CLLocation {
        let latitude = mapView.centerCoordinate.latitude
        let longitude = mapView.centerCoordinate.longitude
        
        return CLLocation(latitude: latitude, longitude: longitude)
    }
    
    @IBAction func dismissSearch(_ sender: Any) {
        endEditing(true)
    }
}

// MARK: Search Bar delegates
extension CineMapViewController: UISearchBarDelegate {
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        showSearchResults()
        return true
    }
    
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        showSearchResults(false)
        return true
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    }
}

// MARK: CLLocationManager delegates
extension CineMapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if currentCoordinate == nil {
            centerViewOnUserLocation()
        }
        currentCoordinate = locationManager.location?.coordinate
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            trackingLocation()
        default: break
        }
    }
}

// MARK: MapView delegates
extension CineMapViewController: MKMapViewDelegate {
}
