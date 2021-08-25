//
//  UIActivityIndicator+Extensions.swift
//
//  Created by Nguyen Thanh Duc on 20/1/21.
//

import UIKit
import SVProgressHUD
import RxSwift
import RxCocoa

extension Reactive where Base: UIActivityIndicatorView {
    /// Bindable sink for `startAnimating()`, `stopAnimating()` methods.
    public var isAnimating: Binder<Bool> {
        Binder(self.base) { activityIndicator, active in
            if active {
                activityIndicator.startAnimating()
            } else {
                activityIndicator.stopAnimating()
            }
        }
    }
}

extension Reactive where Base: SVProgressHUD {
    /// Bindable sink for `startAnimating()`, `stopAnimating()` methods.
    public var isAnimating: Binder<Bool> {
        Binder(self.base) { _, active in
            if active {
                SVProgressHUD.show()
            } else {
                SVProgressHUD.dismiss()
            }
        }
    }
    
    public var viewModelAnimating: Binder<ViewModelState> {
        Binder(self.base) { _, state in
            switch state {
            case .idle:
                SVProgressHUD.dismiss()
            case .loading(let status):
                SVProgressHUD.show(withStatus: status)
            case .progress(let progress, let status):
                SVProgressHUD.showProgress(progress, status: status)
            case .completed:
                SVProgressHUD.dismiss()
            case .error(let error):
                if let localizedError = error as? LocalizedError {
                    SVProgressHUD.showError(withStatus: localizedError.localizedDescription)
                } else {
                    SVProgressHUD.showError(withStatus: error.localizedDescription)
                }
            }
        }
    }
}
