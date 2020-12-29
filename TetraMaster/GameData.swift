//
//  UserData.swift
//  TetraMaster
//
//  Created by Tim Musil on 28.11.20.
//

import Combine
import SwiftUI



final class GameData: ObservableObject {
    
    // turn is either the player or the computer
    @Published var playersTurn: Bool = true
    
    // card that is highlighted in the stack
    @Published var selectedCard: Card?
    
    // cards that are in the players stack
    @Published var playerHand = createRandomCards(for: .blue, amount: 5)
    
    // original cards that the player chose in the ShuffleScreen stored in case of a rematch
    @Published var chosenHandPlayer: [Card] = []

    // cards that are in the computers stack
    @Published var computerHand = createRandomCards(for: .red, amount: 5)
    
    // original cards that the computer "chose" in the ShuffleScreen stored in case of a rematch
    @Published var chosenHandComputer: [Card] = []
        
    // cards that are placed on the game board, initially filled with nil
    @Published var placedCards = [[Card?]](repeating: [Card?](repeating: nil, count: 4), count: 4)
    
    // game counters for red blue and total
    @Published var counterBlue = 0
    @Published var counterRed = 0
    @Published var counterTotal = 0
   
}
