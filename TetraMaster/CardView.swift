//
//  CardView.swift
//  TetraMaster
//
//  Created by Tim Musil on 29.11.20.
//
// I need the GeometryReader in this view to size the text correctly, however this leads to weird behaviour (spaces everything out to bottom) that I don't have a fix for currently. I could of course give everything a fix size, but that would be lazy.

import SwiftUI

struct CardView: View {
    var card: Card
    var body: some View {
            
            GeometryReader { gr in
                ZStack {
                    
                    Image(card.faction == .blue ? "blue" : "red").resizable().aspectRatio(contentMode: .fit)
                    Image(card.image).resizable().aspectRatio(contentMode: .fit)
                        .overlay(
                            HStack(spacing: 1) {
                                StrokeText(text: "\(self.card.strength)", width: 1, color: .black)
                                StrokeText(text: "\(self.card.cardType == .P ? "P" : "M")", width: 1, color: .black)
                                StrokeText(text: "\(self.card.physicalDefense)", width: 1, color: .black)
                                StrokeText(text: "\(self.card.magicDefense)", width: 1, color: .black)
                            }
                            .font(.system(size: gr.size.height > gr.size.width ? gr.size.width * 0.18: gr.size.height * 0.18, design: .rounded))
                            .padding(.bottom, gr.size.height/15)
                            .foregroundColor(.yellow)
                            , alignment: .bottom)
                        
                        //N
                    
                        .overlay(Image("arrow").resizable().frame(width: gr.size.width/7, height: gr.size.width/7).opacity(card.arrows[0] ? 1.0 : 0.0).rotationEffect(.degrees(-47)).padding(4), alignment: .top)
                        
                        //NE
                        .overlay(Image("arrow").resizable().frame(width: gr.size.width/7, height: gr.size.width/7).opacity(card.arrows[1] ? 1.0 : 0.0).padding(3), alignment: .topTrailing)
                        
                        //E
                        .overlay(Image("arrow").resizable().frame(width: gr.size.width/7, height: gr.size.width/7).opacity(card.arrows[2] ? 1.0 : 0.0).rotationEffect(.degrees(43)).padding(5), alignment: .trailing)
                        
                        //SE
                        .overlay(Image("arrow").resizable().frame(width: gr.size.width/7, height: gr.size.width/7).opacity(card.arrows[3] ? 1.0 : 0.0).rotationEffect(.degrees(90)).padding(3), alignment: .bottomTrailing)
                        
                        //S
                        .overlay(Image("arrow").resizable().frame(width: gr.size.width/7, height: gr.size.width/7).opacity(card.arrows[4] ? 1.0 : 0.0).rotationEffect(.degrees(135)).padding(4), alignment: .bottom)
                        
                        //SW
                        .overlay(Image("arrow").resizable().frame(width: gr.size.width/7, height: gr.size.width/7).opacity(card.arrows[5] ? 1.0 : 0.0).rotationEffect(.degrees(-180)).padding(3), alignment: .bottomLeading)
                        
                        //W
                        .overlay(Image("arrow").resizable().frame(width: gr.size.width/7, height: gr.size.width/7).opacity(card.arrows[6] ? 1.0 : 0.0).rotationEffect(.degrees(-137)).padding(5), alignment: .leading)
                        
                        //NW
                        .overlay(Image("arrow").resizable().frame(width: gr.size.width/7, height: gr.size.width/7).opacity(card.arrows[7] ? 1.0 : 0.0).rotationEffect(.degrees(-90)).padding(3), alignment: .topLeading)
   
                }
                .frame(width: gr.size.width, height: gr.size.height)
                
            }
    }
}

/* This is needed because there is no out of the box stroke for text. Works "OK" */
struct StrokeText: View {
    let text: String
    let width: CGFloat
    let color: Color
    
    var body: some View {
        ZStack{
            ZStack{
                Text(text).offset(x:  width, y:  width)
                Text(text).offset(x: -width, y: -width)
                Text(text).offset(x: -width, y:  width)
                Text(text).offset(x:  width, y: -width)
            }
            .foregroundColor(color)
            Text(text)
        }
    }
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        CardView(card: Card(image: "015", name: "Tomberry", faction: .blue, strength: 3, cardType: .P, physicalDefense: 0, magicDefense: 3, arrows: [true, false, true, false, true, false, true, true], isPlaced: true))
            .environmentObject(GameData())
    }
}
