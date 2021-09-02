//
//  MovieListingViewControllerTests.swift
//  SonderCineTests
//
//  Created by Nguyen Thanh Duc on 2/9/21.
//

import Foundation
import XCTest
import RxSwift
import RxCocoa

@testable import SonderCine

class MockMovieListingCoordinator: Coordinator, MovieListingViewControllerDelegate {
    var didTapMovieCalled = false
    
    func movieListing(_ sender: MovieListingViewController, didTap movie: Movie) {
        didTapMovieCalled = true
    }
    
    func settingsTapped(_ sender: UIViewController) {}
}

class MovieListingViewControllerTests: XCTestCase {
    override func setUpWithError() throws {}

    override func tearDownWithError() throws {}
    
    func testTableView_numberOfRows() {
        let viewController = MovieListingViewController.instantiate()
        let viewModel = MovieListingViewModel(category: .nowPlaying)
        viewController.viewModel = viewModel
        _ = viewController.view
        viewModel.items = [.movie(MockData.movie()),
                           .movie(MockData.movie()),
                           .movie(MockData.movie()),
                           .ads,
                           .pagination(MockData.paging())]
        let numberOfRows = viewController.tableView.numberOfRows(inSection: 0)
        XCTAssertEqual(viewModel.numberOfRows(), numberOfRows)
    }
    
    func testTableView_dequeueMovieCell() {
        let viewController = MovieListingViewController.instantiate()
        let viewModel = MovieListingViewModel(category: .nowPlaying)
        viewController.viewModel = viewModel
        _ = viewController.view
        viewModel.items = [.movie(MockData.movie())]
        let cell = viewController.tableView.cellForRow(at: IndexPath(row: 0, section: 0))
        XCTAssertTrue(cell is MovieCell)
    }
    
    func testTableView_dequeueAdsCell() {
        let viewController = MovieListingViewController.instantiate()
        let viewModel = MovieListingViewModel(category: .nowPlaying)
        viewController.viewModel = viewModel
        _ = viewController.view
        viewModel.items = [.ads]
        let cell = viewController.tableView.cellForRow(at: IndexPath(row: 0, section: 0))
        XCTAssertTrue(cell is AdsCell)
    }
    
    func testTableView_dequeuePaginationCell() {
        let viewController = MovieListingViewController.instantiate()
        let viewModel = MovieListingViewModel(category: .nowPlaying)
        viewController.viewModel = viewModel
        _ = viewController.view
        viewModel.items = [.pagination(MockData.paging())]
        let cell = viewController.tableView.cellForRow(at: IndexPath(row: 0, section: 0))
        XCTAssertTrue(cell is PaginationCell)
    }
    
    func testTableView_selectMovieCell() {
        let viewController = MovieListingViewController.instantiate()
        let viewModel = MovieListingViewModel(category: .nowPlaying)
        let delegate = MockMovieListingCoordinator()
        viewController.delegate = delegate
        viewController.viewModel = viewModel
        _ = viewController.view
        viewModel.items = [.movie(MockData.movie())]
        viewController.tableView(viewController.tableView, didSelectRowAt: IndexPath(row: 0, section: 0))
        XCTAssertTrue(delegate.didTapMovieCalled)
    }
}
