//
//  Navigation.swift
//  FuelCalculator
//
//  Created by Dmitriy Opryatnov on 1.08.24.
//

import UIKit

public protocol PageContext {}

final class Navigation {
    
    static var currentController: UIViewController? {
        return UIApplication.topViewController()
    }
}
