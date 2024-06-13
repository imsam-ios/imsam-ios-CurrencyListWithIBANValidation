//
//  IbanValidateService.swift
//  IbanValidatorTool
//
//  Created by Sagar Moradia on 12/06/24.
//

import Foundation

typealias IbanValidateResultHandler = (Result<IbanValidationResponse, CustomError>) -> Void

protocol IbanValidateServiceDelegate {
    func validateIban(iban: String, completion: @escaping IbanValidateResultHandler)
}

class IbanValidateService: IbanValidateServiceDelegate  {
    
    private let validateIbanApiUrl = "https://api.apilayer.com/bank_data/validate?iban="
    
    func validateIban(iban: String, completion: @escaping IbanValidateResultHandler) {
        let urlString = validateIbanApiUrl + iban + "&apikey=" + Constant.apiKey
        APIManager.shared.validateIban(urlString: urlString, completion: completion)
    }
}
