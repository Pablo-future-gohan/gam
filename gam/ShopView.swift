//
//  ShopView.swift
//  gam
//
//  Created by Scaife, Benjamin (512176) on 4/30/25.
//

import SwiftUI

struct ShopView: View {
    
    @Environment(\.dismiss) public var dismiss;
    
    @State var tab = 0
    @State var selectedButton = -1
    var boxSize: CGFloat = 100
    var spacing: CGFloat = 10
    var money: Int
    let numButtons = 30
    
    @State var ShopTabs = ["Colors", "Hats", "Decor"]
    
    @State var ShopItems = [
        ["0Red", "0Blue", "0Green", "0Yellow", "0Purple", "0Orange"],
        ["0Hat", "0Chain"],
        ["0Chair", "0Rope Swing"],
    ]
    
    var body: some View {
        ZStack {
            Image("chalkbg")
                .scaleEffect(1.52)
            VStack {
                HStack {
                    Button {
                        dismiss();
                    }
                    label: {
                        Text("Back")
                        .font(.custom("chalkduster", size: 25))
                        .foregroundStyle(.white)
                    }
                    .offset(x: -85, y: 12)
                    Text("$\(money)")
                        .font(.custom("chalkduster", size: 25))
                        .foregroundStyle(.white)
                        .offset(x: 85, y: 12)
                }
                Text("BLOB SHOP")
                    .font(.custom("chalkduster", size: 60))
                    .foregroundStyle(.white)
                    .padding(-5)
                Rectangle()
                    .stroke(.white, lineWidth: 3)
                    .frame(width: 350, height: 5)
                HStack {
                    ForEach(0..<3) { i in
                        Button {
                            tab = i
                            selectedButton = -1
                        }
                        label: {
                            ZStack {
                                Rectangle()
                                    .stroke(.white, lineWidth: 3)
                                    .frame(width: 100, height: 65)
                                    .padding(3)
                                Text(ShopTabs[i])
                                    .frame(width: 100, height: 65)
                                    .foregroundStyle(.white)
                                    .font(.custom("Chalkduster", size: 22))
                            }
                        }
                    }
                }
                Rectangle()
                    .stroke(.white, lineWidth: 3)
                    .frame(width: 350, height: 5)
                ZStack {
                    ScrollView {
                        ZStack {
                            ForEach(0..<30) {i in
                                Button {
                                    selectedButton = (selectedButton == i) ? -1 : i
                                }
                            label: {
                                Rectangle()
                                    .stroke(.white, lineWidth: 3)
                                    .frame(width: boxSize, height: boxSize)
                                    .padding(3)
                                    .background(
                                        ZStack {
                                            Rectangle()
                                                .stroke((selectedButton == i) ? .white : .clear, lineWidth: 3)
                                                .frame(width: boxSize * 0.9, height: boxSize * 0.9)
                                            Text((i < ShopItems[tab].count) ? ShopItems[tab][i].dropFirst() : "Coming Soon")
                                                .font(.custom("Chalkduster", size: 20))
                                                .foregroundStyle(.white)
                                        }
                                    )
                            }
                            .offset(x: (boxSize + spacing) * CGFloat((i % 3) - 1),
                                    y: (boxSize + spacing) * CGFloat(Int(i / 3)))
                                
                            }
                        }
                        .frame(width: 400, height: 1200)
                        .offset(y: -545)
                    }
                }
                .frame(width: 400, height: UIScreen.main.bounds.height - 300)
                Rectangle()
                    .stroke(.white, lineWidth: 3)
                    .frame(width: 350, height: 5)
                Text("hi")
                    .font(.custom("Chalkduster", size: 40))
                    .foregroundStyle(.white)
                    .padding(-2)
                
            }
        }
        .ignoresSafeArea()
    }
}

#Preview {
    ShopView(money: 300)
}
