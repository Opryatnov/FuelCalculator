
import UIKit

// swiftlint:disable force_cast
public extension UITableView {
    /// Allows to dequeue a UITableViewCell's that loads from xib without call _register(a_UITableViewCell_class, forCellReuseIdentifier: identifier)_
    /// - How to use:
    /// ```
    /// let cell = view.dequeueReusableCellWithRegistration(
    ///    type: NotificationCell.self,
    ///    indexPath: path
    /// )
    /// ```
    func dequeueReusableCellWithRegistration<T: TableViewNibCell>(
        type: T.Type,
        indexPath: IndexPath
    ) -> T {
        let identifier = T.identifier
        if let cell = dequeueReusableCell(withIdentifier: identifier) as? T {
            return cell
        }

        register(T.nib, forCellReuseIdentifier: identifier)
        return dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! T
    }
    
    /// Allows to dequeue a UITableViewHeaderFooterView that loads from xib
    func dequeueReusableNibHeaderFooter<T: ConfigurableTableNibHeaderFooter>(type: T.Type) -> T {
        let view = dequeueReusableHeaderFooterView(withIdentifier: T.identifier) as! T
        return view
    }
    
    /// Allows to register a UITableViewHeaderFooterView that loads from xib
    func register<HeaderFooter: NibTableHeaderFooter>(headerFooter: HeaderFooter.Type) {
        register(headerFooter.nib, forHeaderFooterViewReuseIdentifier: headerFooter.identifier)
    }
}
// swiftlint:enable force_cast

extension UITableView {

    public func removeSectionHeadersTopPadding() {
        if #available(iOS 15.0, *) {
            sectionHeaderTopPadding = .zero
        }
    }
}
