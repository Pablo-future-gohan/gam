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
    let buttonCol1 = Color(hue: 0.8, saturation: 1, brightness: 1)
    let buttonCol2 = Color(hue: 0.75, saturation: 0.9, brightness: 0.65)
    
    func body(content: Content) -> some View {
        content
            .frame(width: w, height: h)
            .background(
                Text(text)
                    .foregroundStyle(.white)
                    .font(.custom("PixelEmulator", size: 24))
                    .frame(width: w, height: h)
                    .minimumScaleFactor(0.5)
                    .background(
                        ZStack {
                            Rectangle()
                                .foregroundColor(buttonCol2)
                                .offset(y: 10)
                            Rectangle()
                                .foregroundColor(buttonCol1)
                        }
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
    
    let defaults = UserDefaults.standard
    @State var cash = 0;
    
    var body: some View {
        NavigationView {
            ZStack {
                GeometryReader { geometry in
                    SpriteView(scene: BlobView(size: geometry.size))
                }
                .ignoresSafeArea()
                VStack {
                    HStack(alignment: .bottom) {
                        NavigationLink {
                            ShopView()
                                .navigationBarBackButtonHidden(true)
                        }
                        label: {
                            Rectangle()
                                .fill(.clear)
                        }
                        .buttonMod(0, 0, 105, 90, "Shop")
                        Spacer()
                        Rectangle()
                            .fill(.clear)
                            .buttonMod(0, 0, 120, 50, "$\(cash)")
                        Spacer()
                        NavigationLink {
                            GamesView()
                                .navigationBarBackButtonHidden(true)
                        }
                        label: {
                            Rectangle()
                                .fill(.clear)
                        }
                        .buttonMod(0, 0, 105, 90, "Games")
                    }
                    Spacer()
//                    Button {
//                        defaults.set(0, forKey: "Money")
//                        cash = (defaults.object(forKey: "Money") as? Int ?? 0)
//                    } label: {
//                        Rectangle().frame(height: 50)
//                    }
                }
                .padding(25)
                .ignoresSafeArea(.all)
            }
            .onAppear {
                cash = (defaults.object(forKey: "Money") as? Int ?? 0)
            }
        }
    }
}
    

#Preview {
    ContentView()
}
