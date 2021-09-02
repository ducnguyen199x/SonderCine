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
            case .nowPlaying: return LocalizedKey.TabBar.nowPlaying.localized()
            case .topRated: return LocalizedKey.TabBar.topRated.localized()
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
