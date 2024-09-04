import UIKit
import Combine
import GoogleMobileAds

final class FuelCalculatorViewController: UIViewController {
    
    // MARK: Constants
    
    private enum Constants {
        static let tableViewBottomInset: CGFloat = 20
        static let tableViewAdditionalInset: CGFloat = 15
        static let tableViewContentInset: CGFloat = 20
        static let isHasNoughtHeight: CGFloat = 85
        
        enum CurrencyCodeLabel {
            static let insets: CGFloat = 5
            static let topInset: CGFloat = 2
            static let bottomInset: CGFloat = 5
        }
        
        enum CurrencyView {
            static let leftInset: CGFloat = 16
            static let height: CGFloat = 56
        }
        
        enum CurrencyImageView {
            static let leftInset: CGFloat = 5
        }
        
        enum VerticalView {
            static let width: CGFloat = 20
        }
        
        enum TextField {
            static let leftInset: CGFloat = 5
            static let rightInset: CGFloat = 16
        }
    }
    
    // MARK: UI
    
    private var bannerView: GADBannerView!
    private var emptyButton: DashedBorderButton?
    
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
    
    private let currencyView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(resource: .darkGray5)
        view.layer.cornerRadius = 12
        
        return view
    }()
    
    private let currencyImageView: UIImageView = {
        let imageView = UIImageView()
        
        return imageView
    }()
    
    let currencyCodeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        
        return label
        
    }()
    
    private let selectCurrencyImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(resource: .arrowDown)
        
        return imageView
    }()
    
    private let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(resource: .darkGray6)
        
        return view
    }()
    
    private let actionView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.isUserInteractionEnabled = true
        
        return view
    }()
    
    private let textField: UITextField = {
        let textField = UITextField()
        textField.keyboardType = .decimalPad
        textField.textColor = .white
        textField.textAlignment = .right
        
        return textField
    }()
    
    // MARK: Private properties
    
    private var fuelList: [Fuel]?
    private let userDefaultsManager = UserDefaultsManager.shared
    private var cancellables = Set<AnyCancellable>()
    var selectedCurrency: CurrencyData?
    private var favoriteFuelCode: [String]? {
        userDefaultsManager.getFavoriteFuelCode()
    }
    private var favoriteCurrencyCode: Int? {
        userDefaultsManager.getFavoriteCurrencyCode()
    }
    
    private var textFieldCalculatedWidth: CGFloat {
        view.frame.size.width -
        32 -
        selectCurrencyImageView.frame.size.width -
        Constants.CurrencyView.leftInset -
        currencyImageView.frame.size.width -
        Constants.CurrencyImageView.leftInset -
        Constants.CurrencyCodeLabel.insets -
        currencyCodeLabel.intrinsicContentSize.width -
        Constants.TextField.leftInset -
        Constants.TextField.rightInset
    }
    
    private var interstitial: GADInterstitialAd?
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(resource: .darkGray6)
        configureNavigationBar()
        addSubViews()
        setupConstraints()
        setupTableView()
        fillTextField()
        setupSelectCurrencyAction()
        updateEmptyView()
        bind()
        configureBannerView()
        setupScreenViewADS()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if self.favoriteCurrencyCode == nil {
            self.userDefaultsManager.setFavoriteCurrencyCode(0)
        }
    }
    
    // MARK: Private methods
    
    private func configureBannerView() {
        let viewWidth = view.frame.inset(by: view.safeAreaInsets).width
        let adaptiveSize = GADCurrentOrientationAnchoredAdaptiveBannerAdSizeWithWidth(viewWidth)
        bannerView = GADBannerView(adSize: adaptiveSize)
        view.addSubview(bannerView)
        
        let topInset = UIDevice.hasNotch ? Constants.isHasNoughtHeight + 15 : (tabBarController?.tabBar.frame.size.height ?? 50) + Constants.tableViewAdditionalInset
        bannerView.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(topInset)
        }
        
        bannerView.adUnitID = AppConstants.googleBannerADKey
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
    }
    
    private func bind() {
        cancellables.removeAll()
        userDefaultsManager.$isChangedFuelFavoriteList
            .sink { _ in
                self.fetchFuelFromDefaults()
            }
            .store(in: &cancellables)
        
        userDefaultsManager.$isChangedFavoriteList
            .sink { _ in
                self.configureSelectedCurrency()
            }
            .store(in: &cancellables)
    }
    
    private func updateEmptyView() {
           if fuelList?.isEmpty == true || fuelList == nil {
               if emptyButton == nil {
                   let button = DashedBorderButton(type: .system)
                   button.setTitle(LS("HAS.NOT.SELECTED.CURRENCIES.TITLE"), for: .normal)
                   button.setTitleColor(.white, for: .normal)
                   button.backgroundColor = UIColor(resource: .gray20)
                   button.setImage(UIImage(resource: .addIcon).withRenderingMode(.alwaysOriginal), for: .normal) // Replace "icon" with your image name
                   button.tintColor = .white
                   button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -10, bottom: 0, right: 0)
                   button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
                   
                   view.addSubview(button)
                   button.snp.makeConstraints {
                       $0.centerY.centerX.equalToSuperview()
                       $0.width.equalTo(UIScreen.main.bounds.width - 50)
                       $0.height.equalTo(56)
                   }
                   
                   emptyButton = button
                   emptyButton?.addTarget(self, action: #selector(selectFuel), for: .touchUpInside)
               }
           } else {
               emptyButton?.removeFromSuperview()
               emptyButton = nil
           }
       }
    
    private func setupSelectCurrencyAction() {
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(selectCurrency))
        actionView.addGestureRecognizer(tapRecognizer)
    }
    
    private func configureSelectedCurrency() {
        selectedCurrency = NetworkService.shared.fetchedCurrencies?.first(where: { $0.currencyID == favoriteCurrencyCode })
        currencyImageView.image = selectedCurrency?.currencyImage
        currencyCodeLabel.text = selectedCurrency?.currencyAbbreviation
        tableView.reloadData()
    }
    
    private func addSubViews() {
        view.addSubview(currencyView)
        view.addSubview(tableView)
        
        currencyView.addSubview(selectCurrencyImageView)
        currencyView.addSubview(currencyImageView)
        currencyView.addSubview(currencyCodeLabel)
        currencyView.addSubview(separatorView)
        currencyView.addSubview(actionView)
        currencyView.addSubview(textField)
    }
    
    private func setupConstraints() {
        currencyView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.leading.trailing.equalToSuperview().inset(Constants.CurrencyView.leftInset)
            $0.height.equalTo(Constants.CurrencyView.height)
        }
        tableView.snp.makeConstraints {
            $0.top.equalTo(currencyView.snp.bottom).inset(-10)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview().inset((self.tabBarController?.tabBar.frame.height ?? .zero) + Constants.tableViewAdditionalInset)
        }
        selectCurrencyImageView.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(Constants.CurrencyView.leftInset)
            $0.centerY.equalToSuperview()
        }
        currencyImageView.snp.makeConstraints {
            $0.leading.equalTo(selectCurrencyImageView.snp.trailing).inset(-Constants.CurrencyImageView.leftInset)
            $0.centerY.equalToSuperview()
        }
        currencyCodeLabel.snp.makeConstraints {
            $0.leading.equalTo(currencyImageView.snp.trailing).inset(-Constants.CurrencyImageView.leftInset)
            $0.centerY.equalToSuperview()
        }
        separatorView.snp.makeConstraints {
            $0.leading.equalTo(currencyCodeLabel.snp.trailing).inset(-Constants.VerticalView.width)
            $0.top.bottom.equalToSuperview()
            $0.width.equalTo(0.5)
        }
        textField.snp.makeConstraints {
            $0.leading.equalTo(separatorView.snp.trailing).inset(-Constants.CurrencyImageView.leftInset)
            $0.top.bottom.equalToSuperview()
            $0.trailing.equalToSuperview().inset(10)
            $0.width.equalTo(textFieldCalculatedWidth).priority(.high)
        }
        actionView.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.top.bottom.equalToSuperview()
            $0.trailing.equalTo(separatorView.snp.leading)
        }
    }
    
    private func setupTableView() {
        tableView.contentInset.bottom = Constants.tableViewContentInset
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(FuelCalculatorCell.self, forCellReuseIdentifier: FuelCalculatorCell.identifier)
    }
    
    private func fillTextField() {
        textField.delegate = self
        textField.addDoneButtonOnKeyboard()
        configureTextFieldPlaceholder()
    }
    
    private func configureTextFieldPlaceholder() {
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor(resource: .gray30),
            .font: UIFont.systemFont(ofSize: 16)
        ]
        
        textField.attributedPlaceholder = NSAttributedString(string: LS("WRITE.SUM.PLACEHOLDER"), attributes: attributes)
    }
    
    private func fetchFuelFromDefaults() {
        fuelList = []
        do {
            if let data = UserDefaults.standard.data(forKey: "fuelList") {
                let decoder = JSONDecoder()
                let fuelList = try decoder.decode([Fuel].self, from: data)
                self.favoriteFuelCode?.forEach { code in
                    if let fuel = fuelList.first(where: { $0.fuelCode == code}) {
                        self.fuelList?.append(fuel)
                    }
                }
                updateEmptyView()
                tableView.reloadData()
            }
        } catch {
            showError(message: error.localizedDescription)
        }
    }
    
    private func configureNavigationBar() {
        let textAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        navigationController?.navigationBar.topItem?.title = LS("FUEL.CALCULATOR.TAB.TITLE")
    }
    
    private func showError(message: String?) {
        let closeAction = [
            UIAlertAction(title: LS("ALERT.CLOSE.BUTTON"), style: .cancel)
        ]
        showAlert(message: message, buttons: closeAction, viewController: self)
    }
    
    private func setupScreenViewADS() {
        let request = GADRequest()
        GADInterstitialAd.load(withAdUnitID: AppConstants.googleVideoADKey, request: request) { (ad, error) in
            if let error = error {
                print("Failed to load interstitial ad with error: \(error.localizedDescription)")
                return
            }
            self.interstitial = ad
            self.interstitial?.fullScreenContentDelegate = self
        }
    }
   
    @objc
    private func selectCurrency() {
        guard let interstitial = interstitial else {
            showCurrencyScreen()
            return
        }
        
        showInterstitial()
    }
    
    func showInterstitial() {
        if let interstitial = interstitial {
            interstitial.present(fromRootViewController: self)
        }
    }
    
    private func showCurrencyScreen() {
        let selectCurrencyViewController = CurrencyListViewController(nibName: nil, bundle: nil)
        selectCurrencyViewController.hidesBottomBarWhenPushed = true
        selectCurrencyViewController.delegate = self
        self.navigationController?.pushViewController(selectCurrencyViewController, animated: true)
    }
    
    @objc
    private func selectFuel() {
        let selectFuelViewController = FuelListViewController(nibName: nil, bundle: nil)
        selectFuelViewController.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(selectFuelViewController, animated: true)
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
        if let fuel = fuelList?[indexPath.row],
        let selectedCurrency = NetworkService.shared.fetchedCurrencies?.first(where: { $0.currencyID == favoriteCurrencyCode }){
            cell?.fill(fuel: fuel, currency: selectedCurrency)
            cell?.delegate = self
        }
        return cell ?? UITableViewCell()
    }
}

extension FuelCalculatorViewController: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        currencyView.layer.borderWidth = 0
        currencyView.layer.borderColor = UIColor.clear.cgColor
        if textField.text?.isEmpty == true {
            configureTextFieldPlaceholder()
        } else {
            let receiveAmountString = textField.text?.replacingOccurrences(of: ",", with: "") ?? ""
            textField.text = receiveAmountString.toAmountFormat()
            selectedCurrency?.writeOfAmount = receiveAmountString.toDouble()
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.addDoneButtonOnKeyboard()
        textField.placeholder = nil
        textField.text = nil
        currencyView.layer.borderWidth = 1
        currencyView.layer.borderColor = UIColor(resource: .gold1).cgColor
        fuelList?.enumerated().forEach { (index, fuelModel) in
            tableView.beginUpdates()
            let indexPath = IndexPath(row: index, section: 0)
            tableView.reloadRows(at: [indexPath], with: .none)
            tableView.endUpdates()
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let inputValidator = ValidationFieldType.balanceInputTwoNumbersCurrencyAfterPoint
        
        guard let textFieldText = textField.text,
              let range = Range(range, in: textFieldText) else { return true }
        var updatedText = textFieldText.replacingCharacters(in: range, with: string)
        
        if updatedText.suffix(1) == "," {
            let lastIndex = updatedText.index(before: updatedText.endIndex)
            updatedText.replaceSubrange(lastIndex...lastIndex, with: ["."])
        }
        let balanceString = updatedText.replacingOccurrences(of: ",", with: "")
        
        let result = Validator.isValid(balanceString, type: inputValidator)
        
        if result {
            let balance = Decimal(string: balanceString) ?? 0
            let lastDot: String
            if balanceString.suffix(1) == "." {
                lastDot = "."
            } else {
                lastDot = ""
            }
            var minimumFractionDigits = 0
            if let dotRange = balanceString.range(of: ".") {
                let substring = balanceString[dotRange.upperBound...]
                minimumFractionDigits = substring.count
            }
            let finalString = balance.formattedWithSeparator(minimumFractionDigits) + lastDot
            textField.text = finalString
        }
        
        let receiveAmountString = textField.text?.replacingOccurrences(of: ",", with: "") ?? ""
        selectedCurrency?.writeOfAmount = receiveAmountString.toDouble()
        fuelList?.enumerated().forEach { (index, fuelModel) in
            tableView.beginUpdates()
            let indexPath = IndexPath(row: index, section: 0)
            tableView.reloadRows(at: [indexPath], with: .none)
            tableView.endUpdates()
        }
        return false
    }
}

extension FuelCalculatorViewController: FuelCalculatorCellDelegate {
    func didChangeAmount(amount: Double, fuel: Fuel?) {
        selectedCurrency?.writeOfAmount = amount > 0 ? amount : nil
        textField.text = amount > 0 ? amount.description : nil
        if selectedCurrency?.writeOfAmount == nil {
            configureTextFieldPlaceholder()
        }
        fuelList?.enumerated().forEach { (index, fuelModel) in
            if fuel?.fuelCode != fuelModel.fuelCode {
                if amount == 0 {
                    fuel?.writeOfCount = nil
                }
                tableView.beginUpdates()
                let indexPath = IndexPath(row: index, section: 0)
                tableView.reloadRows(at: [indexPath], with: .none)
                tableView.endUpdates()
            }
        }
    }
}

extension FuelCalculatorViewController: GADFullScreenContentDelegate {
    func ad(_ ad: GADFullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
        showCurrencyScreen()
    }
    
    func adWillPresentFullScreenContent(_ ad: GADFullScreenPresentingAd) {
    }
    
    func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        setupScreenViewADS()
    }
    
    func adWillDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        showCurrencyScreen()
    }
}

extension FuelCalculatorViewController: CurrencyListViewControllerDelegate {
    func didUpdate() {
        currencyView.layer.borderWidth = 0
        currencyView.layer.borderColor = UIColor.clear.cgColor
        if textField.text?.isEmpty == true {
            configureTextFieldPlaceholder()
        } else {
            let receiveAmountString = textField.text?.replacingOccurrences(of: ",", with: "") ?? ""
            textField.text = receiveAmountString.toAmountFormat()
            selectedCurrency?.writeOfAmount = receiveAmountString.toDouble()
        }
        tableView.reloadData()
    }
}
