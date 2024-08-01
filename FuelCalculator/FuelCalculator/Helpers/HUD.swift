//
//  HUD.swift
//  CurrencyConverter
//
//  Created by Opryatnov on 29.04.24.
//

import UIKit
import Lottie

final class HUD {
    
    private enum Constants {
        enum Icon {
            static let size = CGSize(width: 118, height: 118)
        }
        static let animationDuration: TimeInterval = 0.3
        static let backgroundColor: UIColor? = .black.withAlphaComponent(0.4)
        static let animationSpeed: CGFloat = 1
    }
    /// View that is currently shown if it exists. Contains backgroundView and HUD.
    private var lastContainer: UIView?
    /// HUD that is currently shown if it exists.
    private var lastHUD: LottieAnimationView?
    
    // MARK: Internal properties
    
    static let shared = HUD()
    
    // MARK: Initialization
    
    private init() {}
    
    /**
     HUD that is displayed in the center of the screen.
     - Note: Default type is `UIActivityIndicatorView`
     */
    private var hud: LottieAnimationView {
        let view = LottieAnimationView(name: "loading")
        view.loopMode = .loop
        view.contentMode = .scaleAspectFit
        view.animationSpeed = Constants.animationSpeed
        return view
    }
    
    /// Show the HUD on top of the screen. Doesn't create new HUD if HUD is spinning on the screen at this moment.
//    @MainActor
    func show() {
        guard let window = UIApplication.shared.windows.filter({ $0.isKeyWindow }).first else { return }
        
        if let lastContainer = lastContainer,
           lastHUD != nil,
           let superview = lastContainer.superview {
            window.bringSubviewToFront(superview)
        } else {
            let container = UIView(frame: .zero)
            container.backgroundColor = .clear
            let backgroundView = UIView(frame: .zero)
            backgroundView.backgroundColor = Constants.backgroundColor
            let hud = hud
            
            window.addSubview(container)
            container.addSubview(backgroundView)
            container.addSubview(hud)
            
            container.snp.makeConstraints { $0.edges.equalToSuperview() }
            backgroundView.snp.makeConstraints { $0.edges.equalToSuperview() }
            hud.snp.makeConstraints {
                $0.center.equalToSuperview()
                $0.width.equalTo(Constants.Icon.size.width)
                $0.height.equalTo(Constants.Icon.size.height)
            }
            
            hud.play()
            
            lastContainer = container
            lastHUD = hud
        }
    }
    
    /// Hide the HUD with animation.
//    @MainActor
    func hide() {
        UIView.animate(withDuration: Constants.animationDuration) { [weak self] in
            guard let self else { return }
            lastContainer?.alpha = 0
            lastHUD?.stop()
            lastContainer?.removeFromSuperview()
            lastHUD = nil
            lastContainer = nil
        }
    }
}
