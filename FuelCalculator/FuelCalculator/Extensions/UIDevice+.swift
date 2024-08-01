import UIKit

extension UIDevice {
    
    static var screenMaxSize: CGFloat { max(UIScreen.main.bounds.height, UIScreen.main.bounds.width) }
    static var screenMinSize: CGFloat { min(UIScreen.main.bounds.height, UIScreen.main.bounds.width) }
    
    static var hasNotch: Bool {
        let bottomSafeAreaInset = UIApplication
            .shared
            .windows
            .filter { $0.isKeyWindow }
            .first?
            .safeAreaInsets
            .bottom ?? 0
        
        return bottomSafeAreaInset > 0
    }

    static var has9By16AspectRatio: Bool {
        let screenSize = UIScreen.main.bounds.size
        return (screenSize.height / screenSize.width) < 1.8
    }
}
