//
//  RotationEffect.swift
//  TetraMaster
//
//  Created by Tim Musil on 19.12.20.
//

import SwiftUI

/* RotationEffect is only used to test FlipEffect */
struct RotationEffect: View {
    var card: Card
    @State private var flipped = false
    @State private var animate3d = false

    var body: some View {

          return VStack {
                Spacer()

                ZStack() {
                    Image("back").resizable().scaledToFit().opacity(flipped ? 0.0 : 1.0)
                    CardView(card: card).opacity(flipped ? 1.0 : 0.0)
                }
                .modifier(FlipEffect(flipped: $flipped, angle: animate3d ? 180 : 0, axis: (x: 0, y: 1)))
                .onTapGesture {
                      withAnimation(Animation.linear(duration: 0.8)) {
                            self.animate3d.toggle()
                        
                      }
                }
                Spacer()
          }
    }
}

/* got this beautiful solution here: https://stackoverflow.com/a/60807269
 The effect is used to flip the computers card on tap */
struct FlipEffect: GeometryEffect {

      var animatableData: Double {
            get { angle }
            set { angle = newValue }
      }

      @Binding var flipped: Bool
      var angle: Double
      let axis: (x: CGFloat, y: CGFloat)

      func effectValue(size: CGSize) -> ProjectionTransform {

            DispatchQueue.main.async {
                  self.flipped = self.angle >= 90 && self.angle < 270
            }

            let tweakedAngle = flipped ? -180 + angle : angle
            let a = CGFloat(Angle(degrees: tweakedAngle).radians)

            var transform3d = CATransform3DIdentity;
            transform3d.m34 = -1/max(size.width, size.height)

            transform3d = CATransform3DRotate(transform3d, a, axis.x, axis.y, 0)
            transform3d = CATransform3DTranslate(transform3d, -size.width/2.0, -size.height/2.0, 0)

            let affineTransform = ProjectionTransform(CGAffineTransform(translationX: size.width/2.0, y: size.height / 2.0))

            return ProjectionTransform(transform3d).concatenating(affineTransform)
      }
}


struct RotationEffect_Previews: PreviewProvider {
    static var previews: some View {
        RotationEffect(card: Card(image: "015", name: "Tomberry", faction: .blue, strength: 3, cardType: .P, physicalDefense: 0, magicDefense: 3, arrows: [true, false, true, false, true, false, true, true], isPlaced: true))
    }
}



