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
    
    func setFavoriteCurrenciesCode(_ favoriteCurrenciesCode: Int) {
        var tempCurrenciesCode: [Int] = userDefaults.array(forKey: Key.currenciesKey) as? [Int] ?? []
        tempCurrenciesCode.append(favoriteCurrenciesCode)
        userDefaults.set(tempCurrenciesCode.unique, forKey: Key.currenciesKey)
    }
    
    func removeFavorite(_ favoriteCurrenciesCode: Int) {
        var tempCurrenciesCode: [Int] = userDefaults.array(forKey: Key.currenciesKey) as? [Int] ?? []
        tempCurrenciesCode.removeAll(where: { $0 == favoriteCurrenciesCode })
        
        userDefaults.set(tempCurrenciesCode.unique, forKey: Key.currenciesKey)
    }
    
    func getFavoriteCurrenciesCode() -> [Int]? {
        guard let currenciesCode = userDefaults.array(forKey: Key.currenciesKey) as? [Int] else { return nil }
        return currenciesCode
    }
}

extension UserDefaultsManager {
    
    // MARK: Constants
    
    enum Key {
        static let currenciesKey = "FavoriteCurrencies"
    }
}
