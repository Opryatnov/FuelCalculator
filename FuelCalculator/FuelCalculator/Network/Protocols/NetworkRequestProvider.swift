//
//  NetworkRequestProvider.swift
//  CurrencyConverter
//
//  Created by Opryatnov on 29.04.24.
//

import Foundation

protocol NetworkRequestProvider {
    func fetchAllCurrencies(completion: @escaping (Result<[CurrencyData]?, Error>) -> ())
    func fetchRates(
        currencyCode: Int,
        startDate: String,
        endDate: String,
        completion: @escaping (Result<[DynamicCources]?, Error>) -> ()
    )
}
