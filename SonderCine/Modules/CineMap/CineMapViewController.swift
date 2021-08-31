//
//  CineMapViewController.swift
//  SonderCine
//
//  Created by Nguyen Thanh Duc on 30/8/21.
//

import UIKit
import MapKit

protocol CineMapViewControllerDelegate: ViewControllerDelegate {
    func cineMap(_ sender: UIViewController, didSelect location: CLLocationCoordinate2D)
}

final class CineMapViewController: BaseViewController {
    var viewModel: CineMapViewModel!
    weak var delegate: CineMapViewControllerDelegate?
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var searchWithCoordinateView: UIView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var latTextField: UITextField!
    @IBOutlet weak var lngTextField: UITextField!
    @IBOutlet weak var coordinateSearchButton: UIButton!
    @IBOutlet weak var coordinateSearchTitle: UILabel!
    @IBOutlet weak var clearButton: UIButton!

    private let locationManager = CLLocationManager()
    private let regionInMeters: Double = 1000
    private var currentCoordinate: CLLocationCoordinate2D?
    private let geoCoder = CLGeocoder()
    private var previousLocation: CLLocation?
    var directionsArray: [MKDirections] = []
    
    override func setupView() {
        super.setupView()
        searchBar.delegate = self
        searchWithCoordinateView.layer.shadowOffset = CGSize(width: 0, height: 2)
        searchWithCoordinateView.layer.shadowRadius = 2
        searchWithCoordinateView.layer.shadowOpacity = 0.5
        setupMap()
    }
    
    override func localizedText() {
        super.localizedText()
        searchBar.placeholder = LocalizedKey.CineMap.searchPlaceholder.localized()
        coordinateSearchTitle.text = LocalizedKey.CineMap.searchLatLng.localized()
        coordinateSearchButton.setTitle(LocalizedKey.CineMap.search.localized(), for: .normal)
        coordinateSearchButton.setTitle(LocalizedKey.CineMap.clear.localized(), for: .normal)
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
        
        trackingLocation()
    }
    
    override func bindViewModel() {
        super.bindViewModel()
    }
    
    override func willDeinit() {
        delegate?.viewControllerWillDeinit()
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
    
    /**
     Draw Direction to specific placemark
     */
    private func drawDirection(to placemark: CLPlacemark) {
        guard let coordinate = placemark.location?.coordinate else { return }
        drawDirection(to: coordinate)
    }
    
    /**
     Draw Direction to specific coordinate
     */
    private func drawDirection(to coordinate: CLLocationCoordinate2D) {
        guard let location = locationManager.location?.coordinate else {
            Alert.showOneButtonAlert(message: LocalizedKey.Alert.locationNoPermission.localized(), in: self)
            return
        }
        
        let request = createDirectionsRequest(from: location, to: coordinate)
        let directions = MKDirections(request: request)
        resetMapView(withNew: directions)
        
        directions.calculate { [weak self] (response, error) in
            guard let self = self else { return }
            if error != nil {
                Alert.showOneButtonAlert(message: LocalizedKey.Alert.locationNotFound.localized(), in: self)
                return
            }
            guard let response = response,
                  let route = response.routes.first else {
                Alert.showOneButtonAlert(message: LocalizedKey.Alert.locationNotFound.localized(), in: self)
                return
            }
            
            // Add Pin
            self.mapView.annotations.forEach(self.mapView.removeAnnotation)
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            self.mapView.addAnnotation(annotation)
            
            // Draw direction
            self.mapView.addOverlay(route.polyline)
            
            // Zoom out to see full paths
            self.mapView.setVisibleMapRect(route.polyline.boundingMapRect, edgePadding: .uniform(50), animated: true)
        }
    }
    
    /**
     Create Direction Request
     - Parameter fromCoordinate: source location
     - Parameter toCoordinate: destication
     */
    func createDirectionsRequest(from fromCoordinate: CLLocationCoordinate2D, to toCoordinate: CLLocationCoordinate2D) -> MKDirections.Request {
        let startingLocation = MKPlacemark(coordinate: fromCoordinate)
        let destination = MKPlacemark(coordinate: toCoordinate)
        
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: startingLocation)
        request.destination = MKMapItem(placemark: destination)
        request.transportType = .automobile
        
        return request
    }
    
    /**
     Remove all directions and draw new one
     - Parameter directions: new directions, set nil if only want to clear all directions and center view on user location
     */
    func resetMapView(withNew directions: MKDirections?) {
        mapView.removeOverlays(mapView.overlays)
        if let directions = directions {
            directionsArray.append(directions)
        } else {
            centerViewOnUserLocation()
        }
        directionsArray.forEach { $0.cancel() }
    }
    
    /**
     Find Location
     - Parameter text: address / location name
     */
    private func findLocation(_ text: String) {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = text
        request.region = mapView.region
        
        let search = MKLocalSearch(request: request)
        search.start { [weak self] response, error in
            if error != nil {
                Alert.showOneButtonAlert(message: LocalizedKey.Alert.locationNotFound.localized(), in: self)
                return
            }
            
            guard let place = response?.mapItems.first?.placemark else {
                Alert.showOneButtonAlert(message: LocalizedKey.Alert.locationNotFound.localized(), in: self)
                return
            }
            self?.drawDirection(to: place)
        }
    }
}

// MARK: Actions
extension CineMapViewController {
    @IBAction func searchWithCoordinate(_ sender: Any) {
        endEditing(true)
        guard let latString = latTextField.text, let lat = Double(latString),
              let lngString = lngTextField.text, let lng = Double(lngString) else {
            Alert.showOneButtonAlert(message: LocalizedKey.Alert.invalidLatLng.localized(), in: self)
            return }
        searchBar.text = nil
        drawDirection(to: CLLocationCoordinate2D(latitude: lat, longitude: lng))
    }
    
    @IBAction func clear(_ sender: Any) {
        resetMapView(withNew: nil)
        latTextField.text = nil
        lngTextField.text = nil
        searchBar.text = nil
        endEditing(true)
    }
}

// MARK: Search Bar delegates
extension CineMapViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        endEditing(true)
        guard let text = searchBar.text, !text.isEmpty else {
            Alert.showOneButtonAlert(message: LocalizedKey.Alert.invalidAddress.localized(), in: self)
            return
        }
        latTextField.text = nil
        lngTextField.text = nil
        findLocation(text)
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
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        default: break
        }
    }
}

// MARK: MapView delegates
extension CineMapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = .systemOrange.withAlphaComponent(0.8)
        return renderer
    }
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        let center = getCenterLocation()
        
        guard let previousLocation = self.previousLocation else { return }
        
        guard center.distance(from: previousLocation) > 50 else { return }
        self.previousLocation = center
        
        geoCoder.cancelGeocode()
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let coordinate = view.annotation?.coordinate else { return }
        delegate?.cineMap(self, didSelect: coordinate)
    }
}
