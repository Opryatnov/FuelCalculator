import UIKit
import SnapKit

final class SettingsTableViewCell: BaseTableViewCell {
    
    // MARK: Constants
    
    private enum Constants {
        static let insets: CGFloat = 20
    }
    
    // MARK: UI
    
    private let settingsTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 17)
        
        return label
    }()
    
    private let settingsImageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(resource: .selected)
        
        return view
    }()
    
    // MARK: Internal properties
    
    static let identifier: String = "SettingsTableViewCell"
    
    // MARK: Internal methods
    
    func fill(settingsModel: Settings) {
        settingsTitleLabel.text = settingsModel.title
        settingsImageView.image = settingsModel.icon
    }
    
    // MARK: Private methods
    
    override func configureViews() {
        backgroundColor = .clear
        contentView.addSubview(settingsTitleLabel)
        contentView.addSubview(settingsImageView)
    }
    
    override func setupConstraints() {
        settingsTitleLabel.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(Constants.insets)
            $0.leading.equalToSuperview().inset(Constants.insets)
            $0.trailing.equalTo(settingsImageView.snp.leading).inset(Constants.insets)
        }
        
        settingsImageView.snp.makeConstraints {
            $0.centerY.equalTo(settingsTitleLabel)
            $0.trailing.equalToSuperview().inset(Constants.insets)
            $0.width.height.equalTo(30)
        }
    }
}
