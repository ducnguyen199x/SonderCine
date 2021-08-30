//
//  CineMapViewController.swift
//  SonderCine
//
//  Created by Nguyen Thanh Duc on 30/8/21.
//

import UIKit
import GoogleMaps

protocol CineMapViewControllerDelegate: ViewControllerDelegate {}

final class CineMapViewController: BaseViewController {
    var viewModel: CineMapViewModel!
    weak var delegate: CineMapViewControllerDelegate?
    
    override func setupView() {
        super.setupView()
        
        // Create a GMSCameraPosition that tells the map to display the
        // coordinate -33.86,151.20 at zoom level 6.
        let camera = GMSCameraPosition.camera(withLatitude: -33.86, longitude: 151.20, zoom: 6.0)
        let mapView = GMSMapView.map(withFrame: self.view.frame, camera: camera)
        self.view.addSubview(mapView)
        
        // Creates a marker in the center of the map.
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: -33.86, longitude: 151.20)
        marker.title = "Sydney"
        marker.snippet = "Australia"
        marker.map = mapView
    }
    
    override func willDeinit() {
        delegate?.viewControllerWillDeinit()
    }
}
