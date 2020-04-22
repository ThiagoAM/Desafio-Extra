//
//  InputValidator.swift
//  Atividade-Proposta
//
//  Created by Thiago Martins on 19/04/20.
//  Copyright © 2020 Thiago Anderson Martins. All rights reserved.
//

import Foundation

class InputValidator {
    
    // Public Properties:
    public let invalidNameMessage = "Nome inválido"
    public let invalidSalaryMessage = "Salário inválido"
    
    // Public Methods:
    public func nameIsValid(_ name : String?) -> Bool {
        if let treatedName = name?.lowercased().trimmingCharacters(in: .whitespaces) {
            let allowedCharacterSet = CharacterSet(charactersIn: " abcdefghijklmnopqrstuvwxyzçâãáàéèêíîìóòôõúùû")
            return !treatedName.isEmpty && allowedCharacterSet.isSuperset(of: CharacterSet(charactersIn: treatedName))
        }
        return false
    }
    
    public func salaryIsValid(_ stringSalary : String?) -> Bool {
        if let stringSalary = stringSalary {
            let allowedCharacterSet = CharacterSet(charactersIn: "0123456789.,")
            return !stringSalary.isEmpty && allowedCharacterSet.isSuperset(of: CharacterSet(charactersIn: stringSalary))
        }
        return false
    }
    
    public func salaryIsValid(_ salary : Float?) -> Bool {        
        if let salary = salary { return salaryIsValid("\(salary)") }
        return false
    }
            
}
