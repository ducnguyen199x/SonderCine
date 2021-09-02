//
//  BaseTabbarController.swift
//  SwipeTicket
//
//  Created by Nguyen Thanh Duc on 21/1/21.
//

import UIKit
import RxSwift
import RxCocoa
import NSObject_Rx
import SVProgressHUD
import TinyConstraints

#if DEBUG
import FLEX
#endif

class BaseTabbarController: UITabBarController {
    private weak var previousParent: UIViewController?
    
    deinit {
        debugPrint("Deinit \(type(of: self))")
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    override func didMove(toParent parent: UIViewController?) {
        super.didMove(toParent: parent)
        if previousParent != nil && parent == nil {
            willDeinit()
        }
        previousParent = parent
    }
    
    override func willMove(toParent parent: UIViewController?) {
        super.willMove(toParent: parent)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation()
        setupView()
        bindViewModel()
    }
    
    func setupView() {}
        
    func bindViewModel() { }
    
    func setupNavigation() {}
    
    func showDefaultAlert() {
        Alert.showOneButtonAlert(message: "Something went wrong!\nPlease try again.")
    }
        
    func willDeinit() {
        preconditionFailure("You should implement this function in your class to detach coordinator.")
    }
}
