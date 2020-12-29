//
//  Stack.swift
//  TetraMaster
//
//  Created by Tim Musil on 28.11.20.
//

import SwiftUI

struct Stack: View {
    @EnvironmentObject var gameData: GameData
    var isPlayer: Bool
    
    var body: some View {
        VStack {
            HStack(spacing: 3) {
                
                ForEach(gameData.playerHand) { card in
                    
                    let cardIndex = gameData.playerHand.firstIndex(where: {$0.id == card.id})!
                    
                    Button(action: {
                        playSound(sound: "Equip", type: "mp3")
                        gameData.selectedCard = card
                        
                    }) {
                        
                        CardView(card:gameData.playerHand[cardIndex])
                            .scaleEffect(gameData.selectedCard?.id == card.id ? 1.2 : 1)
                            .opacity(gameData.playerHand[cardIndex].isPlaced ? 0 : 1)
                            .animation(.linear(duration: 0.3))
                        
                        
                    }.disabled(gameData.playerHand[cardIndex].isPlaced || gameData.selectedCard?.id == card.id || !gameData.playersTurn) //disables the button if the card is already set to the gameboard or currently selected, also when it's not the players turn
                    
                }
                
            }
            if gameData.counterTotal < 10 {
                if gameData.playersTurn {
                    if gameData.selectedCard != nil {
                        Text("\(gameData.selectedCard!.name) chosen.")
                            .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                            .foregroundColor(.white)
                        
                    } else {
                        Text("Choose a Card.")
                            .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                            .foregroundColor(.white)
                        
                    }
                } else {Text("Computers Turn.")
                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    .foregroundColor(.white)
                    
                }
            }
            
        }
        .font(.subheadline)
        
        
        
    }
}

struct Stack_Previews: PreviewProvider {
    static var previews: some View {
        Stack(isPlayer: true)
            .environmentObject(GameData())
    }
    
}
