//
//  DynamicCources.swift
//  CurrencyConverter
//
//  Created by Opryatnov on 26.07.24.
//

import Foundation

struct DynamicCources: Decodable {
    let curID: Int?
    let date: String?
    let curOfficialRate: Double?
    
    var formattedDate: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        guard let date = date else {
            return ""
        }
        
        let convertedDate = dateFormatter.date(from: date) ?? Date()
        dateFormatter.dateFormat = "dd MMMM yyyy"
        
        if dateFormatter.string(from: convertedDate) == dateFormatter.string(from: Date()) {
            return LS("TODAY.TITLE")
        } else if dateFormatter.string(from: convertedDate) == dateFormatter.string(from: Calendar.current.date(byAdding: .day, value: -1, to: Date()) ?? Date()) {
            return LS("YESTERDAY.TITLE")
        } else {
            return dateFormatter.string(from: convertedDate)
        }
    }
    
    var formattedAmount: String {
        curOfficialRate?.description.toAmountFormat() ?? "0.0"
    }
    
    enum CodingKeys: String, CodingKey {
        case curID = "Cur_ID"
        case date = "Date"
        case curOfficialRate = "Cur_OfficialRate"
    }
}
