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
    #if DEBUG
    private weak var observer: NSKeyValueObservation?
    private var hitCount: Int = 0
    private var audioSession: AVAudioSession?
    #endif
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
        #if DEBUG
        observeVolumeChanged()
        #endif
        bindViewModel()
    }
    
    func setupTitle() {}
    
    func setupView() {}
    
    func setupColor() {}
    
    func bindViewModel() {
        
    }
    
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
            .observeOn(MainScheduler.instance)
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
    
    #if DEBUG
    final func observeVolumeChanged() {
        audioSession = AVAudioSession.sharedInstance()
        observer = audioSession?.observe( \.outputVolume ) {[weak self] (_, _) in
            guard FLEXManager.shared.isHidden else {
                self?.hitCount = 0
                return
            }
            self?.hitCount += 1
            guard self?.hitCount == 3 else { return }
            self?.hitCount = 0
            FLEXManager.shared.showExplorer()
        }
    }
    #endif
}

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
