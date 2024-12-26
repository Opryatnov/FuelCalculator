import UIKit
import SnapKit

final class HelloMototAppCell: BaseTableViewCell {
    
    // MARK: Constants
    
    private enum Constants {
        static let insets: CGFloat = 5
    }
    
    // MARK: UI
    
    private let mainView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        
        return view
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17)
        label.textColor = .black
        label.numberOfLines = 0
        label.text = LS("HELLO.MOTO.DESCRIPTION")
        
        return label
    }()
    
    private let getAppLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 20)
        label.textColor = .black
        label.numberOfLines = 0
        label.textAlignment = .center
        label.backgroundColor = UIColor(resource: .cyan50)
        label.layer.cornerRadius = 16
        label.text = LS("DOWNLOAD.NOW.TITLE")
        
        return label
    }()
    
    private let settingsImageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(resource: .logo)
        
        return view
    }()
    
    // MARK: Internal properties
    
    static let identifier: String = "HelloMototAppCell"
    
    // MARK: Internal methods
    
    func fill() {}
    
    // MARK: Private methods
    
    override func configureViews() {
        backgroundColor = .clear
        contentView.addSubview(mainView)
        mainView.addSubview(descriptionLabel)
        mainView.addSubview(getAppLabel)
        mainView.addSubview(settingsImageView)
    }
    
    override func setupConstraints() {
        mainView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(Constants.insets)
            $0.leading.trailing.equalToSuperview().inset(Constants.insets)
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(10)
            $0.leading.trailing.equalToSuperview().inset(10)
        }
        
        settingsImageView.snp.makeConstraints {
            $0.top.equalTo(descriptionLabel.snp.bottom).inset(-20)
            $0.leading.trailing.equalToSuperview().inset(Constants.insets)
        }
        
        getAppLabel.snp.makeConstraints {
            $0.top.equalTo(settingsImageView.snp.bottom).inset(-20)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(40)
            $0.bottom.equalToSuperview().inset(20)
        }
    }
}
