//
//  ActionSheet.swift
//  SwipeTicket
//
//  Created by Nguyen Thanh Duc on 19/1/21.
//

import UIKit

class ActionSheet {
    class func showActionSheet(title: String?,
                               with actions: [UIAlertAction],
                               in viewController: UIViewController?) {
        guard let sourceVC = viewController ?? UIApplication.topMostController() else { return }
        let sheet = UIAlertController(title: title, message: nil, preferredStyle: .actionSheet)
        actions.forEach { action in
            sheet.addAction(action)
        }
        
        let popPresenter = sheet.popoverPresentationController
        popPresenter?.permittedArrowDirections = []
        popPresenter?.sourceView = sourceVC.view
        popPresenter?.sourceRect = CGRect(x: sourceVC.view.bounds.midX,
                                          y: sourceVC.view.bounds.midY,
                                          width: 0,
                                          height: 0)

        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
        sheet.addAction(cancelAction)
        
        DispatchQueue.main.async {
            sourceVC.present(sheet, animated: true, completion: nil)
        }
    }
}
