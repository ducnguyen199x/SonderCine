//
//  UIImage+Extensions.swift
//  SonderCine
//
//  Created by Nguyen Thanh Duc on 26/8/21.
//

import UIKit

/// `UIImage` extensions.
extension UIImage {
    static var settings: UIImage? {
        return UIImage(systemName: "gearshape")
    }
    
    static var nowPlaying: UIImage? {
        return UIImage(systemName: "film")
    }
    
    static var topRated: UIImage? {
        return UIImage(systemName: "star.circle")
    }
    
    static var vote: UIImage? {
        return UIImage(systemName: "star.fill")
    }
    
    static var backward: UIImage? {
        return UIImage(systemName: "chevron.backward")
    }
    
    static var forward: UIImage? {
        return UIImage(systemName: "chevron.forward")
    }
    
    static var ellipsis: UIImage? {
        return UIImage(systemName: "ellipsis")
    }
    
    static var close: UIImage? {
        return UIImage(systemName: "xmark")
    }
    
    static var checkmark: UIImage? {
        return UIImage(systemName: "checkmark")
    }
    
    static var currentPosition: UIImage? {
        return UIImage(systemName: "figure.wave.circle")
    }
}

extension UIImage {
    func resized(to size: CGSize) -> UIImage {
      return UIGraphicsImageRenderer(size: size).image { _ in
        draw(in: CGRect(origin: .zero, size: size))
      }
    }
}
