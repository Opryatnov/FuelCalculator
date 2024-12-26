//
//  UIViewController+.swift
//  CurrencyConverter
//
//  Created by Opryatnov on 29.04.24.
//

import UIKit

extension UIViewController {
    func showAlert(
        title: String? = LS("ATTENTION"),
        message: String?,
        buttons: [UIAlertAction],
        preferredStyle: UIAlertController.Style = .alert,
        viewController: UIViewController?
    ) {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: preferredStyle
        )
        
        for button in buttons {
            alert.addAction(button)
        }
        
        viewController?.present(alert, animated: true)
    }
}
