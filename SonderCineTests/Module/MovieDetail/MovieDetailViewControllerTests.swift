//
//  MovieDetailViewControllerTests.swift
//  SonderCineTests
//
//  Created by Nguyen Thanh Duc on 2/9/21.
//

import Foundation
import XCTest
import RxSwift
import RxCocoa
@testable import SonderCine

class MovieDetailViewControllerTests: XCTestCase {
    override func setUpWithError() throws {}

    override func tearDownWithError() throws {}
    
    func testTableView_numberOfRows() {
        let viewController = MovieDetailViewController.instantiate()
        let viewModel = MovieDetailViewModel(id: 123)
        viewController.viewModel = viewModel
        _ = viewController.view
        viewModel.items = [.heroMedia(path: ""),
                           .synopsis(MockData.synopsis()),
                           .description(""),
                           .credit(MockData.movieCredit()!)]
        let numberOfRows = viewController.tableView.numberOfRows(inSection: 0)
        XCTAssertEqual(viewModel.numberOfRows(), numberOfRows)
    }
    
    func testTableView_dequeueHeroCell() {
        let viewController = MovieDetailViewController.instantiate()
        let viewModel = MovieDetailViewModel(id: 123)
        viewController.viewModel = viewModel
        _ = viewController.view
        viewModel.items = [.heroMedia(path: "")]
        let cell = viewController.tableView.cellForRow(at: IndexPath(row: 0, section: 0))
        XCTAssertTrue(cell is HeroCell)
    }
    
    func testTableView_dequeueSynopsisCell() {
        let viewController = MovieDetailViewController.instantiate()
        let viewModel = MovieDetailViewModel(id: 123)
        viewController.viewModel = viewModel
        _ = viewController.view
        viewModel.items = [.synopsis(MockData.synopsis())]
        let cell = viewController.tableView.cellForRow(at: IndexPath(row: 0, section: 0))
        XCTAssertTrue(cell is SynopsisCell)
    }
    
    func testTableView_dequeueDescriptionCell() {
        let viewController = MovieDetailViewController.instantiate()
        let viewModel = MovieDetailViewModel(id: 123)
        viewController.viewModel = viewModel
        _ = viewController.view
        viewModel.items = [.description("description")]
        let cell = viewController.tableView.cellForRow(at: IndexPath(row: 0, section: 0))
        XCTAssertTrue(cell is DescriptionCell)
    }
    
    func testTableView_dequeueCreditCell() {
        let viewController = MovieDetailViewController.instantiate()
        let viewModel = MovieDetailViewModel(id: 123)
        viewController.viewModel = viewModel
        _ = viewController.view
        viewModel.items = [.credit(MockData.movieCredit()!)]
        let cell = viewController.tableView.cellForRow(at: IndexPath(row: 0, section: 0))
        XCTAssertTrue(cell is CreditsCell)
    }
}
