//
//  SettingsViewController.swift
//  FuelCalculator
//
//  Created by Opryatnov on 6.09.24.
//

import UIKit

enum Settings: String, CaseIterable {
    case firstEmpty
    case settings
    case secondEmpty
    case rateTheApp
    case thirdEmpty
    case feedBack
    
    var title: String {
        switch self {
        case .settings:
            "Settings"
        case .rateTheApp:
            "Rate the app"
        case .feedBack:
            "Feedback"
        case .firstEmpty, .secondEmpty, .thirdEmpty:
            ""
        }
    }
    
    var icon: UIImage {
        switch self {
        case .settings:
            UIImage(resource: .icAccountSettings).withRenderingMode(.alwaysTemplate)
        case .rateTheApp:
            UIImage(resource: .rateUs).withRenderingMode(.alwaysTemplate)
        case .feedBack:
            UIImage(resource: .feedBackIcon).withRenderingMode(.alwaysTemplate)
        case .firstEmpty, .secondEmpty, .thirdEmpty:
            UIImage(resource: .feedBackIcon)
        }
    }
}

final class SettingsViewController: UIViewController {
    
    // MARK: Constants
    
    private enum Constants {
        static let tableViewBottomInset: CGFloat = 20
        static let tableViewAdditionalInset: CGFloat = 15
        static let tableViewContentInset: CGFloat = 61
        static let url = URL(string: AppConstants.fuelListRequest)
        static let isHasNoughtHeight: CGFloat = 85
    }
    
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
    
    private let settings = Settings.allCases
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        addSubViews()
        setupConstraints()
    }
    
    private func addSubViews() {
        view.addSubview(tableView)
    }
    
    private func setupConstraints() {
        tableView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview().inset((self.tabBarController?.tabBar.frame.height ?? .zero) + Constants.tableViewAdditionalInset)
        }
    }
    
    private func setupTableView() {
        tableView.contentInset.bottom = Constants.tableViewContentInset
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(SettingsTableViewCell.self, forCellReuseIdentifier: SettingsTableViewCell.identifier)
        tableView.register(EmptyTableViewCell.self, forCellReuseIdentifier: EmptyTableViewCell.identifier)
    }
    
    private func configureNavigationBar() {
        let textAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        navigationController?.navigationBar.topItem?.title = LS("FUEL.LIST.TAB.TITLE")
    }
}

// MARK: - UITableViewDelegate, - UITableViewDataSource

extension SettingsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        settings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SettingsTableViewCell.identifier, for: indexPath) as? SettingsTableViewCell
        let emptyCell = tableView.dequeueReusableCell(withIdentifier: EmptyTableViewCell.identifier, for: indexPath) as? EmptyTableViewCell
        cell?.selectionStyle = .none
        let model = settings[indexPath.row]
        
        switch model {
        case .feedBack, .rateTheApp, .settings:
            cell?.fill(settingsModel: settings[indexPath.row])
            return cell ?? UITableViewCell()
        default:
            return emptyCell ?? UITableViewCell()
        }
        //        if indexPath.row == 0 || indexPath.row == 2 {
        //            return emptyCell  ?? UITableViewCell()
        //        } else {
        //            if indexPath.row - 1 <= settings.count - 1 {
//                cell?.fill(settingsModel: settings[indexPath.row - 1])
//                return cell ?? UITableViewCell()
//            } else {
//                return UITableViewCell()
//            }
//        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
