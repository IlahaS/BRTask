//
//  CardCreateViewModel.swift
//  BRTask
//
//  Created by Ilahe Samedova on 19.04.24.
//

import Foundation

class CardCreateViewModel {
    
    private let coreData = CoreData()
    
    func saveCard(card: CardModel, completion: @escaping () -> Void) {
        coreData.saveCardDatas(cardModel: card)
        completion()
    }
}
