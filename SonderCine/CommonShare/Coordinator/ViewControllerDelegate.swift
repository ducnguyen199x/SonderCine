//
//  ViewControllerDelegate.swift
//
//  Created by Nguyen Thanh Duc on 19/1/21.
//
// swiftlint:disable class_delegate_protocol

import UIKit

protocol ViewControllerDelegate where Self: Coordinator {
    func viewControllerWillDeinit()
}

extension ViewControllerDelegate {
    func viewControllerWillDeinit() {
        detachHandler()
    }
}
