import UIKit
import SwiftUI

private let fontFactory = SystemFontFactory()

extension UIFont {
    static func bold(ofSize size: CGFloat) -> UIFont { fontFactory.bold(ofSize: size) }
    static func semibold(ofSize size: CGFloat) -> UIFont { fontFactory.semibold(ofSize: size) }
    static func medium(ofSize size: CGFloat) -> UIFont { fontFactory.medium(ofSize: size) }
    static func heavy(ofSize size: CGFloat) -> UIFont { fontFactory.heavy(ofSize: size) }
    static func light(ofSize size: CGFloat) -> UIFont { fontFactory.light(ofSize: size) }
    static func system(ofSize size: CGFloat) -> UIFont { fontFactory.system(ofSize: size) }
    static func regular(ofSize size: CGFloat) -> UIFont { self.system(ofSize: size) }
}

extension Font {
    static func bold(ofSize size: CGFloat) -> Font { Font(fontFactory.bold(ofSize: size)) }
    static func semibold(ofSize size: CGFloat) -> Font { Font(fontFactory.semibold(ofSize: size)) }
    static func medium(ofSize size: CGFloat) -> Font { Font(fontFactory.medium(ofSize: size)) }
    static func heavy(ofSize size: CGFloat) -> Font { Font(fontFactory.heavy(ofSize: size)) }
    static func light(ofSize size: CGFloat) -> Font { Font(fontFactory.light(ofSize: size)) }
    static func system(ofSize size: CGFloat) -> Font { Font(fontFactory.system(ofSize: size)) }
    static func regular(ofSize size: CGFloat) -> Font { Font(UIFont.system(ofSize: size)) }
}

public protocol FontFactory {
    func font(ofSize size: CGFloat, weight: UIFont.Weight) -> UIFont
}

public extension FontFactory {
    func system(ofSize size: CGFloat) -> UIFont {  font(ofSize: size, weight: .regular)  }
    func regular(ofSize size: CGFloat) -> UIFont {  system(ofSize: size)  }
    func light(ofSize size: CGFloat) -> UIFont {  font(ofSize: size, weight: .light)  }
    func bold(ofSize size: CGFloat) -> UIFont {  font(ofSize: size, weight: .bold)  }
    func semibold(ofSize size: CGFloat) -> UIFont {  font(ofSize: size, weight: .semibold)  }
    func medium(ofSize size: CGFloat) -> UIFont {  font(ofSize: size, weight: .medium)  }
    func heavy(ofSize size: CGFloat) -> UIFont {  font(ofSize: size, weight: .heavy)  }
}

/// Default implementation of FontFactory
public class SystemFontFactory: FontFactory {
    public func font(ofSize size: CGFloat, weight: UIFont.Weight) -> UIFont {
        UIFont.systemFont(ofSize: size, weight: weight)
    }
}
