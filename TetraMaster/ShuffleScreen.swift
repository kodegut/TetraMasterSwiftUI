//
//  ShuffleScreen.swift
//  TetraMaster
//
//  Created by Tim Musil on 18.12.20.
//

import SwiftUI

struct ShuffleScreen: View {
    //gameData is needed to write back to the players hand when all cards are chosen
    @EnvironmentObject var gameData: GameData
    @State var shuffledCards = createRandomCards(for: .blue, amount: 9)
    @State var selectedCards: [Card] = []
    @State var selectedCardsCount = 0
    @State var shuffledAlready = false
    
    var body: some View {
        
        GeometryReader { gr in
            VStack {
                Spacer()
                Text("Choose your hand:")
                Spacer()
                ForEach(0...2, id: \.self) { i in
                    
                    HStack {
                        ForEach(0...2, id: \.self) { j in
                            
                            let cardIndex = selectedCards.firstIndex(where: {$0.id == shuffledCards[3*i+j].id})
                            
                            Button(action: {
                                
                                if cardIndex == nil {
                                    selectedCards.append(shuffledCards[3*i+j])
                                    playSound(sound: "Select", type: "mp3")
                                    selectedCardsCount += 1
                                    
                                } else {
                                    selectedCards.remove(at: cardIndex!)
                                    playSound(sound: "Cancel", type: "mp3")
                                    selectedCardsCount -= 1
                                }
                           
                            }) {
                                
                                CardView(card: shuffledCards[3*i+j]).padding(2).border(cardIndex == nil ? Color.init(white: 0, opacity: 0) : Color.blue)
                                    .scaleEffect(cardIndex == nil  ? 1 : 1.08)
                            }
                            .disabled(selectedCardsCount >= 5 && cardIndex == nil)
                            .frame(width: gr.size.width/4, height: gr.size.width/4*(102/84) )
                        }
                    }
                }
                Spacer()
                
                //Navigationlink sets to new screen once we are done
                NavigationLink(destination: TetraMasterGame()) {
                    Text(selectedCardsCount < 5 ? "Choose \(5 - selectedCardsCount) more" : "Go with these")
                }.disabled(selectedCardsCount < 5)
                .simultaneousGesture(TapGesture().onEnded{
                    if selectedCardsCount >= 5 {
                        playSound(sound: "Select", type: "mp3")
                        gameData.playerHand = selectedCards
                        
                        //safe card constellation for rematch
                        gameData.chosenHandPlayer = selectedCards
                        gameData.chosenHandComputer = gameData.computerHand
                        music.stop()
                    }
                })
                Spacer()
                
                //Shuffle Button to reshuffle the cards once
                Button(action: {
                    shuffledCards = createRandomCards(for: .blue, amount: 9)
                    shuffledAlready.toggle()
                    selectedCards.removeAll()
                    selectedCardsCount = 0
                    playSound(sound: "Fist", type: "mp3")
                    
                }, label: {
                    Text("Shuffle again")
                }).disabled(shuffledAlready)
                
                Spacer()
                
                Text(shuffledAlready ? " " : "You can shuffle only once.")
            }
            .frame(width: gr.size.width, height: gr.size.height)
        }
    }
}

struct ShuffleScreen_Previews: PreviewProvider {
    static var previews: some View {
        ShuffleScreen()
            .environmentObject(GameData())
    }
}
