//
//  CurrencyListView.swift
//  IbanValidatorTool
//
//  Created by Sagar Moradia on 12/06/24.
//

import SwiftUI

struct CurrencyListView: View {
    
    @StateObject var listVM = CurrencyListViewModel()
    
    var body: some View {
        VStack(spacing: Constant.contentSpacing) {
            HStack(spacing: Constant.contentSpacing) {
                
                VStack (alignment: .leading, spacing: 0) {
                    IbanInput()
                    if !listVM.ibanErrorMessage.isEmpty {
                        ErrorMessageView(message: listVM.ibanErrorMessage)
                    }
                }
                ValidateButton()
            }
            
            if listVM.isLoading {
                ProgressView()
            } else {
                ValidationResults()
            }
            
            Spacer()
            
            if listVM.showList {
                CurrencyListView()
            }
            
        }.padding()
    }
    
    fileprivate func IbanInput() -> some View {
        TextField("Enter Valid IBAN", text: $listVM.iban)
            .keyboardType(.emailAddress)
            .disableAutocorrection(true)
            .autocapitalization(.none)
            .textFieldStyle(.roundedBorder)
    }
    
    fileprivate func ValidateButton() -> some View {
        Button(action: {
            if listVM.isValidIBAN() {
                listVM.validateIban()
            }
        }) {
            Text("Validate")
                .fontWeight(.semibold)
                .frame(width: 100, height: 40)
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(8)
        }.disabled(listVM.iban.isEmpty)
    }
    
    fileprivate func ValidationResults() -> some View {
        Group {
            if let validationResult = listVM.ibanValidationResult {
                Text("Validation Result:")
                    .font(.headline)
                VStack(alignment: .leading) {
                    Text("Status: \(validationResult.status)")
                    Text("Country: \(validationResult.country)")
                    if let bank = validationResult.bank {
                        Text("Bank: \(bank)")
                    }
                    if let bankCode = validationResult.bankCode {
                        Text("Bank Code: \(bankCode)")
                    }
                    if let owner = validationResult.owner {
                        Text("Account Holder: \(owner)")
                    }
                }
            } else if let error = listVM.error {
                Text("Error: \(error.localizedDescription)")
                    .foregroundColor(.red)
            }
        }
    }
    
    fileprivate func CurrencyList() -> some View {
        VStack {
            if listVM.isLoading {
                ProgressView {
                    Text("Loading List...")
                }
            } else if let error = listVM.error {
                Text("Error: \(error.localizedDescription)")
                    .foregroundColor(.red)
            } else if !listVM.rates.isEmpty {
                List {
                    ForEach(listVM.rates) { rate in
                        Text("\(rate.currency): \(rate.value, specifier: "%.4f")")
                    }
                }
            } else {
                Text("No rates available")
            }
        }
    }
    
    fileprivate func ErrorMessageView(message: String) -> some View {
        Text(message)
            .foregroundColor(.red)
            .font(.caption)
            .padding([.leading, .top], 8)
    }
}

#Preview {
    CurrencyListView()
}
