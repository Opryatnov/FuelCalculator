import Foundation
import UIKit

extension UIWindow {
    
    /// Transition to view controller with animation. If no rootViewController is set on the window already,
    /// then it is set, UIWindow.makeKeyAndVisibile() is called, and no animation is needed.
    ///
    /// - Parameter viewController: view controller to present
    func replaceRootViewController(_ rootViewController: UIViewController) {
        
        if self.rootViewController == nil {
            self.rootViewController = rootViewController
            self.makeKeyAndVisible()
            return
        }
        
        let transition = CATransition()
        transition.type = CATransitionType.fade
        
        layer.add(transition, forKey: kCATransition)
        
        if let vc = self.rootViewController {
            vc.dismiss(animated: false, completion: nil)
        }
        self.rootViewController = rootViewController
    }
}
