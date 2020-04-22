//
//  FormattingHelper.swift
//  Atividade-Proposta
//
//  Created by Thiago Martins on 20/04/20.
//  Copyright © 2020 Thiago Anderson Martins. All rights reserved.
//

import Foundation

class FormattingHelper {
    
    // Public Mehtods:
    public func formatToBRL(value : Float, hasPrefix : Bool = false) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.groupingSeparator = "."
        numberFormatter.groupingSize = 3
        numberFormatter.usesGroupingSeparator = true
        numberFormatter.decimalSeparator = ","
        numberFormatter.numberStyle = .decimal
        numberFormatter.maximumFractionDigits = 2
        let prefix = hasPrefix ? "R$ " : ""
        return prefix + numberFormatter.string(from: value as NSNumber)!
    }
    
    public func numberFromFormattedBRLValue(formattedValue : String) -> Float? {
        var treatedString = formattedValue
        // Removes the 'R$' prefix:
        treatedString = treatedString.replacingOccurrences(of: "R$", with: "")
        // Removes all blank spaces:
        treatedString = treatedString.replacingOccurrences(of: " ", with: "")
        // Removes the grouping separators:
        treatedString = treatedString.replacingOccurrences(of: ".", with: "")
        // Replaces the ',' decimal separators with ".":
        treatedString = treatedString.replacingOccurrences(of: ",", with: ".")
        // Converts to Float and returns:
        return Float(treatedString)
    }
    
}
