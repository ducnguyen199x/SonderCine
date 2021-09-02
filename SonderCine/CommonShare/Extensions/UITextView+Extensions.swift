//
//  UITextView+Extensions.swift
//  SwipeTicket
//
//  Created by Nguyen Thanh Duc on 20/1/21.
//

import UIKit

extension UITextView {
    func setAttributeText(_ stringWithTag: String?) {
        let attributedText = NSMutableAttributedString(stringWithTag: stringWithTag, font: self.font ?? .systemFont(ofSize: 14), color: self.textColor ?? .black)
        self.attributedText = attributedText
    }
}
