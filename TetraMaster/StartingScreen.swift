//
//  StartingScreen.swift
//  TetraMaster
//
//  Created by Tim Musil on 29.11.20.
//

import SwiftUI

struct StartingScreen: View {
    var body: some View {
        
        NavigationView {
            ZStack {
                Color.white.edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
                VStack {
                    Spacer()
                    
                    //forgroundcolor black needs to be set to accomodate for dark mode at night
                    Group {
                        Text("Tetra Master")
                            .font(.title)
                        Text("with SwiftUI")
                            .font(.headline)
                            .fontWeight(.ultraLight)
                    }.foregroundColor(.black)
                    
                    Image("Start")
                        .resizable()
                        .scaledToFit()
                    Spacer()
                    
                    //Start Game Navigation Link
                    NavigationLink(destination: ShuffleScreen().navigationBarHidden(true).navigationBarBackButtonHidden(true)) {
                        Text("Start Game")
                    }
                    .simultaneousGesture(TapGesture().onEnded{
                        playSound(sound: "Heal", type: "mp3")
                    })
                    
                    Spacer()
                }
                .onAppear(perform: {
                    playMusic()
                })
                .navigationBarHidden(true)
                .navigationBarBackButtonHidden(true)
            }
        }
    }
}

struct StartingScreen_Previews: PreviewProvider {
    static var previews: some View {
        StartingScreen()
    }
}
    