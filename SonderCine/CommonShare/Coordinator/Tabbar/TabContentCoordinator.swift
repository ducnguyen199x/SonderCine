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
        case item1
        
        var title: String {
            switch self {
            case .item1: return "Item 1"
            }
        }
        
        var icon: UIImage {
            switch self {
            case .item1: return UIImage()
            }
        }
    }
    
    var tabType: TapType = .item1
    weak var delegate: TabContentCoordinatorDelegate?
}

