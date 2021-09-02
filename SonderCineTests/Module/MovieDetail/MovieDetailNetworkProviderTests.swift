//
//  MovieDetailNetworkProviderTests.swift
//  SonderCineTests
//
//  Created by Nguyen Thanh Duc on 2/9/21.
//

import XCTest
import RxSwift
import RxCocoa
@testable import SonderCine

class MovieDetailNetworkProviderTests: XCTestCase {

    override func setUpWithError() throws {}

    override func tearDownWithError() throws {}

    func testFetchDetail_success() {
        let networkProvider = MovieDetailNetworkClient()
        let expected = expectation(description: "Should be able to retreive and parse Movie & Credit")
        networkProvider.fetchDetailAndCredit(id: 436969, shouldUseCache: false).subscribe(onSuccess: { _ in
            expected.fulfill()
        }).disposed(by: rx.disposeBag)
        
        wait(for: [expected], timeout: 5)
    }
    
    func testFetchDetail_fail() {
        let networkProvider = MovieDetailNetworkClient()
        let expected = expectation(description: "Should throws error")
        networkProvider.fetchDetailAndCredit(id: 1, shouldUseCache: false).subscribe(onFailure: { _ in
            expected.fulfill()
        }).disposed(by: rx.disposeBag)
        
        wait(for: [expected], timeout: 5)
    }
}
