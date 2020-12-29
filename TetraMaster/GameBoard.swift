//
//  GameBoard.swift
//  TetraMaster
//
//  Created by Tim Musil on 28.11.20.
//

import SwiftUI

struct GameBoard: View {
    @EnvironmentObject var gameData: GameData
    @State var gameFinished = true
    
    var body: some View {
        GeometryReader { gr in
            ZStack {
                VStack {
                    ForEach(0...3, id: \.self) { i in
                        HStack {
                            ForEach(0...3, id: \.self) { j in
                                Button(action: {
                                    let durationPlayer = playerTurn(i: i, j: j)
                                    DispatchQueue.main.asyncAfter(deadline: .now() + durationPlayer + 1.0){
                                        if !gameFinished {
                                            computerTurn()
                                        }
                                    }
                                }) {
                                    
                                    if gameData.placedCards[i][j] == nil {
                                        Image("Border")
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                    } else {
                                        CardView(card: gameData.placedCards[i][j]!)
                                    }
                                }.disabled(gameData.selectedCard == nil || gameData.placedCards[i][j] != nil || !gameData.playersTurn)
                                //give it a frame that keeps cards proportions
                                .frame(width: gr.size.width/4.8, height: gr.size.width/4.8*(102/84) )
                            }
                        }
                    }
                }
                .padding(5)
                
                //show result after game is finished and provide input for rematch/restart
                if gameFinished {
                    
                    ZStack {
                        Color.black
                            .edgesIgnoringSafeArea(.all)
                        VStack {
                            Spacer()
                            Group {
                                if gameData.counterBlue > gameData.counterRed {
                                    Text("You won!")
                                } else if gameData.counterBlue < gameData.counterRed {
                                    Text("You Lost!")
                                } else {
                                    Text("Draw.")
                                }
                            }.foregroundColor(.white)
                            
                            Spacer()
                            
                            //Button for restart
                            NavigationLink(destination: StartingScreen().navigationBarHidden(true).navigationBarBackButtonHidden(true)) {
                                Text("Restart")
                            }.simultaneousGesture(TapGesture().onEnded {
                                playSound(sound: "Cancel", type: "mp3")
                                //gameFinished = false //can't go here because it breaks the navigationlink -> moved to on appear on Gameboard
                                gameData.placedCards = [[Card?]](repeating: [Card?](repeating: nil, count: 4), count: 4)
                                //create new cards for computer
                                gameData.computerHand = createRandomCards(for: .red, amount: 5)
                            })
                            Spacer()
                            
                            //Button for rematch
                            Button(action: {
                                playSound(sound: "Select", type: "mp3")
                                gameFinished = false
                                gameData.placedCards = [[Card?]](repeating: [Card?](repeating: nil, count: 4), count: 4)
                                gameData.playerHand = gameData.chosenHandPlayer
                                gameData.computerHand = gameData.chosenHandComputer
                                setCounters()
                                gameData.playersTurn = Bool.random()
                                if !gameData.playersTurn {
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 1){
                                        computerTurn()
                                    }
                                }
                            }
                            , label: {
                                Text("Rematch")
                            }
                            )
                            Spacer()
                        }
                        
                    }
                }
            }
            .frame(width: gr.size.width, height: gr.size.height)
            .onAppear(perform: {
                gameFinished = false
                gameData.playersTurn = Bool.random()
                if !gameData.playersTurn {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1){
                        computerTurn()
                    }
                }
            })
        }
    }
    
    /* execute the computers turn */
    func computerTurn() {
        //makeChoice returns an UUID at 0 and a tuple of integers at 1
        let choice = makeChoice(hand: gameData.computerHand, placedCards: gameData.placedCards)
        let i = choice.1[0]
        let j = choice.1[1]
        //get index of computer hand to access and update it before placing it into placedCards
        if let cardIndex = gameData.computerHand.firstIndex(where: {$0.id == choice.0}) {
            gameData.computerHand[cardIndex].isPlaced = true
            gameData.computerHand[cardIndex].currentLocation = [i,j]
            gameData.placedCards[i][j] = gameData.computerHand[cardIndex]
            let duration = animateBattle(for: cardIndex, asPlayer: false)
            DispatchQueue.main.asyncAfter(deadline: .now() + duration + 1){
                if !gameFinished {
                    gameData.playersTurn.toggle()
                    playSound(sound: "Switch", type: "mp3")
                }
            }
        }
    }
    
    /* execute the players turn */
    func playerTurn(i: Int, j: Int) -> Double {
        
        if let selectedCard = gameData.selectedCard {
            if let cardIndex = gameData.playerHand.firstIndex(where: {$0.id == selectedCard.id}) {
                gameData.playerHand[cardIndex].isPlaced = true
                gameData.playerHand[cardIndex].currentLocation = [i,j]
                gameData.placedCards[i][j] = gameData.playerHand[cardIndex]
                let duration = animateBattle(for: cardIndex, asPlayer: true)
                gameData.selectedCard = nil
                gameData.playersTurn.toggle()
                return duration
            }
        }
        return 0.0
    }
    
    /* animate the change of card colors */
    func animateBattle(for cardIndex: Array<Card>.Index, asPlayer: Bool) -> Double {
        
        let changedCards = cardBattle(newCard: asPlayer ? gameData.playerHand[cardIndex] : gameData.computerHand[cardIndex], placedCards: gameData.placedCards)
        var duration = 0.0
        if changedCards.count > 0 {
            duration = 0.5 * Double(changedCards.count)
            var loopDuration = 0.0
            for card in changedCards {
                if let location = card.currentLocation {
                    let i = location[0]
                    let j = location[1]
                    
                    // options I tried for a delay between card changes are sleep(), Timer or DispatchQueue.main.asyncAfter, there seems to be no option to get a callback from an animation by default
                    DispatchQueue.main.asyncAfter(deadline: .now() + loopDuration){
                        gameData.placedCards[i][j] = card
                        setCounters()
                        //sound played when battle takes place
                        playSound(sound: "Heal", type: "mp3")
                    }
                }
                loopDuration += 0.5
            }
            
        } else {
            //sound played when no battle takes place
            playSound(sound: "Fist", type: "mp3")
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + duration){
            setCounters()
            if gameData.counterTotal >= 10 {
                withAnimation(Animation.easeIn(duration: 2)) {
                    gameFinished = true
                }
            }
        }
        return duration
    }
    
    /* set counters on execution based on the cards that are placed on the board */
    func setCounters(){
        
        var counterBlue = 0
        var counterRed = 0
        
        for line in gameData.placedCards {
            for card in line {
                if card?.faction == .blue {
                    counterBlue += 1
                }
                if card?.faction == .red {
                    counterRed += 1
                }
            }
        }
        gameData.counterBlue = counterBlue
        gameData.counterRed = counterRed
        gameData.counterTotal = counterBlue + counterRed
    }
    
}

struct GameBoard_Previews: PreviewProvider {
    static var previews: some View {
        GameBoard()
            .environmentObject(GameData())
    }
}
