//
//  ContentView.swift
//  gam
//
//  Created by Popovich, Daniel (512413) on 4/30/25.
//

import SwiftUI
import SpriteKit

struct ButtonModifier: ViewModifier {
    let x: CGFloat
    let y: CGFloat
    let w: CGFloat
    let h: CGFloat
    let text: String
    func body(content: Content) -> some View {
        content
            .frame(width: w, height: h)
            .background(
                Text(text)
                    .foregroundStyle(.black)
                    .font(.custom("Chalkduster", size: 18))
                    .frame(width: w, height: h)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .foregroundColor(.green)
                    )
            )
            .offset(x: x, y: y)
    }
}

extension View{
    func buttonMod(_ x: CGFloat = 0, _ y: CGFloat = 0, _ w: CGFloat = 100, _ h: CGFloat = 50, _ text: String) -> some View {
        self.modifier(ButtonModifier(x: x, y: y, w: w, h: h, text: text))
    }
}

struct ContentView: View {
    
    var money: Int = 0
    
    var body: some View {
        NavigationView {
            ZStack {
                GeometryReader { geometry in
                    SpriteView(scene: BlobView(size: geometry.size))
                }
                .ignoresSafeArea()
                NavigationLink {
                    ShopView()
                        .offset(y: -20)
                }
                label: {
                    Rectangle()
                        .fill(.clear)
                }
                .buttonMod(-125, -370, 105, 90, "The Shop")
                NavigationLink {
                    ShopView()
                        .offset(y: -25)
                }
                label: {
                    Rectangle()
                        .fill(.clear)
                }
                .buttonMod(125, -370, 105, 90, "Worlds")
                Rectangle()
                    .fill(.clear)
                    .buttonMod(0, -350, 100, 50, "$\(money)")
            }
        }
    }
}

#Preview {
    ContentView()
}
