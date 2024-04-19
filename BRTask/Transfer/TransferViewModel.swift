//
//  TransferViewModel.swift
//  BRTask
//
//  Created by Ilahe Samedova on 19.04.24.
//

import Foundation

class TransferViewModel {
    
    private let coreData = CoreData()
    var cards: [Cards] = []
    
    func fetchCardData(completion: @escaping () -> Void) {
        coreData.fetchCardDatas { [weak self] cards in
            self?.cards = cards
            completion()
        }
    }
    
    func transferAmount(fromIndex: Int, toIndex: Int, amount: Double, completion: @escaping (Bool) -> Void) {
        guard fromIndex != toIndex,
              fromIndex >= 0, fromIndex < cards.count,
              toIndex >= 0, toIndex < cards.count else {
            completion(false)
            return
        }
        
        let fromCard = cards[fromIndex]
        let toCard = cards[toIndex]
        
        guard fromCard.balance >= amount else {
            completion(false)
            return
        }
        
        fromCard.balance -= amount
        toCard.balance += amount
        
        coreData.updateCardDatas(card: fromCard)
        coreData.updateCardDatas(card: toCard)
        
        completion(true)
    }
}
