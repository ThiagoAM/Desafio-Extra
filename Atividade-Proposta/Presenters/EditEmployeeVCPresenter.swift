//
//  EditEmployeeVCPresenter.swift
//  Atividade-Proposta
//
//  Created by Thiago Martins on 19/04/20.
//  Copyright © 2020 Thiago Anderson Martins. All rights reserved.
//

import Foundation

protocol EditEmployeeVCDelegate : NSObjectProtocol {
    
    // Properties:
    var employeeListVCPresenter : EmployeeListVCPresenter? { get }
    var nameTextFieldText : String? { get set }
    var salaryTextFieldText : String? { get set }
    
    // Methods:
    func updateNavigationBarTitle(_ title : String)
    func showOkAlert(title : String?, message : String?, completion : (() -> Void)?)    
    
}

class EditEmployeeVCPresenter {
    
    // Public Properties:
    public let inputValidator = InputValidator()
    // - Computed (Getters):
    public var employee : Employee { return _employee }
    
    // Private Properties:
    // - with computed equivalent:
    private var _employee : Employee!
    // - External References:
    private weak var delegate : EditEmployeeVCDelegate!
                
    // Public Methods:
    public func initialize(delegate : EditEmployeeVCDelegate, employee : Employee) {
        self._employee = employee
        self.delegate = delegate
    }
    
    public func setEmployee(_ employee : Employee) {
        self._employee = employee
    }
            
    public func validateAndSetName(_ newName : String?) {
        guard let newName = newName else { return }
        if inputValidator.nameIsValid(newName) {
            self._employee.name = newName
            delegate.updateNavigationBarTitle(newName)
            delegate.employeeListVCPresenter!.updateEditingEmployee(_employee)
        } else {            
            delegate.nameTextFieldText = _employee.name
            delegate.showOkAlert(title: "Ops!", message: "Não foi possível alterar o nome, pois o mesmo era inválido.", completion: nil)
        }
    }
    
    public func validateAndSetSalary(_ newSalary : String?) {
        guard let newSalary = newSalary else { return }
        let newFloatSalary = FormattingHelper().numberFromFormattedBRLValue(formattedValue: newSalary)
        if newFloatSalary != nil && inputValidator.salaryIsValid(newFloatSalary) {
            delegate.salaryTextFieldText = FormattingHelper().formatToBRL(value: newFloatSalary!)
            self._employee.salary = newFloatSalary!
            delegate.employeeListVCPresenter!.updateEditingEmployee(_employee)
        } else {
            delegate.salaryTextFieldText = "\(_employee.salary)"
            delegate.showOkAlert(title: "Ops!", message: "Não foi possível alterar o salário, pois o mesmo era inválido.", completion: nil)            
        }
    }
                
}
