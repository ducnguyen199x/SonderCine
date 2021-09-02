//
//  BaseViewModel.swift
//
//  Created by Nguyen Thanh Duc on 20/1/21.
//

import RxSwift
import RxCocoa

public enum ViewModelState: Equatable {
    case idle
    case loading(String?)
    case progress(Float, String?)
    case completed
    case error(Error)

    public static func == (lhs: Self, rhs: Self) -> Bool {
        if case .idle = lhs, case .idle = rhs {
            return true
        } else if case .loading(let lhsStr) = lhs, case .loading(let rhsStr) = rhs {
            return lhsStr == rhsStr
        } else if case .progress(_, let lhsStr) = lhs, case .progress(_, let rhsStr) = rhs {
            return lhsStr == rhsStr
        } else if case .completed = lhs, case .completed = rhs {
            return true
        } else if case .error(let lhsStr) = lhs, case .error(let rhsStr) = rhs {
            return lhsStr.code == rhsStr.code
        }
        return false
    }
    
    var isLoading: Bool {
        switch self {
        case .loading, .progress: return true
        default: return false
        }
    }
}

class BaseViewModel: NSObject {
    @Relay var state: ViewModelState = .idle
    
    deinit {
        debugPrint("Deinit \(type(of: self))")
    }
    
    override init() {
        super.init()
        self.bind()
    }

    func bind() {}
}
