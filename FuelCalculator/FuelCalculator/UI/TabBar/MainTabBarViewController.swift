//
//  MainTabBarViewController.swift
//  FuelCalculator
//
//  Created by Dmitriy Opryatnov on 2.08.24.
//

import UIKit

final class MainTabBarViewController: UITabBarController {
    
    // MARK:  Override methods

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
        setTabBarAppearance()

    }
    
    // MARK: Private methods
    
    private func setupTabBar() {
        
        viewControllers = [
            setupVieController(
                viewcontroller: FuelCalculatorViewController(),
                title: LS("FUEL.CALCULATOR.TAB.TITLE"),
                image: UIImage(named: .homeSelectedImage)
            ),
            setupVieController(
                viewcontroller: FuelListViewController(),
                title: LS("FUEL.LIST.TAB.TITLE"),
                image: UIImage(named: .fuelUnselected)
            ),
            setupVieController(
                viewcontroller: SettingsViewController(),
                title: "Settings",
                image: UIImage(resource: .settingSelected)
            )
        ]
    }
    
    private func setupVieController(
        viewcontroller: UIViewController,
        title: String,
        image: UIImage?
    ) -> UIViewController {
        let navigationController = UINavigationController(rootViewController: viewcontroller)
        navigationController.tabBarItem.title = title
        return navigationController
    }
    
    private func setTabBarAppearance() {
        if UIDevice.hasNotch {
            let positionX: CGFloat  = 10
            let positionY: CGFloat  = 14
            let width = tabBar.bounds.width - positionX * 2
            let height = tabBar.bounds.height + positionY * 2
            
            let roundLayer = CAShapeLayer()
            
            let beziePath = UIBezierPath(
                roundedRect: CGRect(
                    x: positionX,
                    y: tabBar.bounds.minY - positionY,
                    width: width,
                    height: height
                ),
                cornerRadius: height / 2
            )
            
            roundLayer.path = beziePath.cgPath
            
            tabBar.layer.insertSublayer(roundLayer, at: 0)
            tabBar.itemWidth = width / 5
            tabBar.itemPositioning = .centered
            roundLayer.fillColor = UIColor(resource: .white).withAlphaComponent(0.5).cgColor
        }
        
        let selectedColor = UIColor.white
        let unselectedColor = UIColor.black
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: selectedColor], for: .selected)
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: unselectedColor], for: .normal)
        
        UITabBar.appearance().backgroundColor = !UIDevice.hasNotch ? UIColor(resource: .white).withAlphaComponent(0.5) : UIColor.clear
        
        UITabBar.appearance().barTintColor = UIColor.clear
        UITabBar.appearance().backgroundImage = UIImage()
        UITabBar.appearance().shadowImage = UIImage()
        
        let homeUnselectedImage: UIImage = UIImage(named: .homeUnselectedImage)!.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
        let homeSelectedImage: UIImage = UIImage(named: .homeSelectedImage)!.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
        
        let currencyUnselectedImage: UIImage = UIImage(named: .fuelUnselected)!.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
        let currencySelectedImage: UIImage = UIImage(named: .fuelSelected)!.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
        
        let settingsUnselectedImage: UIImage = UIImage(resource: .settingUnselected).withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
        let settingsSelectedImage: UIImage = UIImage(resource: .settingSelected).withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
        
        if let items = tabBar.items {
            items[0].image = homeUnselectedImage
            items[0].selectedImage = homeSelectedImage
            
            items[1].image = currencyUnselectedImage
            items[1].selectedImage = currencySelectedImage
            
            items[2].image = settingsUnselectedImage
            items[2].selectedImage = settingsSelectedImage
        }
    }
}
