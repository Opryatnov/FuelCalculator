//
//  CurrencyListViewController.swift
//  CurrencyConverter
//
//  Created by Dmitriy Opryatnov on 16.03.23.
//

import UIKit
import Combine

protocol CurrencyListViewControllerDelegate: AnyObject {
    func didUpdate()
}

final class CurrencyListViewController: UIViewController {
    
    // MARK: Constants
    
    private enum Constants {
        static let tableViewBottomInset: CGFloat = 20
        static let tableViewAdditionalInset: CGFloat = 15
        static let tableViewContentInset: CGFloat = 20
    }
    
    // MARK: UI
    
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.backgroundColor = UIColor(resource: .darkGray6)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        tableView.keyboardDismissMode = .onDrag
        tableView.showsVerticalScrollIndicator = false
        tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: CGFloat.leastNormalMagnitude, height: CGFloat.leastNormalMagnitude))
        tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: CGFloat.leastNormalMagnitude, height: CGFloat.leastNormalMagnitude))
        
        return tableView
    }()
    
    // MARK: Internal properties
    
    weak var delegate: CurrencyListViewControllerDelegate?
    
    // MARK: Private properties
    
    private var currencies: [CurrencyData]?
    private let userDefaultsManager = UserDefaultsManager.shared
    private var favoriteCurrenciesCode: Int? {
        userDefaultsManager.getFavoriteCurrencyCode()
    }
    private var currencyType: CurrencyType = .currencyList
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(resource: .darkGray6)
        view.addSubview(tableView)
        configureNavigationBar()
        tableView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview().inset((self.tabBarController?.tabBar.frame.height ?? .zero) + Constants.tableViewAdditionalInset)
        }
        tableView.contentInset.bottom = Constants.tableViewContentInset
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CurrencyTableViewCell.self, forCellReuseIdentifier: CurrencyTableViewCell.identifier)
        cancellables.removeAll()
        reactToFetchCurrencies()
        fetchCurrencies()
    }
    
    // MARK: Private methods
    
    private func fetchCurrencies() {
        NetworkService.shared.getCurrencyList(networkProvider: NetworkRequestProviderImpl()) { result in
            switch result {
            case .success:
                break
            case .failure:
                break
            }
        }
    }
    
    private func reactToFetchCurrencies() {
        NetworkService.shared.$fetchedCurrencies
            .sink { currenciesList in
                self.currencies = currenciesList
                self.currencies?.first(where: { $0.currencyID == self.favoriteCurrenciesCode})?.isSelected = true
                self.tableView.reloadData()
            }
            .store(in: &cancellables)
    }
    
    private func configureNavigationBar() {
        let textAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        navigationController?.navigationBar.topItem?.title = LS("CURRENCY.LIST.TAB.TITLE")
    }
    
    private func showError(message: String?) {
        let closeAction = [
            UIAlertAction(title: LS("ALERT.CLOSE.BUTTON"), style: .cancel)
        ]
        showAlert(message: message, buttons: closeAction, viewController: self)
    }
}

// MARK: - UITableViewDelegate, - UITableViewDataSource

extension CurrencyListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        currencies?.count ?? .zero
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CurrencyTableViewCell.identifier, for: indexPath) as? CurrencyTableViewCell
        cell?.selectionStyle = .none
        if let currency = currencies?[indexPath.row] {
            cell?.fill(currency: currency, currencyType: currencyType)
        }
        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard currencyType == .currencyList else { return }
        if let currency = currencies?[indexPath.row] {
            if currency.currencyID != 0 || (currency.currencyID == 0 && currency.isSelected == false) {
                currency.isSelected.toggle()
            }
            guard let currencyID = currency.currencyID else { return }
            if currency.isSelected == true {
                userDefaultsManager.removeFavorite()
                currencies?.forEach {
                    if $0.currencyID != currencyID {
                        $0.isSelected = false
                    }
                }
                userDefaultsManager.setFavoriteCurrencyCode(currencyID)
            } else {
                if currencyID != 0 {
                    userDefaultsManager.removeFavorite()
                }
            }
            userDefaultsManager.isChangedFavoriteList = true
            tableView.reloadData()
            delegate?.didUpdate()
            navigationController?.popViewController(animated: true)
        }
    }
}
