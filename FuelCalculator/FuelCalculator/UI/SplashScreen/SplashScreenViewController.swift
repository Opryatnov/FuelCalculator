//
//  SplashScreenViewController.swift
//  CurrencyConverter
//
//  Created by Opryatnov on 7.05.24.
//

import UIKit

final class SplashScreenViewController: UIViewController {
    
    enum Constants {
        static let screenTimeInSeconds: Double = 1.7
        
        enum TimeOfDayConstants {
            static let startDayTime: String = "12:00"
            static let endDayTime: String = "17:00"
            static let endEveningTime: String = "00:00"
            static let endNightTime: String = "04:00"
            static let dateFormat: String = "HH:mm"
        }
        
        enum Insets {
            static let topBottomInset: CGFloat = 4
            static let indents: CGFloat = 24
            static let additionalAnimatedInset: CGFloat = 48
            static let logoImageHeight: CGFloat = 434
        }
        
        enum AnimationConstants {
            static let firstDuration: Double = 0.5
            static let secondDuration: Double = 2.0
        }
    }
    
    // MARK: UI
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .bold(ofSize: 28)
        label.textColor = .init(named: .white)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private let backgroundImageView: UIImageView = {
        let view = UIImageView()
        return view
    }()
    
    private let timeOfDayIconImageView: UIImageView = {
        let view = UIImageView()
        view.alpha = 0
        return view
    }()
    
    private let animatedLogoImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        return view
    }()
    
    private let elementsView: UIView = {
        let view = UIView()
        return view
    }()
    
    // MARK: Internal properties
    
    var closeAction: (() -> Void)?
    
    // MARK: Private properties
    
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        view.backgroundColor = .red
        addSubviews()
        setupConstraints()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animateImageView()
        closeScreen(after: Constants.screenTimeInSeconds)
    }
    
     func addSubviews() {
        view.addSubview(backgroundImageView)
        backgroundImageView.addSubview(elementsView)
        elementsView.addSubview(timeOfDayIconImageView)
        elementsView.addSubview(titleLabel)
        backgroundImageView.addSubview(animatedLogoImageView)
    }
    
     func setupConstraints() {
        
        backgroundImageView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.bottom.equalToSuperview()
        }
        
        elementsView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.centerY.equalToSuperview().offset(-125)
        }
        
        timeOfDayIconImageView.snp.makeConstraints {
            $0.top.equalTo(elementsView.snp.top).inset(Constants.Insets.topBottomInset)
            $0.centerX.equalTo(elementsView)
            $0.bottom.equalTo(titleLabel.snp.top).inset(-Constants.Insets.indents)
        }
        
        titleLabel.snp.makeConstraints {
            $0.leading.trailing.equalTo(elementsView).inset(Constants.Insets.indents)
            $0.bottom.equalTo(elementsView.snp.bottom).inset(Constants.Insets.topBottomInset)
        }
        
        animatedLogoImageView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(backgroundImageView.snp.bottom)
        }
    }
    
    // MARK: Internal methods
    
    func getTimeOfDay(date: String) -> TimeOfDay? {
        var timeOfDay: TimeOfDay?
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = Constants.TimeOfDayConstants.dateFormat
        
        guard let startDayTimeFromString = dateFormatter.date(from: Constants.TimeOfDayConstants.startDayTime),
              let endDayTimeFromString = dateFormatter.date(from: Constants.TimeOfDayConstants.endDayTime),
              let endEveningTimeFromString = dateFormatter.date(from: Constants.TimeOfDayConstants.endEveningTime),
              let endNightTimeFromString = dateFormatter.date(from: Constants.TimeOfDayConstants.endNightTime),
              let currentTime = dateFormatter.date(from: date) else { return nil }
        
        if currentTime >= startDayTimeFromString && currentTime < endDayTimeFromString {
            timeOfDay = .day
        } else if currentTime >= endDayTimeFromString && currentTime > endEveningTimeFromString {
            timeOfDay = .evening
        } else if currentTime >= endEveningTimeFromString && currentTime < endNightTimeFromString {
            timeOfDay = .night
        } else if currentTime >= endNightTimeFromString && currentTime < startDayTimeFromString {
            timeOfDay = .morning
        }
        return timeOfDay
    }
    
    // MARK: Private methods
    
    private func setupUI() {
        if let timeOfDay = getTimeOfDay(date: currentTime()) {
            backgroundImageView.image = timeOfDay.timeOfDayBackground
            timeOfDayIconImageView.image = timeOfDay.timeOfDayIcon
            
            let titleText = [timeOfDay.timeOfDayTitle]
                .compactMap { $0 }
                .joined(separator: ",\n")
            titleLabel.text = titleText
        }
    }
    
    private func currentTime() -> String {
        let date = Date()
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        let minutes = calendar.component(.minute, from: date)
        return "\(hour):\(minutes)"
    }
    
    private func animateImageView() {
        let firstBottomInset = Constants.Insets.logoImageHeight - Constants.Insets.additionalAnimatedInset
        let secondBottomInset = firstBottomInset + Constants.Insets.additionalAnimatedInset
        
        UIView.animate(withDuration: Constants.AnimationConstants.firstDuration, animations: {
            self.animatedLogoImageView.transform = CGAffineTransform(translationX: 0, y: -firstBottomInset)
            self.elementsView.transform = CGAffineTransform(translationX: 0, y: -Constants.Insets.additionalAnimatedInset)
            self.timeOfDayIconImageView.alpha = 1
        }, completion: {_ in
            UIView.animate(withDuration: Constants.AnimationConstants.secondDuration) {
                self.animatedLogoImageView.transform = CGAffineTransform(translationX: 0, y: -secondBottomInset)
            }
        })
    }
    
    private func closeScreen(after seconds: Double) {
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds, execute: {
            self.dismiss(animated: true, completion: {
                self.closeAction?()
            })
        })
    }
}
