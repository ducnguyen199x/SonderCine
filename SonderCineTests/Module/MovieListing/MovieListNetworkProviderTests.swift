//
//  MovieListNetworkProviderTests.swift
//  SonderCineTests
//
//  Created by Nguyen Thanh Duc on 2/9/21.
//

import XCTest
@testable import SonderCine
import RxSwift
import RxCocoa

class MovieListNetworkProviderTests: XCTestCase {

    override func setUpWithError() throws {}

    override func tearDownWithError() throws {}

    func testFetchNowPlaying() {
        let networkProvider = MovieListNetworkClient()
        let expected = expectation(description: "Should be able to retreive and parse MovieListWrapper")
        networkProvider.fetchNowPlaying(page: 1, shouldUseCache: false).subscribe(onSuccess: { _ in
            expected.fulfill()
        }).disposed(by: rx.disposeBag)
        
        wait(for: [expected], timeout: 5)
    }
    
    func testFetchTopRated() {
        let networkProvider = MovieListNetworkClient()
        let expected = expectation(description: "Should be able to retreive and parse MovieListWrapper")
        networkProvider.fetchTopRated(page: 1, shouldUseCache: false).subscribe(onSuccess: { _ in
            expected.fulfill()
        }).disposed(by: rx.disposeBag)
        
        wait(for: [expected], timeout: 5)
    }
}
