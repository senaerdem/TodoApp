//
//  LoginViewModel.swift
//  TodoApp
//
//  Created by Sena Nur Erdem on 28.06.2023.
//

import UIKit
struct LoginViewModel {
    var emailText: String?
    var passwordText: String?
    
    var status: Bool {
        return emailText?.isEmpty == false && passwordText?.isEmpty == false
    }
}
