//
//  Cards+CoreDataProperties.swift
//  BRTask
//
//  Created by Ilahe Samedova on 19.04.24.
//
//

import Foundation
import CoreData


extension Cards {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Cards> {
        return NSFetchRequest<Cards>(entityName: "Cards")
    }

    @NSManaged public var balance: Double
    @NSManaged public var cardNumber: String?
    @NSManaged public var cvv: Int16
    @NSManaged public var expDate: String?

}

extension Cards : Identifiable {

}
