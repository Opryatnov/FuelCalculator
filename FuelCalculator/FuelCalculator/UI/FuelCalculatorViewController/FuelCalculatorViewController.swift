import UIKit
import WebKit

final class FuelCalculatorViewController: UIViewController {
    
    // MARK: Constants
    
    private enum Constants {
        static let tableViewBottomInset: CGFloat = 20
        static let tableViewAdditionalInset: CGFloat = 15
        static let tableViewContentInset: CGFloat = 20
        
        static let url = URL(string: "https://azs.belorusneft.by/sitebeloil/ru/center/azs/center/fuelandService/price/")
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
    
    private let webView: WKWebView = {
        let prefs = WKPreferences()
        //        prefs.javaScriptEnabled = true
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
    
    private let parser = HTMLParser()
    private var fuelList: [Fuel]?
    
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
        tableView.register(FuelCalculatorCell.self, forCellReuseIdentifier: FuelCalculatorCell.identifier)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchCurrencies()
    }
    
    // MARK: Private methods
    
    private func fetchCurrencies() {
        HUD.shared.show()
        NetworkService.shared.getCurrencyList(networkProvider: NetworkRequestProviderImpl()) { result in
            switch result {
            case .success:
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    self.getFuelList()
                }
            case .failure:
                HUD.shared.hide()
                break
            }
        }
    }
    
    private func configureNavigationBar() {
        let textAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        navigationController?.navigationBar.topItem?.title = LS("FUEL.CALCULATOR.TAB.TITLE")
    }
    
    private func getFuelList() {
        guard let url = Constants.url else { return }
        webView.load(URLRequest(url: url))
        webView.navigationDelegate = self
    }
    
    private func showError(message: String?) {
        let closeAction = [
            UIAlertAction(title: LS("ALERT.CLOSE.BUTTON"), style: .cancel)
        ]
        showAlert(message: message, buttons: closeAction, viewController: self)
    }
}

// MARK: - UITableViewDelegate, - UITableViewDataSource

extension FuelCalculatorViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        fuelList?.count ?? .zero
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FuelCalculatorCell.identifier, for: indexPath) as? FuelCalculatorCell
        cell?.selectionStyle = .none
        if let fuel = fuelList?[indexPath.row] {
            cell?.fill(fuel: fuel)
        }
        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        if let currency = currencies?[indexPath.row] {
//            currency.isSelected.toggle()
//            tableView.reloadData()
//        }
    }
}


extension FuelCalculatorViewController: WKNavigationDelegate {
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
                    
                    if let data = UserDefaults.standard.data(forKey: "fuelList") {
                        let decoder = JSONDecoder()
                        let fuelList = try decoder.decode([Fuel].self, from: data)
                        self?.fuelList = fuelList
                        self?.tableView.reloadData()
                        HUD.shared.hide()
                    }
                } catch {
                    HUD.shared.hide()
                    self?.showError(message: error.localizedDescription)
                }
            } errorCompletion: { [weak self] error in
                HUD.shared.hide()
                self?.showError(message: error?.localizedDescription)
            }
        }
    }
}
