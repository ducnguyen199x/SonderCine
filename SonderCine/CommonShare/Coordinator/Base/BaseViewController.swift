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
        observeOrientation()
        observeLanguageChanged()
        bindViewModel()
    }
    
    func setupTitle() {}
    
    func setupView() {}
    
    func setupColor() {}
    
    func bindViewModel() {}
    
    func setupNavigation() {
        navigationController?.makeTranslucentNavigationBar()
    }
    
    func addSettingsBarItem() {
        let settingsButton = UIBarButtonItem(image: .settings,
                                             style: .plain,
                                             target: self,
                                             action: #selector(settingsTapped))
        navigationItem.setRightBarButton(settingsButton, animated: true)
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    func languageChanged() {
        localizedText()
    }
    
    func authenticationChanged() {}
    
    func localizedText() {}
        
    @objc func settingsTapped() {}
    
    func observeOrientation() {
        NotificationCenter.default.rx
            .notification(UIDevice.orientationDidChangeNotification)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                self?.didChangeOrientation()
            }).disposed(by: rx.disposeBag)
    }
    
    func observeLanguageChanged() {
        NotificationCenter.default.rx
            .notification(.languageChanged)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                self?.languageChanged()
            }).disposed(by: rx.disposeBag)
    }
    
    func showDefaultAlert() {
        Alert.showOneButtonAlert(message: "Something went wrong!\nPlease try again.", in: self)
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
