//
//  CurrencyListViewModel.swift
//  IbanValidatorTool
//
//  Created by Sagar Moradia on 12/06/24.
//

import Foundation

final class CurrencyListViewModel: ObservableObject {
    
    //MARK: - Dependency Injection
    private let validateIbanService: IbanValidateServiceDelegate
    private let currencyRatesService: CurrencyRatesServiceDelegate
    
    init(validateIbanService: IbanValidateServiceDelegate = IbanValidateService(),
         currencyRatesService: CurrencyRatesServiceDelegate = CurrencyRatesService()) {
        self.validateIbanService = validateIbanService
        self.currencyRatesService = currencyRatesService
    }
    
    //MARK: - Wrapped Properties
    @Published var iban: String = ""
    @Published var ibanErrorMessage: String = ""
    
    @Published var ibanValidationResult: IbanValidationResponse?
    @Published var isLoading = false
    @Published var showList: Bool = false
    @Published var error: Error? = nil
    
    @Published var rates: [Rates] = []
    
    private let fetchRatesApiUrl = "https://api.apilayer.com/fixer/latest"
    
    //MARK: - Methods
    func isValidIBAN() -> Bool {
        ibanErrorMessage = iban.isEmpty ? Constant.emptyIban : ""
        return ibanErrorMessage == "" ? true : false
    }
    
    // Validate IBAN (USING Closure)
    func validateIban() {
        setDefaultValues()
                
        validateIbanService.validateIban(iban: iban) { result in
            DispatchQueue.main.async {
                self.isLoading = false
                switch result {
                case .success(let data):
                    self.ibanValidationResult = data
                    Task {
                        await self.fetchRates()
                        self.showList = true
                    }
                case .failure(let error):
                    print(error)
                    self.error = error
                }
            }
        }
    }
    
    // Fetch Currency Rates (USING Async/Await)
//    @MainActor
    func fetchRates() async {
        guard !iban.isEmpty, isValidIBAN() else { //Also need to validate iban if not validated
            error = NSError(domain: "CurrencyRateError", code: 0, userInfo: ["message": Constant.validateIban])
            return
        }
        
        guard let url = URL(string: fetchRatesApiUrl + "?base=KWD&apikey=" + Constant.apiKey) else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        do {
            let dataResponse: CurrencyRateResponse = try await APIManager.shared.request(urlRequest: request)
            self.rates = dataResponse.rates
        } catch {
            print(error)
        }
    }
    
    private func setDefaultValues() {
        isLoading = true
        ibanValidationResult = nil
        error = nil
    }
}
