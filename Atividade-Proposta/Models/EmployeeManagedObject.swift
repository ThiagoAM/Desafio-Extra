//
//  EmployeeManagedObject.swift
//  Atividade-Proposta
//
//  Created by Thiago Martins on 20/04/20.
//  Copyright © 2020 Thiago Anderson Martins. All rights reserved.
//

import UIKit
import CoreData

class EmployeeManagedObject {
    
    // Public Properties:
    // - Computed (Getters & Setters):
    public var employee : Employee? {
        get {
            do {
                return try Employee(managedObject: managedObject)
            } catch let error as NSError {
                print(error.localizedDescription)
                return nil
            }
        }
        set {
            if let employee = newValue {
                managedObject.setValue(employee.id, forKey: "id")
                managedObject.setValue(employee.name, forKey: "name")
                managedObject.setValue(employee.salary, forKey: "salary")
                managedObject.setValue(employee.age, forKey: "age")
                managedObject.setValue(employee.profileImageUrl, forKey: "profileImageUrl")
                save()
            }
        }
    }
    
    // Private Properties:
    private var managedObject : NSManagedObject
    // - Computed:
    private var managedContext : NSManagedObjectContext {
        (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    }
            
    // Initialization:
    init(managedObject : NSManagedObject) {
        self.managedObject = managedObject
    }
                
    // Private Methods:
    public func save() {
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
}
