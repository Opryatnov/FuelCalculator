//
//  HTMLParser.swift
//  HtmlParser
//
//  Created by Opryatnov on 26.06.24.
//

import Foundation
import SwiftSoup

final class HTMLParser {
    var fuel: [Fuel]?
    func parse(html: String, completion: @escaping ([Fuel]?) -> Void, errorCompletion: (Error?) -> Void) {
        do {
            fuel = []
            let document: Document = try SwiftSoup.parse(html)
            guard let body = document.body() else { return }
            let th: Elements? = try body.select("div")
            let td: Elements? = try body.select("div")
            let span: Elements? = try body.select("span")
            th?.enumerated().forEach { index, value in
                let fuelName = try? value.text()
                if fuelName?.contains("Газ") == true {
                    if let valueAmount = try? td?[index + 1].text().replacingOccurrences(of: ",", with: "."),
                       Double(valueAmount) != nil {
                        let tempFuel = Fuel(name: "Газ: пропан - бутан", amount: valueAmount, fuelCode: "Gas", fuelName_ENG: "Gas: propane-butane", fuelName_BEL: "Газ: прапан-бутан")
                        fuel?.append(tempFuel)
                    }
                } else if fuelName == "ДТ Евро" {
                    let valueAmount = try? td?[index + 1].text().replacingOccurrences(of: ",", with: ".")
                    let tempFuel = Fuel(name: fuelName, amount: valueAmount, fuelCode: "DT", fuelName_ENG: "Diesel fuel", fuelName_BEL: "Дызельнае паліва")
                    fuel?.append(tempFuel)
                } else if fuelName == "AdBlue" {
                    let valueAmount = try? td?[index + 1].text().replacingOccurrences(of: ",", with: ".")
                    let tempFuel = Fuel(name: fuelName, amount: valueAmount, fuelCode: "DT-ECO", fuelName_ENG: "Diesel fuel (ECO)", fuelName_BEL: "Дызельнае паліва (ECO)")
                    fuel?.append(tempFuel)
                } else if fuelName == "ДТЗ -32°" {
                    let valueAmount = try? td?[index + 1].text().replacingOccurrences(of: ",", with: ".")
                    let tempFuel = Fuel(name: fuelName, amount: valueAmount, fuelCode: "DT-Winter", fuelName_ENG: "Diesel fuel, winter (-32)", fuelName_BEL: "Дызельнае паліва, зімовае (-32)")
                    fuel?.append(tempFuel)
                } else if fuelName == "АИ-92" {
                    let valueAmount = try? td?[index + 1].text().replacingOccurrences(of: ",", with: ".")
                    let tempFuel = Fuel(name: fuelName, amount: valueAmount, fuelCode: "AI-92", fuelName_ENG: "Gasoline AI - 92", fuelName_BEL: "Бензін АІ - 92")
                    fuel?.append(tempFuel)
                } else if fuelName == "АИ-95" {
                    let valueAmount = try? td?[index + 1].text().replacingOccurrences(of: ",", with: ".")
                    let tempFuel = Fuel(name: fuelName, amount: valueAmount, fuelCode: "AI-95", fuelName_ENG: "Gasoline AI - 95", fuelName_BEL: "Бензін АІ - 95")
                    fuel?.append(tempFuel)
                } else if fuelName == "АИ-98" {
                    let valueAmount = try? td?[index + 1].text().replacingOccurrences(of: ",", with: ".")
                    let tempFuel = Fuel(name: fuelName, amount: valueAmount, fuelCode: "AI-98", fuelName_ENG: "Gasoline AI - 98", fuelName_BEL: "Бензін АІ - 98")
                    fuel?.append(tempFuel)
                }
            }
            completion(fuel)
        } catch {
            errorCompletion(error)
        }
    }
}
