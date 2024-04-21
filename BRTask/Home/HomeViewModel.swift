//
//  HomeViewModel.swift
//  BRTask
//
//  Created by Ilahe Samedova on 19.04.24.
//

import Foundation

class HomeViewModel {
    
    private let coreData = CoreData()
    var cards: [Cards] = []
    
    func fetchCardData(completion: @escaping () -> Void) {
        coreData.fetchCardDatas { [weak self] cards in
            self?.cards = cards
            completion()
        }
    }
    func deleteCard(card: Cards) {
        coreData.deleteCardDatas(card: card)
    }
}
