//
//  UITableView+Extensions.swift
//
//  Created by Nguyen Thanh Duc on 20/1/21.
//

import UIKit
import RxSwift

extension UITableView {
    func dequeueReusableCell<Cell: UITableViewCell>(for indexPath: IndexPath) -> Cell {
        guard let cell = dequeueReusableCell(withIdentifier: Cell.reuseIdentifier, for: indexPath) as? Cell else {
            fatalError("Unable to Dequeue View Cell")
        }
        return cell
    }
    
    func dequeueHeaderFooterView<Cell: UITableViewHeaderFooterView>(_: Cell.Type) -> Cell {
        guard let header = dequeueReusableHeaderFooterView(withIdentifier: Cell.reuseIdentifier) as? Cell else {
            fatalError("Unable to Dequeue View Cell")
        }
        return header
    }
    
    func registerNib<Cell: UITableViewCell>(_: Cell.Type) {
        let nib = UINib(nibName: Cell.nibName, bundle: nil)
        register(nib, forCellReuseIdentifier: Cell.reuseIdentifier)
    }
    
    func registerHeaderFooter<Cell: UITableViewHeaderFooterView>(_: Cell.Type) {
        let nib = UINib(nibName: Cell.nibName, bundle: nil)
        register(nib, forHeaderFooterViewReuseIdentifier: Cell.reuseIdentifier)
    }
    
    func registerHeaderFooterClass<Cell: UITableViewHeaderFooterView>(_: Cell.Type) {
        register(Cell.self, forHeaderFooterViewReuseIdentifier: Cell.reuseIdentifier)
    }
    
    func registerClass<Cell: UITableViewCell>(_: Cell.Type) {
        register(Cell.self, forCellReuseIdentifier: Cell.reuseIdentifier)
    }
}

extension UITableView {
    enum IndexPathPosition {
        case firstInSection
        case middle
        case lastInSection
        case onlyItem
        case invalid
    }
    
    func position(of indexPath: IndexPath) -> IndexPathPosition {
        let numberOfItemInCurrentSection = numberOfRows(inSection: indexPath.section)
        guard indexPath.row >= 0 && indexPath.row < numberOfItemInCurrentSection else { return .invalid }
        
        if numberOfItemInCurrentSection == 1 { return .onlyItem }
        
        if indexPath.row == 0 { return .firstInSection }
        
        if indexPath.row == numberOfItemInCurrentSection - 1 { return .lastInSection }
        
        return .middle
    }
}
