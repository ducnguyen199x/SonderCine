//
//  TabContentCoordinator.swift
//  SwipeTicket
//
//  Created by Nguyen Thanh Duc on 21/1/21.
//

import UIKit

protocol TabContentCoordinatorDelegate: CoordinatorDelegate { }

class TabContentCoordinator: Coordinator {
    enum TabType {
        case nowPlaying
        case topRated
        
        var title: String {
            switch self {
            case .nowPlaying: return "Now Playing"
            case .topRated: return "Top Rated"
            }
        }
        
        var icon: UIImage? {
            switch self {
            case .nowPlaying: return .nowPlaying
            case .topRated: return .topRated
            }
        }
    }
    
    var tabType: TabType = .nowPlaying
    weak var delegate: TabContentCoordinatorDelegate?
}
