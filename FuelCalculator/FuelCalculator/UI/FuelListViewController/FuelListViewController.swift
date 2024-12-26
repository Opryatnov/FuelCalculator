import UIKit
@preconcurrency import WebKit
import Appodeal

final class FuelListViewController: UIViewController {
    
    // MARK: Constants
    
    private enum Constants {
        static let tableViewBottomInset: CGFloat = 20
        static let tableViewAdditionalInset: CGFloat = 15
        static let tableViewContentInset: CGFloat = 61
        static let url = URL(string: AppConstants.fuelListRequest)
        static let isHasNoughtHeight: CGFloat = 85
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
    
    // MARK: Private properties
    
    private var fuelList: [Fuel]?
    private let userDefaultsManager = UserDefaultsManager.shared
    private let parser = HTMLParser()
    
    private let webView: WKWebView = {
        let prefs = WKPreferences()
        let pagePrefs = WKWebpagePreferences()
        if #available(iOS 14.0, *) {
            pagePrefs.allowsContentJavaScript = true
        }
        let config = WKWebViewConfiguration()
        config.preferences = prefs
        config.defaultWebpagePreferences = pagePrefs
        let webView = WKWebView(frame: .zero, configuration: config)
        webView.translatesAutoresizingMaskIntoConstraints = false
        
        return webView
    }()
    
    private var favoriteFuelCode: [String]? {
        userDefaultsManager.getFavoriteFuelCode()
    }
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(resource: .darkGray6)
        configureNavigationBar()
        addSubViews()
        setupConstraints()
        setupTableView()
        fetchFuel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Appodeal.showAd(.bannerBottom, rootViewController: self)
    }
    
    // MARK: Private methods
    
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
        tableView.register(FuelTableViewCell.self, forCellReuseIdentifier: FuelTableViewCell.identifier)
    }
    
    private func configureNavigationBar() {
        let textAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        navigationController?.navigationBar.topItem?.title = LS("FUEL.LIST.TAB.TITLE")
    }
    
    private func showError(message: String?) {
        let closeAction = [
            UIAlertAction(title: LS("ALERT.CLOSE.BUTTON"), style: .cancel)
        ]
        showAlert(message: message, buttons: closeAction, viewController: self)
    }
    
    private func fetchFuelFromDefaults() {
        do {
            if let data = UserDefaults.standard.data(forKey: "fuelList") {
                let decoder = JSONDecoder()
                let fuelList = try decoder.decode([Fuel].self, from: data)
                self.fuelList = fuelList
                self.favoriteFuelCode?.forEach { code in
                    self.fuelList?.first(where: { $0.fuelCode == code})?.isSelected = true
                }
                tableView.reloadData()
            }
        } catch {
            showError(message: error.localizedDescription)
        }
    }
    
    private func fetchFuel() {
        HUD.shared.show()
        guard let url = Constants.url else { return }
        webView.load(URLRequest(url: url))
        webView.navigationDelegate = self
    }
}

// MARK: - UITableViewDelegate, - UITableViewDataSource

extension FuelListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        fuelList?.count ?? .zero
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FuelTableViewCell.identifier, for: indexPath) as? FuelTableViewCell
        cell?.selectionStyle = .none
        if let fuel = fuelList?[indexPath.row] {
            cell?.fill(fuel: fuel)
        }
        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let fuel = fuelList?[indexPath.row] {
            fuel.isSelected.toggle()
            guard let code = fuel.fuelCode else { return }
            if fuel.isSelected == true {
                userDefaultsManager.setFavoriteFuelCode(code)
            } else {
                userDefaultsManager.removeFavoriteFuel(code)
            }
            userDefaultsManager.isChangedFuelFavoriteList = true
            tableView.reloadData()
        }
    }
}

extension FuelListViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        if let serverTrust = challenge.protectionSpace.serverTrust {
            let credential = URLCredential(trust: serverTrust)
            completionHandler(.useCredential, credential)
        } else {
            completionHandler(.cancelAuthenticationChallenge, nil)
        }
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        print("Error occurred: \(error.localizedDescription)")
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        print("Provisional error occurred: \(error.localizedDescription)")
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        webView.evaluateJavaScript("document.body.innerHTML") { [weak self] result, error in
            guard let html = result as? String, error == nil else {
                HUD.shared.hide()
                return
            }
            
            self?.parser.parse(html: html) { [weak self] fuelList in
                do {
                    let encoder = JSONEncoder()
                    let data = try encoder.encode(fuelList)
                    UserDefaults.standard.set(data, forKey: "fuelList")
                    self?.fetchFuelFromDefaults()
                    HUD.shared.hide()
                } catch {
                    HUD.shared.hide()
                    self?.showError(message: error.localizedDescription)
                }
            } errorCompletion: { [weak self] error in
                HUD.shared.hide()
                self?.fetchFuelFromDefaults()
                self?.showError(message: error?.localizedDescription)
            }
        }
    }
}
