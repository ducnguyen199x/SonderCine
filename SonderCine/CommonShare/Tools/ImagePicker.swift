//
//  ImagePicker.swift
//  SwipeTicket
//
//  Created by Nguyen Thanh Duc on 19/1/21.
//

import UIKit

class ImagePicker {
    class func showPhotoLibrary(in viewController: UIViewController? = nil) {
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.mediaTypes = ["public.image"]
        picker.allowsEditing = true
        picker.delegate = viewController as? (UIImagePickerControllerDelegate & UINavigationControllerDelegate)
        DispatchQueue.main.async {
            (viewController ?? UIApplication.topMostController())?
                .present(picker, animated: true, completion: nil)
        }
    }
}
