//
//  SettingsViewController.swift
//  FuelCalculator
//
//  Created by Opryatnov on 6.09.24.
//

import StoreKit
import UIKit

enum Settings: String, CaseIterable {
    case firstEmpty
    case settings
    case secondEmpty
    case thirdEmpty
    case feedBack
    case fourthEmpty
    case shareTheApp
    
    var title: String {
        switch self {
        case .settings:
            LS("MENU.SETTINGS.TITLE")
        case .feedBack:
            LS("MENU.FEEDBACK.TITLE")
        case .shareTheApp:
            LS("MENU.SHARE.THE.APP")
        case .firstEmpty, .secondEmpty, .thirdEmpty, .fourthEmpty:
            ""
        }
    }
    
    var icon: UIImage {
        switch self {
        case .settings:
            UIImage(resource: .icAccountSettings)
        case .feedBack:
            UIImage(resource: .feedBackIcon)
        case .shareTheApp:
            UIImage(resource: .iconsShare)
        case .firstEmpty, .secondEmpty, .thirdEmpty, .fourthEmpty:
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
    
    private func openAppSettings() {
        guard let appSettings = URL(string: UIApplication.openSettingsURLString) else {
            return
        }
        if UIApplication.shared.canOpenURL(appSettings) {
            UIApplication.shared.open(appSettings)
        }
    }
    
    private func openAppStoreReviewPage() {
        guard let writeReviewURL = URL(string: "itms-apps://itunes.apple.com/app/id6636476826?action=write-review") else {
            return
        }
        if UIApplication.shared.canOpenURL(writeReviewURL) {
            UIApplication.shared.open(writeReviewURL, options: [:], completionHandler: nil)
        }
    }
    
    private func shareIt() {
        guard let urlToShare = URL(string: "https://apps.apple.com/by/app/%D0%BA%D0%B0%D0%BB%D1%8C%D0%BA%D1%83%D0%BB%D1%8F%D1%82%D0%BE%D1%80-%D1%82%D0%BE%D0%BF%D0%BB%D0%B8%D0%B2%D0%B0-%D1%80%D0%B1/id6636476826") else { return }
        let textToShare = LS("FUEL.CALCULATOR.TAB.TITLE")
        
        let itemsToShare = [textToShare, urlToShare] as [Any]
        let activityViewController = UIActivityViewController(activityItems: itemsToShare, applicationActivities: nil)

        activityViewController.excludedActivityTypes = [
            UIActivity.ActivityType.postToFacebook,
            UIActivity.ActivityType.postToTwitter
        ]

        self.present(activityViewController, animated: true, completion: nil)
    }
    
    private func feedBack() {
        let linkedInURLString = "https://www.linkedin.com/in/opryatnov-dmitry-21342bb4"
        if let url = URL(string: linkedInURLString), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            print("Невозможно открыть ссылку на профиль LinkedIn")
        }
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
        emptyCell?.selectionStyle = .none
        let model = settings[indexPath.row]
        
        switch model {
        case .feedBack, .settings, .shareTheApp:
            cell?.fill(settingsModel: settings[indexPath.row])
            return cell ?? UITableViewCell()
        default:
            return emptyCell ?? UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = settings[indexPath.row]
        switch model {
        case .feedBack:
            feedBack()
        case .settings:
            openAppSettings()
        case .shareTheApp:
            shareIt()
        default:
            break
        }
    }
}
