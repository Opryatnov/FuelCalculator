//
//  UserDefaultsManager.swift
//  FuelCalculator
//
//  Created by Dmitriy Opryatnov on 1.08.24.
//

import Foundation
import Combine

final class UserDefaultsManager {
    
    static let shared = UserDefaultsManager()
    
    private init() {}
        
    private let userDefaults = UserDefaults.standard
    @Published var isChangedFavoriteList: Bool?
    @Published var isChangedFuelFavoriteList: Bool?
    
    func setFavoriteCurrencyCode(_ favoriteCurrencyCode: Int) {
        userDefaults.set(favoriteCurrencyCode, forKey: Key.currenciesKey)
    }
    
    func setFavoriteFuelCode(_ favoriteFuelCode: String) {
        var tempFuelCode: [String] = userDefaults.array(forKey: Key.fuelKey) as? [String] ?? []
        tempFuelCode.append(favoriteFuelCode)
        userDefaults.set(tempFuelCode.unique, forKey: Key.fuelKey)
    }
    
    func removeFavoriteFuel(_ favoriteFuelCode: String) {
        var tempFuelCode: [String] = userDefaults.array(forKey: Key.fuelKey) as? [String] ?? []
        tempFuelCode.removeAll(where: { $0 == favoriteFuelCode })
        
        userDefaults.set(tempFuelCode.unique, forKey: Key.fuelKey)
    }
    
    func removeFavorite() {
        userDefaults.set(nil, forKey: Key.currenciesKey)
    }
    
    func getFavoriteCurrencyCode() -> Int? {
        userDefaults.integer(forKey: Key.currenciesKey)
    }
    
    func getFavoriteFuelCode() -> [String]? {
        guard let fuelCode = userDefaults.array(forKey: Key.fuelKey) as? [String] else { return nil }
        return fuelCode
    }
}

extension UserDefaultsManager {
    
    // MARK: Constants
    
    enum Key {
        static let currenciesKey = "FavoriteCurrencies"
        static let fuelKey = "FavoriteFuel"
    }
}
