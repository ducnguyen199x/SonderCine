//
//  MovieDetailTest.swift
//  SonderCineTests
//
//  Created by Nguyen Thanh Duc on 1/9/21.
//

import Foundation
import XCTest
import RxSwift
import RxCocoa

@testable import SonderCine

class MockMovieDetailNetworkClient: MovieDetailNetworkProvider {
    var didFetch = false
    
    func fetchDetailAndCredit(id: Int, shouldUseCache: Bool) -> Single<(Movie, Credit?)> {
        didFetch = true
        return .just((MockData.movie(), MockData.movieCredit()))
    }
}

class MovieDetailViewModelTests: XCTestCase {
    override func setUpWithError() throws {}

    override func tearDownWithError() throws {}
    
    func testInit() {
        let viewModel = MovieDetailViewModel(id: 123)
        XCTAssertEqual(viewModel.id, 123)
    }

    func testFetchDetail() {
        let mockNetworkClient = MockMovieDetailNetworkClient()
        let viewModel = MovieDetailViewModel(networkProvider: mockNetworkClient, id: 123)
        viewModel.fetchDetail()
        XCTAssertTrue(mockNetworkClient.didFetch)
    }
    
    func testMakeItems() {
        let viewModel = MovieDetailViewModel(id: 123)
        viewModel.makeItems(MockData.movie(), credit: MockData.movieCredit())
        XCTAssertEqual(viewModel.items.count, 4)
        for (index, item) in viewModel.items.enumerated() {
            if index == 0, case .heroMedia = item {
                continue
            } else if index == 1, case .synopsis = item {
                continue
            } else if index == 2, case .description = item {
                continue
            } else if index == 3, case .credit = item {
                continue
            }
            XCTFail("Incorrect type at index: \(index)")
        }
    }
    
    func testMakeItems_creditIsNil() {
        let viewModel = MovieDetailViewModel(id: 123)
        viewModel.makeItems(MockData.movie(), credit: nil)
        XCTAssertEqual(viewModel.items.count, 3)
        for (index, item) in viewModel.items.enumerated() {
            if index == 0, case .heroMedia = item {
                continue
            } else if index == 1, case .synopsis = item {
                continue
            } else if index == 2, case .description = item {
                continue
            }
            XCTFail("Incorrect type at index: \(index)")
        }
    }
    
    func testNumberOfRows() {
        let viewModel = MovieDetailViewModel(id: 123)
        viewModel.items = []
        XCTAssertEqual(viewModel.numberOfRows(), 0)
        viewModel.items = [.description("description"), .heroMedia(path: "path")]
        XCTAssertEqual(viewModel.numberOfRows(), 2)
    }
    
    func testItemAt_indexOutOfBound() {
        let viewModel = MovieDetailViewModel(id: 123)
        viewModel.items = [.description("description"), .heroMedia(path: "path")]
        let item = viewModel.item(at: IndexPath(row: 10, section: 0))
        XCTAssertNil(item)
    }
}
