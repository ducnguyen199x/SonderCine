//
//  CineMapViewModel.swift
//  SonderCine
//
//  Created by Nguyen Thanh Duc on 30/8/21.
//

import Foundation

final class CineMapViewModel: BaseViewModel {
    @Relay var coordinate: Coordinate = LocationManager.shared.currentCoordinate
    
    override init() {
        super.init()
        LocationManager.shared.updateLocation()
    }
    
    override func bind() {
        rx.disposeBag.insert([
            LocationManager.shared.$currentCoordinate.bind(to: $coordinate)
        ])
    }
}
