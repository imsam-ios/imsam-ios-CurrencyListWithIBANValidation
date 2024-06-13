//
//  String + Extension.swift
//  IbanValidatorTool
//
//  Created by Sagar Moradia on 12/06/24.
//

import Foundation

extension String {
    func isValidateIBAN(regex: String) -> Bool {
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        if predicate.evaluate(with: self) {
            return true
        }
        return false
    }
}
