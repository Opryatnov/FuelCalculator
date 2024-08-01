//
//  CurrencyTableViewCell.swift
//  CurrencyConverter
//
//  Created by Opryatnov on 29.04.24.
//

import UIKit
import SnapKit

enum CurrencyType {
    case currencyList
    case currencyDetails
}

final class CurrencyTableViewCell: BaseTableViewCell {
    
    // MARK: Constants
    
    private enum Constants {
        enum CurrencyNameLabel {
            static let insets: CGFloat = 5
        }
        
        enum CurrencyCodeLabel {
            static let insets: CGFloat = 5
            static let topInset: CGFloat = 2
            static let bottomInset: CGFloat = 5
        }
        
        enum CurrencyView {
            static let topBottom: CGFloat = 10
            static let leftInset: CGFloat = 5
        }
        
        enum CurrencyImageView {
            static let leftInset: CGFloat = 10
            static let size: CGFloat = 32
        }
        
        enum FavoritesImageView {
            static let rightInset: CGFloat = 10
            static let leftInset: CGFloat = 10
            static let size: CGFloat = 32
        }
    }
    
    // MARK: UI
    
    private let currencyNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        
        return label
    }()
    
    private let currencyCodeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        
        return label
    }()
    
    private let currencyView: UIView = {
        let view = UIView()
        
        return view
    }()
    
    private let currencyIconImageView: UIImageView = {
        let view = UIImageView()
        
        return view
    }()
    
    private let favoriteImageView: UIImageView = {
        let view = UIImageView()
        
        return view
    }()
    
    private let backView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 20
        
        return view
    }()
    
    // MARK: Internal properties
    
    static let identifier: String = "CurrencyTableViewCell"
        
    // MARK: Internal methods
    
    func fill(currency: CurrencyData, currencyType: CurrencyType) {
        currencyIconImageView.image = currency.currencyImage
        currencyNameLabel.text = currency.localisedName
        currencyCodeLabel.text = currency.currencyAbbreviation
        
        currencyType == .currencyList ? configureFavoriteImage(isSelected: currency.isSelected) : configureNextStepImage()
    }
    
    // MARK: Override methods
    
    override func configureViews() {
        backgroundColor = .clear
        contentView.addSubview(backView)
        backView.addSubview(currencyIconImageView)
        backView.addSubview(currencyView)
        currencyView.addSubview(currencyNameLabel)
        currencyView.addSubview(currencyCodeLabel)
        backView.addSubview(favoriteImageView)
    }
    
    override func setupConstraints() {
        backView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(10)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        
        currencyIconImageView.snp.makeConstraints {
            $0.size.equalTo(Constants.CurrencyImageView.size)
            $0.leading.equalToSuperview().inset(Constants.CurrencyImageView.leftInset)
            $0.centerY.equalToSuperview()
        }
        
        currencyView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(Constants.CurrencyView.topBottom)
            $0.leading.equalTo(currencyIconImageView.snp.trailing).inset(-Constants.CurrencyView.leftInset)
        }
        
        currencyNameLabel.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(Constants.CurrencyNameLabel.insets)
            $0.top.equalToSuperview()
        }
        
        currencyCodeLabel.snp.makeConstraints {
            $0.top.equalTo(currencyNameLabel.snp.bottom).inset(-Constants.CurrencyCodeLabel.topInset)
            $0.leading.trailing.equalToSuperview().inset(Constants.CurrencyCodeLabel.insets)
            $0.bottom.equalToSuperview().inset(Constants.CurrencyCodeLabel.bottomInset)
        }
        
        favoriteImageView.snp.makeConstraints {
            $0.size.equalTo(Constants.FavoritesImageView.size)
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(currencyView.snp.trailing).inset(-Constants.FavoritesImageView.leftInset)
            $0.trailing.equalToSuperview().inset(Constants.FavoritesImageView.rightInset)
        }
    }
    
    // MARK: Private methods
    
    private func configureFavoriteImage(isSelected: Bool) {
        backView.backgroundColor = UIColor(resource: .darkGray5)
        favoriteImageView.image = isSelected ? UIImage(named: "selected") : UIImage(named: "nonSelected")
    }
    
    private func configureNextStepImage() {
        backView.layer.borderColor = UIColor(resource: .darkGray3).cgColor
        backView.layer.borderWidth = 1
        backView.backgroundColor = UIColor(resource: .darkGray5)
        favoriteImageView.image = UIImage(named: "rightArrow")
    }
}
