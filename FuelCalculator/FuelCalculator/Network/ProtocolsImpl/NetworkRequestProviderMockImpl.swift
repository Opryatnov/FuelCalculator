//
//  NetworkRequestProviderMockImpl.swift
//  CurrencyConverter
//
//  Created by Opryatnov on 29.04.24.
//

import Alamofire
import UIKit

final class NetworkRequestProviderMockImpl: NetworkRequestProvider {
    func fetchRates(currencyCode: Int, startDate: String, endDate: String, completion: @escaping (Result<[DynamicCources]?, any Error>) -> ()) {
        
    }
    
    func fetchAllCurrencies(completion: @escaping (Result<[CurrencyData]?, Error>) -> ()) {
        if let path = Bundle.main.path(forResource: "currencies", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .alwaysMapped)
                let jsonDecoder = JSONDecoder()
                guard let currencies: [CurrencyData] = try? jsonDecoder.decode([CurrencyData].self, from: data) else {
                    completion(.failure(NetworkingError.invalidData))
                    return
                }
                DispatchQueue.main.async {
                    completion(.success(currencies))
                }
                
            } catch let error {
                completion(.failure(NetworkingError.invalidData))
            }
        }
    }
}
