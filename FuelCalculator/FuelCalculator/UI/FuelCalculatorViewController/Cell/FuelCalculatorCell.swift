//
//  FuelCalculatorCell.swift
//  CurrencyConverter
//
//  Created by Opryatnov on 10.05.24.
//

import UIKit
import SnapKit

final class FuelCalculatorCell: BaseTableViewCell {
    
    // MARK: Constants
    
    private enum Constants {
        enum FuelNameLabel {
            static let insets: CGFloat = 5
        }
        
        enum FuelCodeLabel {
            static let insets: CGFloat = 5
            static let topInset: CGFloat = 2
            static let bottomInset: CGFloat = 5
        }
        
        enum FuelView {
            static let topBottom: CGFloat = 12
            static let insets: CGFloat = 16
            static let height: CGFloat = 64
        }
        
        enum StackView {
            static let leftInset: CGFloat = 17
        }
        
        enum CurrencyImageView {
            static let leftInset: CGFloat = 10
            static let size: CGFloat = 32
        }
        
        enum FuelPriceLabel {
            static let rightInset: CGFloat = 10
            static let leftInset: CGFloat = 11
        }
    }
    
    // MARK: UI
    
    private let fuelNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 17)
        
        return label
    }()
    
    private let fuelCodeLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(resource: .darkSecondary6)
        label.font = UIFont.systemFont(ofSize: 13)
        
        return label
    }()
    
    private let fuelPriceLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 13)
        
        return label
    }()
    
    private let fuelView: UIView = {
        let view = UIView()
        view.layer.borderColor = UIColor(resource: .gold1).cgColor
        view.layer.borderWidth = 1
        view.layer.cornerRadius = 17
        view.backgroundColor = UIColor(resource: .darkGray5)
        
        return view
    }()
    
    private let stackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 1
        view.distribution = .fillEqually
        
        return view
    }()
    
    private let fuelIconImageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(resource: .selected)
        
        return view
    }()
    
    // MARK: Internal properties
    
    static let identifier: String = "FuelCalculatorCell"
        
    // MARK: Internal methods
    
    func fill(fuel: Fuel) {
        fuelNameLabel.text = fuel.localisedName
        fuelCodeLabel.text = fuel.fuelCode
        fuelPriceLabel.text = fuel.convertedAmount?.description
        stackView.addArrangedSubview(fuelNameLabel)
        stackView.addArrangedSubview(fuelCodeLabel)
        setupFuelIcons(fuel: fuel)
    }
    
    // MARK: Private methods
    
    override func configureViews() {
        backgroundColor = .clear
        addSubview(fuelView)
        fuelView.addSubview(fuelIconImageView)
        fuelView.addSubview(stackView)
        fuelView.addSubview(fuelPriceLabel)
    }
    
    override func setupConstraints() {
        fuelView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(Constants.FuelView.topBottom)
            $0.leading.trailing.equalToSuperview().inset(Constants.FuelView.insets)
        }
        
        fuelIconImageView.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(Constants.CurrencyImageView.leftInset)
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(Constants.CurrencyImageView.size)
        }
        
        stackView.snp.makeConstraints {
            $0.leading.equalTo(fuelIconImageView.snp.trailing).inset(-Constants.StackView.leftInset)
            $0.top.bottom.equalToSuperview().inset(11)
            $0.trailing.lessThanOrEqualTo(fuelPriceLabel.snp.leading).inset(-Constants.FuelPriceLabel.leftInset)
        }
        
        fuelPriceLabel.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(Constants.FuelPriceLabel.rightInset)
            $0.centerY.equalTo(fuelIconImageView)
        }
    }
    
    // MARK: Private methods
    
    private func setupFuelIcons(fuel: Fuel) {
        var fuelImage: UIImage = UIImage()
        switch fuel.fuelCode {
        case "AI-92":
            fuelImage = UIImage(resource: .fuel92)
        case "AI-95":
            fuelImage = UIImage(resource: .fuel95)
        case "Gas":
            fuelImage = UIImage(resource: .fuelGas)
        case "DT":
            fuelImage = UIImage(resource: .dieselFuel)
        case "DT-ECO":
            fuelImage = UIImage(resource: .fuelEco)
        case "DT-Winter":
            fuelImage = UIImage(resource: .winterDieselFuel)
        default:
            fuelImage = UIImage(resource: .dieselFuel)
        }
        fuelIconImageView.image = fuelImage
    }
}
