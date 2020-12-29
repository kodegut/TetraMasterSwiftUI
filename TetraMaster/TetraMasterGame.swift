//
//  ContentView.swift
//  TetraMaster
//
//  Created by Tim Musil on 28.11.20.
//

import SwiftUI

struct TetraMasterGame: View {
    @EnvironmentObject var gameData: GameData
    @State var beginnerSet: Bool = false
    
    var body: some View {
        ZStack {
            
            //Top changing color based on whos turn it is
            if gameData.playersTurn {
                Color(red: 108/255, green: 142/255, blue: 214/255, opacity: 1.0)
                    .edgesIgnoringSafeArea(.top)
            } else {
                Color(red: 232/255, green: 157/255, blue: 116/255, opacity: 1.0)
                    .edgesIgnoringSafeArea(.top)
            }
        
            Color.black
                .edgesIgnoringSafeArea(.bottom)
            
            GeometryReader { gr in
                VStack {
                    Spacer()
                    HStack {
                        Text("\(gameData.counterBlue)")
                            .foregroundColor(Color(red: 108/255, green: 142/255, blue: 214/255, opacity: 1.0))
                        Text("/")
                            .foregroundColor(.white)
                            .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                        Text("\(gameData.counterRed)")
                            .foregroundColor(Color(red: 232/255, green: 157/255, blue: 116/255, opacity: 1.0))
                            .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                        Spacer()
                        if gameData.counterTotal < 10 {
                            Text("Current Turn: \(gameData.playersTurn ? " 🟦" : " 🟥")")
                                .foregroundColor(.white)
                        }
                        
                    }.padding(.horizontal).font(.subheadline)
                    
                    //this needs a calculation for the aspect ratio and orientation of multiple devices
                    ComputerStack()
                        .frame( height: gr.size.height * 0.13, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    
                    GameBoard()
                        .frame( height: gr.size.height * 0.6, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    Spacer()
                    
                    Stack(isPlayer: true)
                        .frame( height: gr.size.height*0.20, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                }
                .padding(.horizontal)
                
            }
            
        }
        .onAppear(perform: {
            playGameMusic()
        }).navigationBarHidden(true)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        TetraMasterGame()
            .environmentObject(GameData())
        
    }
}
