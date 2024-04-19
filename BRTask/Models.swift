//
//  Models.swift
//  BRTask
//
//  Created by Ilahe Samedova on 19.04.24.
//

import Foundation

struct User: Codable {
    var name: String
    var phoneNumber: String
    var dateOfBirth: Date
}

struct CardModel {
    let cardNumber: String
    var balance: Double
    let expDate: String
    let cvv: Int
}
