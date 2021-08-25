//
//  TabContentCoordinator.swift
//  SwipeTicket
//
//  Created by Nguyen Thanh Duc on 21/1/21.
//

import UIKit

protocol TabContentCoordinatorDelegate: CoordinatorDelegate { }

class TabContentCoordinator: Coordinator {
    enum TapType {
        case nowPlaying
        
        var title: String {
            switch self {
            case .nowPlaying: return "Now Playing"
            }
        }
        
        var icon: UIImage {
            switch self {
            case .nowPlaying: return UIImage()
            }
        }
    }
    
    var tabType: TapType = .nowPlaying
    weak var delegate: TabContentCoordinatorDelegate?
}

