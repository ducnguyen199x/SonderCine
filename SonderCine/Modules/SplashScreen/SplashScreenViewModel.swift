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
        state = .loading(nil)
        Completable.empty().delay(.milliseconds(500), scheduler: MainScheduler.instance)
            .subscribe(onCompleted: { [weak self] in
                self?.state = .completed
            }).disposed(by: rx.disposeBag)
    }
}
