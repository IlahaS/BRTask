//
//  UserDefaultsAdapter.swift
//  BRTask
//
//  Created by Ilahe Samedova on 21.04.24.
//

import Foundation

class UserDefaultsService {
    static let isLoggedInKey = "isLoggedIn"
    
    static func setIsLoggedIn(_ value: Bool) {
        UserDefaults.standard.set(value, forKey: isLoggedInKey)
    }
    
    static func clearUserData() {
        UserDefaults.standard.removeObject(forKey: isLoggedInKey)
    }
    
    static func isLoggedIn() -> Bool {
        return UserDefaults.standard.bool(forKey: isLoggedInKey)
    }
}
