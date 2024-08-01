//
//

import UIKit

//Inspired by https://github.com/surfstudio/iOS-Utils/blob/master/Utils/Utils/UIView/UIView%2BXibSetup.swift

/*
    Helper extension to load view from xib.
    How to use:
        1. Create new custom View and Xib file
        2. In xib file set View.swift as the FileOwner
        3. Inside View initializator methods call setupXib method

    Example:
    ```
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupXib()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupXib()
    }
    ```
*/
public extension UIView {
    func setupXib(from bundle: Bundle = .main) {
        let view = loadFromNib(bundle: bundle)
        addSubview(view)
        pinToBounds(view)
    }

    func loadFromNib<T: UIView>(bundle: Bundle) -> T {
        let selfType = type(of: self)
        let nibName = String(describing: selfType)
        let nib = UINib(nibName: nibName, bundle: bundle)

        guard let view = nib.instantiate(withOwner: self, options: nil).first as? T else {
            return T()
        }

        return view
    }

    static func loadFromNib<T: UIView>(bundle: Bundle) -> T {
        let nibName = String(describing: self)
        let nib = UINib(nibName: nibName, bundle: bundle)

        guard let view = nib.instantiate(withOwner: self, options: nil).first as? T else {
            return T()
        }

        return view
    }

    func setupXib() {
        let view = loadFromNib()
        addSubview(view)
        pinToBounds(view)
    }

    func loadFromNib<T: UIView>() -> T {
        let bundle = Bundle(for: type(of: self))
        return loadFromNib(bundle: bundle)
    }

    static func loadFromNib<T: UIView>() -> T {
        let bundle = Bundle(for: self)
        return loadFromNib(bundle: bundle)
    }

    func pinToBounds(_ view: UIView) {
        view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: topAnchor),
            view.leadingAnchor.constraint(equalTo: leadingAnchor),
            view.trailingAnchor.constraint(equalTo: trailingAnchor),
            view.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
