//
//  Storyboarded.swift
//  Atividade-Proposta
//
//  Created by Thiago Martins on 18/04/20.
//  Copyright © 2020 Thiago Anderson Martins. All rights reserved.
//

import UIKit

protocol Storyboarded {
    static func instantiate() -> Self
}

extension Storyboarded where Self : UIViewController {
    
    static func instantiate() -> Self {
        // This pulls out "MyApp.ViewControllerName":
        let fullName = NSStringFromClass(self)
        // This splits by the dot and uses everything after, giving "ViewControllerName":
        let className = fullName.components(separatedBy: ".")[1]
        // Load the Storyboard:
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        // Instantiate a ViewController with that identifier, and force cast as the type that was requested:
        return storyboard.instantiateViewController(identifier: className) as! Self
    }
    
}
