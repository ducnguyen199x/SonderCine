//
//  Alert.swift
//  SwipeTicket
//
//  Created by Nguyen Thanh Duc on 19/1/21.
//

import UIKit

class Alert: UIAlertController {
    deinit {
        debugPrint("Deinit \(type(of: self))")
    }
    
    struct Config {
        var title: String?
        var message: String?
        var confirmButtonTitle: String?
        var confirmAction: (() -> Void)?
        var cancelButtonTitle: String?
        var cancelAction: (() -> Void)?
        var viewController: UIViewController?
    }
        
    class func showOneButtonAlert(_ title: String? = nil,
                                  message: String?,
                                  cancelButtonTitle: String = "OK",
                                  cancelAction: (() -> Void)? = nil,
                                  in viewController: UIViewController? = nil) {
        let alertController = Alert(title: title, message: message, preferredStyle: .alert)
        let alertCancelAction = UIAlertAction(title: cancelButtonTitle, style: .cancel, handler: { _ in cancelAction?() })
        alertController.addAction(alertCancelAction)
        handlePresent(alertController, in: viewController ?? UIApplication.topMostController())
    }

    @discardableResult
    class func showAlert(_ title: String? = nil,
                         message: String? = nil,
                         confirmButtonTitle: String? = nil,
                         confirmAction: (() -> Void)? = nil,
                         cancelButtonTitle: String? = nil,
                         cancelAction: (() -> Void)? = nil,
                         in viewController: UIViewController? = nil) -> UIAlertController {
        let alertController = Alert(title: title, message: message, preferredStyle: .alert)
      
        if let confirmButtonTitle = confirmButtonTitle {
            let alertConfirmAction = UIAlertAction(title: confirmButtonTitle, style: .destructive, handler: { _ in confirmAction?() })
            alertController.addAction(alertConfirmAction)
        }
        if let cancelButtonTitle = cancelButtonTitle {
            let alertCancelAction = UIAlertAction(title: cancelButtonTitle, style: .cancel, handler: { _ in cancelAction?() })
            alertController.addAction(alertCancelAction)
        }
        handlePresent(alertController, in: viewController ?? UIApplication.topMostController())
        return alertController
    }
    
    @discardableResult
    class func showAlert(with config: Config) -> UIAlertController {
        let alertController = Alert(title: config.title, message: config.message, preferredStyle: .alert)
     
        if let confirmButtonTitle = config.confirmButtonTitle {
            let alertConfirmAction = UIAlertAction(title: confirmButtonTitle, style: .destructive, handler: { _ in config.confirmAction?() })
            alertController.addAction(alertConfirmAction)
        }
        if let cancelButtonTitle = config.cancelButtonTitle {
            let alertCancelAction = UIAlertAction(title: cancelButtonTitle, style: .cancel, handler: { _ in config.cancelAction?() })
            alertController.addAction(alertCancelAction)
        }
        handlePresent(alertController, in: config.viewController ?? UIApplication.topMostController())
        return alertController
    }
    
    private class func handlePresent(_ alerVC: UIAlertController, in viewController: UIViewController?) {
        let vc = viewController ?? UIApplication.topMostController()
        DispatchQueue.main.async {
            vc?.present(alerVC, animated: true, completion: nil)
        }
    }
    
    @discardableResult
    class func showAlertWithPromt(_ title: String? = nil,
                                  message: String? = nil,
                                  placeholder: String? = nil,
                                  confirmButtonTitle: String,
                                  confirmAction: ((String) -> Void)? = nil,
                                  cancelButtonTitle: String,
                                  cancelAction: (() -> Void)? = nil,
                                  in viewController: UIViewController? = nil) -> UIAlertController {
        let alertController = Alert(title: title, message: message, preferredStyle: .alert)
        
        let alertConfirmAction = UIAlertAction(title: confirmButtonTitle, style: .default, handler: { _ in
            guard let textField = alertController.textFields?.first, let input = textField.text else { return }
            alertController.endEditing(true)
            confirmAction?(input)
        })
        alertController.addAction(alertConfirmAction)
        
        let alertCancelAction = UIAlertAction(title: cancelButtonTitle, style: .cancel, handler: { _ in cancelAction?() })
        alertController.addAction(alertCancelAction)
        
        alertController.addTextField { textField in
            textField.rx.text.map { !($0?.isEmpty ?? true) }
                .bind(to: alertConfirmAction.rx.isEnabled)
                .disposed(by: alertController.rx.disposeBag)
            textField.placeholder = placeholder
        }
        
        handlePresent(alertController, in: viewController)
        return alertController
    }
}
