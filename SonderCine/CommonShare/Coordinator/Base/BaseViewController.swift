//
//  BaseViewController.swift
//
//  Created by Nguyen Thanh Duc on 20/1/21.
//

import UIKit
import RxSwift
import RxCocoa
import NSObject_Rx
import SVProgressHUD
import TinyConstraints

#if DEBUG
import AVKit
import FLEX
#endif

protocol BaseProtocol {
    func setupView()
}

class BaseViewController: UIViewController {
    var controllerTitle: String?
  
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
        setupTitle()
        super.viewDidLoad()
        setupNavigation()
        setupView()
        setupColor()
        localizedText()
        observerOrientation()
        bindViewModel()
    }
    
    func setupTitle() {}
    
    func setupView() {}
    
    func setupColor() {}
    
    func bindViewModel() {}
    
    func setupNavigation() {
        navigationController?.makeTranslucentNavigationBar()
    }
    
    func languageChanged() {
        localizedText()
    }
    
    func authenticationChanged() {}
    
    func localizedText() {}
    
    func observerOrientation() {
        NotificationCenter.default.rx
            .notification(UIDevice.orientationDidChangeNotification)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                self?.didChangeOrientation()
            }).disposed(by: rx.disposeBag)
    }
    
    func showDefaultAlert() {
        Alert.showOneButtonAlert(message: "Something went wrong!\nPlease try again.")
    }
    
    func didChangeOrientation() {}
    
    func willDeinit() {
        preconditionFailure("You should implement this function in your class to detach coordinator.")
    }
}

// MARK: Navigations
extension BaseViewController {
    override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        if let presentedViewController = presentedViewController {
            presentedViewController.dismiss(animated: flag, completion: completion)
        } else {
            super.dismiss(animated: flag, completion: completion)
            if let navigationController = navigationController {
                navigationController.viewControllers.first?.didMove(toParent: nil)
            } else {
                self.didMove(toParent: nil)
            }
        }
    }
}
