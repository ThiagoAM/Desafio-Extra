//
//  Employee.swift
//  Atividade-Proposta
//
//  Created by Thiago Martins on 18/04/20.
//  Copyright © 2020 Thiago Anderson Martins. All rights reserved.
//

import UIKit
import CoreData

struct Employee : Decodable {
    
    // Properties:
    let id : Int
    var name : String
    var salary : Float
    let age : Int
    var profileImageUrl : String
            
    // Enumerations:
    enum CodingKeys : String, CodingKey {
        case id
        case name = "employee_name"
        case salary = "employee_salary"
        case age = "employee_age"
        case profileImageUrl = "profile_image"
    }
    
    // Initialization:
    init(from decoder : Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        // Manually decodes the id from String to Int:
        guard let id = try Int(container.decode(String.self, forKey: CodingKeys.id)) else {
            throw DecodingError.dataCorrupted(.init(codingPath: [CodingKeys.id], debugDescription: "Expecting String representation of Int"))
        }
        self.id = id
        name = try container.decode(String.self, forKey: CodingKeys.name)
        // Manually decodes the salary from String to Float:
        guard let salary = try Float(container.decode(String.self, forKey: CodingKeys.salary)) else {
            throw DecodingError.dataCorrupted(.init(codingPath: [CodingKeys.salary], debugDescription: "Expecting String representation of Float"))
        }
        self.salary = salary
        // Manually decodes the age from String to Int:
        guard let age = try Int(container.decode(String.self, forKey: CodingKeys.age)) else {
            throw DecodingError.dataCorrupted(.init(codingPath: [CodingKeys.id], debugDescription: "Expecting String representation of Int"))
        }
        self.age = age
        profileImageUrl = try container.decode(String.self, forKey: CodingKeys.profileImageUrl)
    }
    
}

struct Employees : Decodable {
    
    // Properties:
    var all : [Employee]
    
    // Enumerations:
    enum CodingKeys : String, CodingKey {
        case all = "data"
    }
    
}

// Extensions:
// - CoreData:
extension Employee {
                
    // Initialization:
    init(managedObject : NSManagedObject) throws {
        // id:
        guard let id = managedObject.value(forKeyPath: "id") as? Int else {
            throw NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey : "Could not convert the managedObject's value 'id' to Int"])
        }
        self.id = id
        // name:
        guard let name = managedObject.value(forKeyPath: "name") as? String else {
            throw NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey : "Could not convert the managedObject's value 'name' to String"])
        }
        self.name = name
        // salary:
        guard let salary = managedObject.value(forKeyPath: "salary") as? Float else {
            throw NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey : "Could not convert the managedObject's value 'salary' to Float"])
        }
        self.salary = salary
        // age:
        guard let age = managedObject.value(forKeyPath: "age") as? Int else {
            throw NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey : "Could not convert the managedObject's value 'age' to Int"])
        }
        self.age = age
        // profileImageUrl:
        guard let profileImageUrl = managedObject.value(forKeyPath: "profileImageUrl") as? String else {
            throw NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey : "Could not convert the managedObject's value 'profileImageUrl' to String"])
        }
        self.profileImageUrl = profileImageUrl
    }
    
}

extension Employees {
    
    // Public Methods:
    static public func allFromManagedObjects(_ managedObjects : [NSManagedObject]) -> [Employee] {
        var all : [Employee] = []
        for managedObject in managedObjects {
            do {
                let employee = try Employee(managedObject: managedObject)
                all.append(employee)
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        }
        return all
    }
    
}
