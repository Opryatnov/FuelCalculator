//
//  BaseTableViewCell.swift
//  FuelCalculator
//
//  Created by Dmitriy Opryatnov on 1.08.24.
//

import UIKit
import SnapKit

public protocol FMConfigurableView: AnyObject {
    func configureViews()
    func addSubviews()
    func setupConstraints()
}

open class BaseTableViewCell: UITableViewCell, FMConfigurableView {
    
    override public init(
        style: UITableViewCell.CellStyle,
        reuseIdentifier: String?
    ) {
        super.init(
            style: style,
            reuseIdentifier: reuseIdentifier
        )
        
        configureViews()
        addSubviews()
        setupConstraints()
    }
    
    @available(*, unavailable, message: "Loading from a nib is unsupported in favor of initializer dependency injection.")
    required public init?(coder: NSCoder) {
        assertionFailure("init(coder:) has not been implemented")
        return nil
    }
    
    open func addSubviews() {}
    open func setupConstraints() {}
    open func configureViews() {
        selectionStyle = .none
    }
}
