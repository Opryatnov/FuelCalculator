//
//  FuelCalculatorCell.swift
//  CurrencyConverter
//
//  Created by Opryatnov on 10.05.24.
//

import UIKit
import SnapKit

protocol FuelCalculatorCellDelegate: AnyObject {
    func didChangeAmount(amount: Double, fuel: Fuel?)
}

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
    
    private let fuelPriceLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(resource: .darkSecondary6)
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 13)
        
        return label
    }()
    
    private let fuelCodeLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(resource: .darkSecondary6)
        label.font = UIFont.systemFont(ofSize: 13)
        
        return label
    }()
    
    private lazy var fuelCountTextField: UITextField = {
        let textField = UITextField()
        textField.keyboardType = .decimalPad
        textField.textColor = .white
        textField.textAlignment = .right
        textField.delegate = self
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor(resource: .gray30),
            .font: UIFont.systemFont(ofSize: 16)
        ]
        
        textField.attributedPlaceholder = NSAttributedString(string: LS("WRITE.LITER.PLACEHOLDER"), attributes: attributes)
        
        return textField
    }()
    
    private let fuelView: UIView = {
        let view = UIView()
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
    weak var delegate: FuelCalculatorCellDelegate?
    private var fuel: Fuel?
    private let inputValidator = ValidationFieldType.balanceInputWithoutNumbersAfterPoint
    private var currency: CurrencyData?
    private var convertedPrice: Double?
        
    // MARK: Internal methods
    
    func fill(fuel: Fuel, currency: CurrencyData) {
        self.fuel = fuel
        self.currency = currency
        fuelNameLabel.text = fuel.localisedName
        fuelCodeLabel.text = fuel.fuelCode
        fuelPriceLabel.text = convertedPrice(currency: currency)
        setupFuelIcons(fuel: fuel)
        if let writeOfAmount = currency.writeOfAmount {
            let countOfFuel = writeOfAmount / (convertedPrice ?? 1)
            fuelCountTextField.text = countOfFuel.round(to: 3).description
        } else {
            fuelCountTextField.text = nil
        }
    }
    
    // MARK: Private methods
    
    override func configureViews() {
        backgroundColor = .clear
        contentView.addSubview(fuelView)
        fuelView.addSubview(fuelIconImageView)
        fuelView.addSubview(stackView)
        stackView.addArrangedSubview(fuelNameLabel)
        stackView.addArrangedSubview(fuelCodeLabel)
        stackView.addArrangedSubview(fuelPriceLabel)
        fuelView.addSubview(fuelCountTextField)
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
            $0.trailing.equalTo(fuelCountTextField.snp.leading).inset(-Constants.FuelPriceLabel.leftInset)
        }
        
        fuelCountTextField.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(Constants.FuelPriceLabel.rightInset)
            $0.top.bottom.equalToSuperview()
        }
    }
    
    // MARK: Private methods
    
    private func convertedPrice(currency: CurrencyData) -> String? {
        guard let amount = fuel?.amount, let code = currency.currencyAbbreviation else { return nil }
        if currency.currencyAbbreviation == "BYN" {
            convertedPrice = amount.toDouble()
            return amount + " " + code
        } else {
            var otherWriteOfAmount: String?
            if let price = fuel?.convertedAmount {
                let tempPrice = 1 * (price / (fuel?.getWriteOfAmount(currency: currency) ?? .zero))
                convertedPrice = tempPrice.round(to: 3)
                otherWriteOfAmount = "\(tempPrice.round(to: 3)) \(code)"
            }
            return otherWriteOfAmount
        }
    }
    
    private func convertedMultipliedPrice(amount: Double?) {
        fuel?.writeOfCount = amount
        let result = (amount ?? .zero) * (fuelPriceLabel.text?.trimCurrency()?.toDouble() ?? .zero)
        delegate?.didChangeAmount(amount: result.round(to: 2), fuel: fuel)
    }
    
    private func fillTextField(fuel: Fuel, currency: CurrencyData) {
        if currency.isSelected == false {
            if fuelCountTextField.text?.isEmpty == true {
                configureTextFieldPlaceholder()
            } else {
                convertedMultipliedPrice(amount: fuelCountTextField.text?.toDouble())
            }
        } else {
            guard let writeOfAmount = currency.writeOfAmount, 
                    let writeOfCount = fuel.getWriteOfAmount(currency: currency) else { return }
            fuelCountTextField.text = (writeOfAmount / (fuel.amount?.toDouble() ?? 1)).round(to: 2).description
        }
        fuelCountTextField.addDoneButtonOnKeyboard()
    }
    
    private func configureTextFieldPlaceholder() {
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor(resource: .gray30),
            .font: UIFont.systemFont(ofSize: 16)
        ]
        
        fuelCountTextField.attributedPlaceholder = NSAttributedString(string: LS("WRITE.LITER.PLACEHOLDER"), attributes: attributes)
    }
    
    private func setupFuelIcons(fuel: Fuel) {
        var fuelImage: UIImage = UIImage()
        switch fuel.fuelCode {
        case "AI-92":
            fuelImage = UIImage(resource: .fuel92)
        case "AI-95":
            fuelImage = UIImage(resource: .fuel95)
        case "AI-98":
            fuelImage = UIImage(resource: .fuel98)
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

extension FuelCalculatorCell: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        fuelView.layer.borderWidth = 0
        fuelView.layer.borderColor = UIColor.clear.cgColor
        if textField.text?.isEmpty == true {
            configureTextFieldPlaceholder()
        } else {
            let receiveAmountString = textField.text?.replacingOccurrences(of: ",", with: "") ?? ""
            textField.text = receiveAmountString.toAmountFormat()
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        fuelCountTextField.addDoneButtonOnKeyboard()
        currency?.isSelected = false
        currency?.writeOfAmount = nil
        textField.placeholder = nil
        textField.text = "0.00"
        let receiveAmountString = textField.text?.replacingOccurrences(of: ",", with: "") ?? ""
        currency?.writeOfAmount = Double(receiveAmountString)?.round()
        delegate?.didChangeAmount(amount: 0.0, fuel: fuel)
        fuelView.layer.borderWidth = 1
        fuelView.layer.borderColor = UIColor(resource: .gold1).cgColor
        textField.text = nil
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let result: Bool
        guard let textFieldText = textField.text,
              let range = Range(range, in: textFieldText) else { return true }
        var updatedText = textFieldText.replacingCharacters(
            in: range,
            with: string
        )

        if updatedText.suffix(1) == "," {
            let lastIndex = updatedText.index(before: updatedText.endIndex)
            updatedText.replaceSubrange(lastIndex...lastIndex, with: ["."])
        }
        let balanceString = updatedText.replacingOccurrences(of: ",", with: "")

        result = Validator.isValid(balanceString, type: inputValidator)

        if result {
            let balance = Decimal(string: balanceString) ?? 0
            var minimumFractionDigits = 0
            if let dotRange = balanceString.range(of: ".") {
                let substring = balanceString[dotRange.upperBound...]
                minimumFractionDigits = substring.count
            }
            let finalString = balance.formattedWithSeparator(minimumFractionDigits)
            textField.text = finalString
            if let quantity = finalString.toDouble() {
                convertedMultipliedPrice(amount: quantity)
                fuel?.writeOfCount = quantity
            }
        }
        return false
    }
}

extension String {
    
    func trimCurrency() -> String? {
        self.filter { !$0.isLetter }.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
