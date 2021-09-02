//
//  MovieListingTest.swift
//  SonderCineTests
//
//  Created by Nguyen Thanh Duc on 1/9/21.
//

import Foundation
import XCTest
import RxSwift
import RxCocoa

@testable import SonderCine

class MockMovieListNetworkClient: MovieListNetworkProvider {
    var didFetchNowPlaying = false
    var didFetchTopRated = false
    
    func fetchNowPlaying(page: Int, shouldUseCache: Bool) -> Single<MovieListWrapper> {
        didFetchNowPlaying = true
        let mock = MockData.movieListWrapperOneItem()!
        return .just(mock)
    }
    
    func fetchTopRated(page: Int, shouldUseCache: Bool) -> Single<MovieListWrapper> {
        didFetchTopRated = true
        return .error(NetworkError.cancelled)
    }
}

class MovieListingViewModelTests: XCTestCase {
    override func setUpWithError() throws {}

    override func tearDownWithError() throws {}
    
    func testInit_nowPlaying() {
        let viewModel = MovieListingViewModel(category: .nowPlaying)
        XCTAssertEqual(viewModel.category, .nowPlaying)
    }
    
    func testInit_topRated() {
        let viewModel = MovieListingViewModel(category: .topRated)
        XCTAssertEqual(viewModel.category, .topRated)
    }

    func testFetchMovieList_nowPlaying() {
        let mockNetworkClient = MockMovieListNetworkClient()
        let viewModel = MovieListingViewModel(networkProvider: mockNetworkClient, category: .nowPlaying)
        viewModel.fetchMovieList(page: 1, shouldUseCache: true)
        XCTAssertEqual(viewModel.currentPage, 1)
        XCTAssertTrue(mockNetworkClient.didFetchNowPlaying)
    }
    
    func testFetchMovieList_topRated() {
        let mockNetworkClient = MockMovieListNetworkClient()
        let viewModel = MovieListingViewModel(networkProvider: mockNetworkClient, category: .topRated)
        viewModel.fetchMovieList(page: 1, shouldUseCache: true)
        XCTAssertEqual(viewModel.currentPage, 1)
        XCTAssertTrue(mockNetworkClient.didFetchTopRated)
    }
    
    func testRefreshCurrentPage() {
        let mockNetworkClient = MockMovieListNetworkClient()
        let viewModel = MovieListingViewModel(networkProvider: mockNetworkClient, category: .nowPlaying)
        viewModel.currentPage = 4
        viewModel.refreshCurrentPage()
        XCTAssertEqual(viewModel.currentPage, 4)
        XCTAssertTrue(mockNetworkClient.didFetchNowPlaying)
    }
    
    func testMakeItems_oneItem() {
        let viewModel = MovieListingViewModel(category: .nowPlaying)
        let mock = MockData.movieListWrapperOneItem()!
        viewModel.makeItems(mock)
        XCTAssertEqual(viewModel.items.count, 2)
        for (index, item) in viewModel.items.enumerated() {
            switch index {
            case 0:
                if case .ads = item {
                    XCTFail("Index 0 should be Movie")
                } else if case .pagination = item {
                    XCTFail("Index 0 should be Movie")
                }
            case 1 :
                if case .ads = item {
                    XCTFail("Index 1 should be Pagination")
                } else if case .movie = item {
                    XCTFail("Index 1 should be Pagination")
                }
            default: break
            }
        }
    }
    
    func testMakeItems_threeItems() {
        let viewModel = MovieListingViewModel(category: .nowPlaying)
        let mock = MockData.movieListWrapperThreeItem()!
        viewModel.makeItems(mock)
        XCTAssertEqual(viewModel.items.count, 5)
        for (index, item) in viewModel.items.enumerated() {
            switch index {
            case 0...2:
                if case .ads = item {
                    XCTFail("Index 0 should be Movie")
                } else if case .pagination = item {
                    XCTFail("Index 0 should be Movie")
                }
            case 3:
                if case .movie = item {
                    XCTFail("Index 3 should be Ads")
                } else if case .pagination = item {
                    XCTFail("Index 3 should be Ads")
                }
            case 4 :
                if case .ads = item {
                    XCTFail("Index 4 should be Pagination")
                } else if case .movie = item {
                    XCTFail("Index 4 should be Pagination")
                }
            default: break
            }
        }
    }
    
    func testNumberOfRows() {
        let viewModel = MovieListingViewModel(category: .nowPlaying)
        viewModel.items = []
        XCTAssertEqual(viewModel.numberOfRows(), 0)
        viewModel.items = [.ads, .ads]
        XCTAssertEqual(viewModel.numberOfRows(), 2)
    }
    
    func testItemAt_indexOutOfBound() {
        let viewModel = MovieListingViewModel(category: .nowPlaying)
        let mock = MockData.movieListWrapperThreeItem()!
        viewModel.makeItems(mock)
        let item = viewModel.item(at: IndexPath(row: 10, section: 0))
        XCTAssertNil(item)
    }
}
