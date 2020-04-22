//
//  EmployeeListVCPresenter.swift
//  Atividade-Proposta
//
//  Created by Thiago Martins on 18/04/20.
//  Copyright © 2020 Thiago Anderson Martins. All rights reserved.
//

import Foundation
import Alamofire
import CoreData

// Delegate:
protocol EmployeeListVCDelegate : NSObjectProtocol {
    
    // Properties:
    var coordinator : MainCoordinator? { get }
    
    // Methods:
    func reloadTableViewData()
    func showActivityIndicator()
    func hideActivityIndicator()
    
}

// Presenter:
class EmployeeListVCPresenter {
    
    // Public Properties:
    // - Computed (Getters):
    public var employees : [Employee] { return _employeeManagedObjects.map({ $0.employee! }) }
    
    // Private Properties:
    // - Computed (Getters):
    private var managedContext : NSManagedObjectContext {
        (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    }
    private var employeeEntity : NSEntityDescription {
        return NSEntityDescription.entity(forEntityName: "EmployeeEntity", in: managedContext)!
    }
    // - Variables:
    private var editingEmployeeIndex : Int?
    // - with a public computed equivalent:
    private var _employeeManagedObjects : [EmployeeManagedObject] = []
    // - External References:
    private weak var delegate : EmployeeListVCDelegate!
    
    // Public Methods:
    public func initialize(delegate : EmployeeListVCDelegate) {
        self.delegate = delegate
        delegate.showActivityIndicator()
        initializeEmployees()
    }
    
    public func employeeTapped(_ employee : Employee, index : Int) {
        editingEmployeeIndex = index
        delegate.coordinator?.presentEditEmployeeVC(employee: employee, employeeListVCPresenter: self)
    }
    
    public func updateEditingEmployee(_ employee : Employee) {
        guard let index = editingEmployeeIndex else { return }
        _employeeManagedObjects[index].employee = employee
        delegate.reloadTableViewData()
    }
        
    // Private Methods:
    private func initializeEmployees() {
        if coreDataEmployeesIsEmpty() {
            // This runs the first time the app opens:
            fetchEmployeesFromWeb { (employees) in
                for employee in employees {
                    // Creates an EmployeeManagedObject from an Employee and NSMnagedObject:
                    let managedObject = NSManagedObject(entity: self.employeeEntity, insertInto: self.managedContext)
                    let employeeManagedObject = EmployeeManagedObject(managedObject: managedObject)
                    employeeManagedObject.employee = employee
                    // Populate _employeeManagedObjects:
                    self._employeeManagedObjects.append((employeeManagedObject))
                }
                self.finishEmployeeLoading()
            }
        } else { // Retries data from CoreData:
            fetchEmployeesFromCoreData { (managedObjects) in
                self._employeeManagedObjects = managedObjects.map({ EmployeeManagedObject(managedObject: $0) })
                self.finishEmployeeLoading()
            }
        }
    }
        
    private func finishEmployeeLoading() {
        self.delegate.hideActivityIndicator()
        self.delegate.reloadTableViewData()
    }
    
    // - Alamofire:
    private func fetchEmployeesFromWeb(completionHandler: @escaping ([Employee]) -> Void) {
        AF.request("https://dummy.restapiexample.com/api/v1/employees")
        .validate()
        .responseDecodable(of: Employees.self,  completionHandler: { (response) in
            if let employees = response.value {
                completionHandler(employees.all)
            } else {
                print(response.error?.errorDescription ?? "")
            }
        })
    }
                        
}

// Extensions:
// - CoreData:
extension EmployeeListVCPresenter {
            
    // Private Methods:
    private func coreDataEmployeesIsEmpty() -> Bool {
        do {
            let request = NSFetchRequest<NSManagedObject>(entityName: "EmployeeEntity")
            let count = try managedContext.count(for: request)
            return count == 0
        } catch {
            return true
        }
    }
    
    private func fetchEmployeesFromCoreData(completionHandler: @escaping ([NSManagedObject]) -> Void) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "EmployeeEntity")
        do {
            let managedObjects = try managedContext.fetch(fetchRequest)
            completionHandler(managedObjects)
        } catch let error as NSError {
            print("Could not fetch from CoreData: \(error), \(error.userInfo)")
        }
    }
                    
}
