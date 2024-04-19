//
//  ProfileViewModel.swift
//  BRTask
//
//  Created by Ilahe Samedova on 19.04.24.
//

import Foundation

class ProfileViewModel {
    
    private var user: User?
    
    func fetchUserDetails(completion: @escaping (User?) -> Void) {
        let userDetails = KeychainService.loadSensitiveData()
        completion(userDetails)
    }
    
    func logout() {
        KeychainService.clearSensitiveData()
        UserDefaultsService.clearUserData()
    }
}

