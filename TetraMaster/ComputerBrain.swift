//
//  ComputerBrain.swift
//  TetraMaster
//
//  Created by Tim Musil on 19.12.20.
//

import Foundation


func makeChoice (hand: [Card], placedCards: [[Card?]]) -> (UUID, [Int]) {
    
    // the computer tries all combinations of empty fields and available cards in hand (once) and takes the card with the highest possibilty of a high number of changed cards (needs to be checked for color/faction)
    // if no good solution is found a random card is added to a random field
    var changedCardsCount = 0
    var decision: (UUID, [Int])?
    
    for var card in hand {
        if !card.isPlaced {
            
            for i in 0...placedCards.count - 1 {
                for (j, field) in placedCards[i].enumerated() {
                    
                    if field == nil {
                        card.currentLocation = [i,j]
                        let possibleChangedCards = cardBattle(newCard: card, placedCards: placedCards)
                        
                        if possibleChangedCards.count > changedCardsCount && possibleChangedCards[0].faction == .red {
                            
                            changedCardsCount = possibleChangedCards.count
                            
                            decision = (card.id, [i,j])
                        }
                    }
                    
                }
            }
        }
    }
    
    if let choice = decision {
        return choice
    } else {
        
        // random placement
        var path: [Int] = []
        
        while path.count == 0 {
            let i =  Int.random(in: 0...3)
            let j =  Int.random(in: 0...3)
            
            if placedCards[i][j] == nil {
                path.insert(i, at: 0)
                path.insert(j, at: 1)
            }
        }
        
        // random card
        var cardID: UUID?
        
        while cardID == nil {
            if let randomCard = hand.randomElement() {
                if !randomCard.isPlaced {
                    cardID = randomCard.id
                }
            }
        }
        
        let choice: (UUID, [Int]) = (cardID!, path)
        
        return choice
        
    }
}
