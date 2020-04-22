//
//  Coordinator.swift
//  Atividade-Proposta
//
//  Created by Thiago Martins on 18/04/20.
//  Copyright © 2020 Thiago Anderson Martins. All rights reserved.
//

import UIKit

protocol Coordinator {
    
    // Properties:
    var navigationController : UINavigationController { get set }
    
    // Methods:
    func start()
    
}
