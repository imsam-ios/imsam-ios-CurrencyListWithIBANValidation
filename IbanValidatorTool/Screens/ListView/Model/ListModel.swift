//
//  ListModel.swift
//  IbanValidatorTool
//
//  Created by Sagar Moradia on 12/06/24.
//

import Foundation


struct IbanValidationResponse: Decodable {
    let status: Int
    let country: String
    let bank: String?
    let bankCode: String?
    let owner: String?

    enum CodingKeys: String, CodingKey {
        case status
        case country = "country_code"
        case bank = "bank_name"
        case bankCode = "bank_code"
        case owner = "account_holder_name"
    }
}

struct CurrencyRateResponse: Decodable, Identifiable {
    var id = UUID().uuidString
    let success: Bool
    let base: String
    let rates: [Rates]
}

struct Rates: Decodable, Identifiable {
    var id: String {currency}
    var currency: String
    var value: Double
}
