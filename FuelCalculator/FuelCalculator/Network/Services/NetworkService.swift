//
//  NetworkService.swift
//  CurrencyConverter
//
//  Created by Opryatnov on 29.04.24.
//

import UIKit
import Alamofire
import Combine

final class NetworkService {
    
    static let shared = NetworkService()
    private init() {}
    
    var fuelData: [Fuel]? = []
    private var allCurrencies: [CurrencyData]?
    @Published var fetchedCurrencies: [CurrencyData]?
    var currencyRates: [DynamicCources]?
    
    /// Получение курсов валют на текущую дату
    func getCurrencyList(networkProvider: NetworkRequestProvider?, completion: @escaping (Result<[CurrencyData]?, Error>) -> ()) {
        HUD.shared.show()
        CurrenciesManager.shared.fetchCurrencies()
        networkProvider?.fetchAllCurrencies(completion: { result in
            switch result {
            case .success(let currencies):
                CountriesManager.fetchAllCountries { countries in
                    currencies?.forEach { currency in
                        if let currencyImage = countries?.countries?.first(where: {$0.code == currency.currencyAbbreviation})?.decodedImage {
                            currency.currencyImage = currencyImage
                        } else if currency.currencyAbbreviation == "EUR" {
                            currency.currencyImage = UIImage(named: "European-Union-Flag-icon")
                        } else {
                            currency.currencyImage = UIImage(named: "sdr_image")
                        }
                        if let additionalCurrencyValues = CurrenciesManager.shared.allCurrencyData?.first(where: { $0.abbreviation == currency.currencyAbbreviation }) {
                            currency.name = additionalCurrencyValues.name
                            currency.nameBelarusian = additionalCurrencyValues.nameBelarusian
                            currency.nameEnglish = additionalCurrencyValues.nameEnglish
                        }
                    }
                    HUD.shared.hide()
                    self.allCurrencies = currencies
                    let belarusCurrency: CurrencyData = CurrencyData(
                        currencyID: 0,
                        date: nil,
                        currencyAbbreviation: "BYN",
                        currencyScale: 1,
                        currencyName: "Belarusian Ruble",
                        currencyOfficialRate: 0,
                        currencyImage: countries?.countries?.first(where: {$0.code == "BYN"})?.decodedImage,
                        isSelected: false,
                        name: "Белорусский рубль",
                        nameBelarusian: "Беларускі рубель",
                        nameEnglish: "Belarusian Ruble",
                        writeOfAmount: nil
                    )
                    self.allCurrencies?.insert(belarusCurrency, at: 0)
                    self.fetchedCurrencies = self.allCurrencies
                    completion(.success(currencies))
                }
            case .failure(let error):
                HUD.shared.hide()
                completion(.failure(error))
            }
        })
    }
    
    // Получение данных по топливу
    
    func fetchFuel(completion: @escaping (Result<[Fuel]?, Error>) -> ()) {
        HUD.shared.show()
        getFuel { result in
            switch result {
            case .success(let fuel):
                HUD.shared.hide()
                completion(.success(fuel))
            case .failure(let error):
                HUD.shared.hide()
                completion(.failure(error))
            }
        }
    }
    
    // MARK: Private methods
    
    private func getFuel(completion: @escaping (Result<[Fuel]?, Error>) -> ()) {
        AF.request("https://drive.usercontent.google.com/download?id=10gaA5Ee98tAFO3sBo3Eqx-yjzIlN2nsx&export=download&authuser=0&confirm=t&uuid=4687d842-c727-418a-b162-10dea18dbfae&at=APZUnTUMRATwmNz8dPzJ5oSawxQJ:1714991802396")
            .validate()
            .response { response in
                guard let data = response.data else {
                    if let error = response.error {
                        completion(.failure(error))
                    }
                    return
                }
                let jsonDecoder = JSONDecoder()
                guard let fuel: [Fuel] = try? jsonDecoder.decode([Fuel].self, from: data) else {
                    completion(.failure(NetworkingError.invalidData))
                    return
                }
                completion(.success(fuel))
            }
    }
    
    /// Получение динамики курсов по выбранной валюте
    func getCurrencyRates(
        networkProvider: NetworkRequestProvider?,
        currencyCode: Int,
        startDate: String,
        endDate: String,
        completion: @escaping (Result<[DynamicCources]?, Error>) -> ()
    ) {
        HUD.shared.show()
        networkProvider?.fetchRates(currencyCode: currencyCode, startDate: startDate, endDate: endDate, completion: { result in
            switch result {
            case .success(let currencyRates):
                self.currencyRates = currencyRates
                completion(.success(currencyRates))
                HUD.shared.hide()
            case .failure(let error):
                HUD.shared.hide()
                completion(.failure(error))
            }
        })
    }
}
// https://api.nbrb.by/bic - https://www.nbrb.by/apihelp/bic
