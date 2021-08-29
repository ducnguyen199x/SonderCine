//
//  CreditsListingViewModel.swift
//  SonderCine
//
//  Created by Nguyen Thanh Duc on 29/8/21.
//

import Foundation

final class CreditsListingViewModel: BaseViewModel {
    enum FilterType {
        case cast, crew
    }
    
    private var credit: Credit
    @Relay var filteredCredits = [CastOrCrew]()
    @Relay var filterType: FilterType = .cast {
        didSet {
            updateFilteredList()
        }
    }
    
    init(credit: Credit) {
        self.credit = credit
    }
    
    func fetchData() {
        updateFilteredList()
    }
    
    func numberOfRows() -> Int {
        filteredCredits.count
    }
    
    func item(at indexPath: IndexPath) -> CastOrCrew? {
        filteredCredits[safe: indexPath.row]
    }
    
    private func updateFilteredList() {
        filteredCredits = filterType == .cast ? credit.cast ?? [] : credit.crew ?? []
    }
}
