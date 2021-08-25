//
//  Reactive+Extensions.swift
//
//  Created by Nguyen Thanh Duc on 20/1/21.
//

import RxSwift
import RxCocoa

extension Reactive where Base: UICollectionView {
    func items<Sequence: Swift.Sequence, Cell: UICollectionViewCell, Source: ObservableType>
        (_ cellClass: Cell.Type)
        -> (_ source: Source)
        -> (_ configureCell: @escaping (Int, Sequence.Element, Cell) -> Void)
        -> Disposable
        where Source.Element == Sequence {
            return items(cellIdentifier: cellClass.string(), cellType: cellClass)
    }
}

extension Reactive where Base: UITableView {
    func items<Sequence: Swift.Sequence, Cell: UITableViewCell, Source: ObservableType>
        (_ cellClass: Cell.Type)
        -> (_ source: Source)
        -> (_ configureCell: @escaping (Int, Sequence.Element, Cell) -> Void)
        -> Disposable
        where Source.Element == Sequence {
            return items(cellIdentifier: cellClass.string(), cellType: cellClass)
    }
    
    public var contentSizeObservable: Observable<CGSize?> {
        return base.rx.observe(CGSize.self, "contentSize")
    }
}

extension Reactive where Base: UIBarButtonItem {
    var isEnabled: Binder<Bool> {
        return Binder(self.base) { barButtonItem, isEnabled in
            barButtonItem.isEnabled = isEnabled
        }
    }
}
