//
//  UICollectionView+Extensions.swift
//
//  Created by Nguyen Thanh Duc on 20/1/21.
//

import UIKit

extension UICollectionView {
    func dequeueReusableCell<Cell: UICollectionViewCell>(for indexPath: IndexPath) -> Cell {
        guard let cell = dequeueReusableCell(withReuseIdentifier: Cell.reuseIdentifier, for: indexPath) as? Cell else {
            fatalError("Unable to Dequeue View Cell")
        }
        return cell
    }
    
    func registerNib<Cell: UICollectionViewCell>(_: Cell.Type) {
        let nib = UINib(nibName: Cell.nibName, bundle: nil)
        register(nib, forCellWithReuseIdentifier: Cell.reuseIdentifier)
    }
    
    func registerClass<Cell: UICollectionViewCell>(_: Cell.Type) {
        register(Cell.self, forCellWithReuseIdentifier: Cell.reuseIdentifier)
    }
}
