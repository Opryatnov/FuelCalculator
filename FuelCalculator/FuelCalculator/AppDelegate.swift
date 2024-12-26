import UIKit
import FirebaseCore
import AppTrackingTransparency
import AdSupport
import Appodeal

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.requestTrackingAuthorization()
        }
        FirebaseApp.configure()
        Appodeal.setInitializationDelegate(self)
        Appodeal.initialize(
            withApiKey: "d724c30afa39cc0753abd83b7c0d78639642519f9f53142d",
            types: [.interstitial, .banner]
        )
        fetchCurrencies()
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    private func fetchCurrencies() {
        NetworkService.shared.getCurrencyList(networkProvider: NetworkRequestProviderImpl()) { result in
            switch result {
            case .success:
                break
            case .failure:
                break
            }
        }
    }
    
    @objc private func requestTrackingAuthorization() {
        if #available(iOS 14, *) {
            ATTrackingManager.requestTrackingAuthorization { status in
                switch status {
                case .authorized:
                    print("Tracking authorization status: Authorized")
                case .denied:
                    print("Tracking authorization status: Denied")
                case .restricted:
                    print("Tracking authorization status: Restricted")
                case .notDetermined:
                    print("Tracking authorization status: Not Determined")
                @unknown default:
                    print("Tracking authorization status: Unknown")
                }
            }
        } else {
            print("Tracking authorization is not available for iOS versions below 14.0")
        }
    }
}

extension AppDelegate: AppodealInitializationDelegate {
    func appodealSDKDidInitialize() {
        // Appodeal SDK did complete initialization
    }
}
