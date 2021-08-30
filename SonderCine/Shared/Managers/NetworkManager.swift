//
//  NetworkManager.swift
//  SonderCine
//
//  Created by Nguyen Thanh Duc on 30/8/21.
//

import Foundation
import Alamofire

class NetworkManager: NSObject {
    static let shared = NetworkManager()
    let reachability = NetworkReachabilityManager()
    @Relay var connection: NetworkReachabilityManager.NetworkReachabilityStatus = .unknown
    
    func startNetworkConnectionObserver() {
        reachability?.startListening(onUpdatePerforming: { status in
            self.connection = status
        })
    }
}
