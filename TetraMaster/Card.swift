//
//  Card.swift
//  TetraMaster
//
//  Created by Tim Musil on 28.11.20.
//
import SwiftUI
import Foundation

//Player = blue, Compputer = red
enum Faction {
    case red
    case blue
}

// Physical = P, Magic = M
enum CardType {
    case P
    case M
}

struct Card: Identifiable {
    
    let id = UUID()
    let image: String
    let name: String
    var faction: Faction
    
    let strength: Int
    let cardType: CardType
    let physicalDefense: Int
    let magicDefense: Int
    
    //N, NE, E ,SE, S, SW, W, NW
    let arrows: [Bool]
    
    var isPlaced: Bool
    
    // Card can only be placed on gameboard if it is the currently selected card in the stack
    //needed for referencing the cards position in a battle
    var currentLocation: [Int]?
    
    
}

func createRandomCards(for faction: Faction, amount: Int) -> [Card] {
    var cards: [Card] = []
    
    for _ in 0...amount-1 {
        
        let cardCharacter = cardData.randomElement()
        
        cards.append(Card( image: cardCharacter!.key, name: cardCharacter!.value, faction: faction , strength: Int.random(in: 0...9), cardType: randomType(), physicalDefense: Int.random(in: 0...9), magicDefense: Int.random(in: 0...9), arrows: [Bool.random(), Bool.random(), Bool.random(), Bool.random(), Bool.random(), Bool.random(), Bool.random(), Bool.random()], isPlaced: false))
        
    }
    
    return cards
}

//returns a random CardType of either Magic or Physical
func randomType() -> CardType {
    let randomInt = Int.random(in: 0...1)
    if randomInt == 0 {return .M}
    else {return .P}
}

func decideMatch(attacker: Card,from arrow: Int, defender: Card) -> Bool? {
    if attacker.faction != defender.faction {
        if defender.arrows[(arrow + 4) % 8] {
            let diceValue = Int.random(in: 1...100)
            let tableValue = matchTable[attacker.strength][attacker.cardType == .P ? defender.physicalDefense : defender.magicDefense]
            if diceValue >= tableValue {
                
                print("\(defender.name): The dices number \(diceValue) is bigger than \(tableValue) -> Win")
                return true
            } else {
                print("\(defender.name): The dices number \(diceValue) is lower than \(tableValue) -> Lose")
                return false
            }
        } else {
            print("\(defender.name): Easy Take")
            return true
        }
        
    } else {
        print("\(defender.name): We are friends!")
        return nil
    }
}

extension Array {
    subscript (safe index: Index) -> Element? {
        return 0 <= index && index < count ? self[index] : nil
    }
}


/* Evaluates the surroundings of a newCard and executes battles where appropriate. */
func cardBattle(newCard: Card, placedCards: [[Card?]]) -> [Card] {
    var newCard = newCard
    var changedCards: [Card] = []
    
    let i = newCard.currentLocation![0]
    let j = newCard.currentLocation![1]
    var wins = 0.0
    var matches = 0.0
    
    //can be refactored into decideMatch
    func makeMatch(i: Int, j: Int, from: Int) {
        if var defender = placedCards[i][j] {
            if let matchWon = decideMatch(attacker: newCard, from: from, defender: defender) {
                defender.faction = newCard.faction
                changedCards.append(defender)

                if matchWon {
                    wins += 1
                    matches += 1
                } else {
                    matches += 1
                }
            }
        }
    }
    
    /*go through all possible neighbours starting with North
     check if the newCard has an arrow in the corresponding direction
     not elegant but does the trick*/
    
    //top of attacker
    //N
    if newCard.arrows[0] {
        if i - 1 >= 0 {
            makeMatch(i: i-1, j: j, from: 0)
        }
    }
    
    //right side of attacker
    if j + 1 < 4 {
        
        //NE
        if newCard.arrows[1] {
            if i - 1 >= 0 {
                makeMatch(i: i-1, j: j+1, from: 1)
            }
        }
        //E
        if newCard.arrows[2] {
            makeMatch(i: i, j: j+1, from: 2)
        }
        //SE
        if newCard.arrows[3] {
            if i + 1 < 4 {
                makeMatch(i: i+1, j: j+1, from: 3)
            }
            
        }
    }
    //bottom of attacker
    //S
    if newCard.arrows[4] {
        if i + 1 < 4 {
            makeMatch(i: i+1, j: j, from: 4)
        }
    }
    
    //right side of attacker
    if j - 1 >= 0 {
        
        //SW
        if newCard.arrows[5] {
            if i + 1 < 4 {
                makeMatch(i: i+1, j: j-1, from: 5)
            }
        }
        
        //W
        if newCard.arrows[6] {
            makeMatch(i: i, j: j-1, from: 6)
        }
        
        //NW
        if newCard.arrows[7] {
            if i - 1 >= 0 {
                makeMatch(i: i-1, j: j-1, from: 7)
            }
        }
    }
    
    if wins >= matches/2 {
        return changedCards
    } else {
        if newCard.faction == .blue {
            newCard.faction = .red
        } else {
            newCard.faction = .blue
        }
        
        changedCards.removeAll()
        changedCards.append(newCard)
        return changedCards
    }
    
}
