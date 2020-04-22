//
//  AlertHelper.swift
//  Atividade-Proposta
//
//  Created by Thiago Martins on 20/04/20.
//  Copyright © 2020 Thiago Anderson Martins. All rights reserved.
//

import UIKit

extension UIViewController {
    
    // Public Methods:
    public func presentOkAlert(title : String?, message : String?, completion : (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: completion)
    }
    
}
