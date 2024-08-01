
import UIKit

/// Loads a nib file for type. The Xib file name should be equal to class name
public protocol NibLoadableView {
    static var nib: UINib { get }
}

public extension NibLoadableView where Self: UIView {
    static var nib: UINib {
        let nibName = String(describing: self)
        let nibBundle = Bundle(for: self)
        return UINib(nibName: nibName, bundle: nibBundle)
    }
}

/// Creates an identifier for view. Identifier will be equal to class name
public protocol ReusableView {
    static var identifier: String { get }
}

public extension ReusableView where Self: UIView {
    static var identifier: String { return String(describing: self) }
}

//MARK: - Table & Collection protocols

/// A contract for a UITableViewCell that loads from Xib file
public protocol TableViewNibCell:
    NibLoadableView,
    ReusableView where Self: UITableViewCell {}

/// A contract for a UICollectionViewCell that loads from Xib file
public protocol CollectionViewNibCell:
    NibLoadableView,
    ReusableView where Self: UICollectionViewCell {}

/// A contract for a UITableViewHeaderFooterView that loads from Xib file
public protocol NibTableHeaderFooter:
    NibLoadableView,
    ReusableView where Self: UITableViewHeaderFooterView {}

/// A contract for a UICollectionReusableView that loads from Xib file
public protocol NibCollectionReusableView:
    NibLoadableView,
    ReusableView where Self: UICollectionReusableView
{
    static var kind: String { get }
}

/// A contract for a UIView/UIControl that can be filled with any data
public protocol ConfigurableView {
    /// A type for model that will transfer any data to view
    associatedtype Props
    
    func fill(with props: Props)
}

//MARK: - Table & Collection typealias'es

/// A contract for a UITableViewCell that will load from Xib file and will fill with any data
public typealias ConfigurableTableNibCell = TableViewNibCell & ConfigurableView

/// A contract for a UICollectionViewCell that will load from Xib file and will fill with any data
public typealias ConfigurableCollectionNibCell = CollectionViewNibCell & ConfigurableView

/// A contract for a UITableViewHeaderFooterView that will load from Xib file and will fill with any data
public typealias ConfigurableTableNibHeaderFooter = NibTableHeaderFooter & ConfigurableView

/// A contract for a UICollectionReusableView that will load from Xib file and will fill with any data
public typealias ConfigurableCollectionNibReusableView = NibCollectionReusableView & ConfigurableView
