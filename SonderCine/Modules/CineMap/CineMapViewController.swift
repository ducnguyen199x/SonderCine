//
//  CineMapViewController.swift
//  SonderCine
//
//  Created by Nguyen Thanh Duc on 30/8/21.
//

import UIKit
import GoogleMaps
import GooglePlaces

protocol CineMapViewControllerDelegate: ViewControllerDelegate {}

final class CineMapViewController: BaseViewController {
    var viewModel: CineMapViewModel!
    weak var delegate: CineMapViewControllerDelegate?
    
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var myPositionButton: UIButton!

    override func setupView() {
        super.setupView()
        myPositionButton.setImage(.currentPosition?.resized(to: CGSize(width: 50, height: 50))
                                    .withTintColor(.systemRed, renderingMode: .alwaysOriginal), for: .normal)
        myPositionButton.layer.cornerRadius = 25
        myPositionButton.layer.shadowOpacity = 0.8
        myPositionButton.layer.shadowOffset = CGSize(width: 0, height: 0)
        myPositionButton.backgroundColor = .white
    }
    
    override func bindViewModel() {
        super.bindViewModel()
        rx.disposeBag.insert([
            viewModel.$coordinate.subscribe(onNext: { [weak self] _ in
                self?.updateMap()
            })
        ])
    }
        
    private func updateMap() {
        let camera = GMSCameraPosition.camera(withLatitude: viewModel.coordinate.lat,
                                              longitude: viewModel.coordinate.lng, zoom: 17)
        mapView.camera = camera
    }
    
    override func willDeinit() {
        delegate?.viewControllerWillDeinit()
    }
}

extension CineMapViewController {
    @IBAction func myPositionTapped(_ sender: UIButton) {
        updateMap()
    }
}
