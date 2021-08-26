//
//  MovieListingViewModel.swift
//  SonderCine
//
//  Created by Nguyen Thanh Duc on 26/8/21.
//

import Foundation

final class MovieListingViewModel: BaseViewModel {
    enum Category {
        case nowPlaying
        case topRated
    }
    
    let category: Category
    
    init(category: Category) {
        self.category = category
    }
}
