//
//  ComputerStack.swift
//  TetraMaster
//
//  Created by Tim Musil on 06.12.20.
//

import SwiftUI

struct ComputerStack: View {
    @EnvironmentObject var gameData: GameData
    @State private var flipped = false
    @State private var animate3d = false
    
    
    var body: some View {
        VStack {
            HStack(spacing: 3) {
                
                ForEach(gameData.computerHand) { card in
                    ZStack {
                        let cardIndex = gameData.computerHand.firstIndex(where: {$0.id == card.id})!
                        
                        Image("back").resizable().scaledToFit().opacity(gameData.computerHand[cardIndex].isPlaced ? 0 : 1)
                        
                        CardView(card: gameData.computerHand[cardIndex])
                            .opacity(gameData.computerHand[cardIndex].isPlaced ? 0 : 1).opacity(flipped ? 1.0 : 0.0)
                        
                    }
                    // the modifier creates a flipeffect on tap to see the computers cards
                    .modifier(FlipEffect(flipped: $flipped, angle: animate3d ? 180 : 0, axis: (x: 0, y: 1)))
                    .onTapGesture {
                        withAnimation(Animation.linear(duration: 0.8)) {
                            self.animate3d.toggle()
                        }
                    }
                }
                
            }

        }
    }
}


struct ComputerStack_Previews: PreviewProvider {
    static var previews: some View {
        ComputerStack()
            .environmentObject(GameData())
    }
}
