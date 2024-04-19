//
//  RegisterViewModel.swift
//  BRTask
//
//  Created by Ilahe Samedova on 19.04.24.
//

import UIKit

import Foundation

class RegisterViewModel {
    func registerUser(name: String, phoneNumber: String, dob: Date, onSuccess: @escaping () -> Void, onFailure: @escaping () -> Void) {
        guard KeychainService.saveSensitiveData(name: name, phoneNumber: phoneNumber, dob: dob) else {
            onFailure()
            return
        }
        
        UserDefaultsService.setIsLoggedIn(true)
        onSuccess()
    }
}

