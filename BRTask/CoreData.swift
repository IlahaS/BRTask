//
//  CoreData.swift
//  BRTask
//
//  Created by Ilahe Samedova on 19.04.24.
//

import Foundation
import CoreData

class CoreData {
    let contex = AppDelegate.shared.persistentContainer.viewContext
    var cards = [Cards]()
    var callBackForCards: (() -> Void)?
    
    
    func saveCardDatas (cardModel: CardModel) {
        let model = Cards(context: contex)
        model.cardNumber = cardModel.cardNumber
        model.expDate = cardModel.expDate
        model.balance = cardModel.balance
        model.cvv = Int16(cardModel.cvv)
        
        do{
            try contex.save()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func fetchCardDatas(completion: @escaping ([Cards]) -> Void) {
        do {
            let cards = try contex.fetch(Cards.fetchRequest())
            self.cards = cards
            completion(cards)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func updateCardDatas(card: Cards) {
        do {
            try contex.save()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func deleteCardDatas(card: Cards) {
        do {
            contex.delete(card)
            try contex.save()
        }catch {
            print(error.localizedDescription)
        }
    }
}
