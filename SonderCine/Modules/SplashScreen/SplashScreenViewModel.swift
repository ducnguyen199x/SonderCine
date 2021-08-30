//
//  SplashScreenViewModel.swift
//  SonderCine
//
//  Created by Nguyen Thanh Duc on 25/8/21.
//

import RxSwift
import RxCocoa

final class SplashScreenViewModel: BaseViewModel {
    
    func fetchData() {
        if NetworkManager.shared.connection == .notReachable {
            state = .error(NetworkError.noNetwork)
            return
        }
        
        state = .loading(nil)
        Completable.empty().delay(.seconds(1), scheduler: MainScheduler.instance)
            .subscribe(onCompleted: { [weak self] in
                self?.state = .completed
            }).disposed(by: rx.disposeBag)
    }
}
