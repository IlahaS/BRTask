//
//  KeyChain.swift
//  BRTask
//
//  Created by Ilahe Samedova on 19.04.24.
//

import Foundation
import Security

class KeychainService {
    static let service = "com.example.app"
    
    static func saveSensitiveData(name: String, phoneNumber: String, dob: Date) -> Bool {
        let user = User(name: name, phoneNumber: phoneNumber, dateOfBirth: dob)
        guard let data = try? JSONEncoder().encode(user) else {
            return false
        }
        
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecValueData as String: data
        ]
        
        SecItemDelete(query as CFDictionary)
        let status = SecItemAdd(query as CFDictionary, nil)
        return status == errSecSuccess
    }
    
    static func loadSensitiveData() -> User? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecMatchLimit as String: kSecMatchLimitOne,
            kSecReturnData as String: kCFBooleanTrue as Any
        ]
        
        var dataTypeRef: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)
        
        if status == errSecSuccess {
            if let data = dataTypeRef as? Data,
               let user = try? JSONDecoder().decode(User.self, from: data) {
                return user
            }
        }
        return nil
    }
    
    static func clearSensitiveData() {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service
        ]
        SecItemDelete(query as CFDictionary)
    }
}

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
