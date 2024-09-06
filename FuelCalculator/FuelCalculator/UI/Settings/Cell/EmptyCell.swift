import UIKit
import SnapKit

final class EmptyTableViewCell: BaseTableViewCell {
    
    // MARK: UI
    
    private let emptyView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        
        return view
    }()
    
    // MARK: Internal properties
    
    static let identifier: String = "EmptyTableViewCell"
    
    // MARK: Private methods
    
    override func configureViews() {
        backgroundColor = .clear
        contentView.addSubview(emptyView)
    }
    
    override func setupConstraints() {
        emptyView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.trailing.trailing.equalToSuperview()
            $0.height.equalTo(10)
        }
    }
}
