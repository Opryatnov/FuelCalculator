import UIKit

extension SplashScreenViewController {
    
    enum TimeOfDay {
        case morning
        case day
        case evening
        case night
        
        var timeOfDayTitle: String {
            switch self {
            case .morning:
                return LS("SPLASH.MORNING.TITLE")
            case .day:
                return LS("SPLASH.DAY.TITLE")
            case .evening:
                return LS("SPLASH.EVENING.TITLE")
            case .night:
                return LS("SPLASH.NIGHT.TITLE")
            }
        }
        
        var timeOfDayBackground: UIImage? {
//            switch self {
//            case .morning:
//                return UIImage(named: .morning)
//            case .day:
//                return UIImage(named: .day)
//            case .evening:
//                return UIImage(named: .evening)
//            case .night:
//                return UIImage(named: .night)
//            }
            UIImage(named: .splashBackground)
        }
        
        var timeOfDayIcon: UIImage? {
            switch self {
            case .morning:
                return UIImage(named: .morning)
            case .day:
                return UIImage(named: .day)
            case .evening:
                return UIImage(named: .evening)
            case .night:
                return UIImage(named: .night)
            }
        }
    }
}
