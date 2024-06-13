//
//  CurrencyRatesService.swift
//  IbanValidatorTool
//
//  Created by Sagar Moradia on 12/06/24.
//

import Foundation

typealias CurrencyRatesHandler = (Result<CurrencyRateResponse, CustomError>) -> Void

protocol CurrencyRatesServiceDelegate {
    func fetchRates(completion: @escaping CurrencyRatesHandler)
}

class CurrencyRatesService: CurrencyRatesServiceDelegate  {
    
    private let fetchRatesApiUrl = "https://api.apilayer.com/fixer/latest"
    
    func fetchRates(completion: @escaping CurrencyRatesHandler) {
        //Call Rates API
        //APIManager.shared.
    }
}
