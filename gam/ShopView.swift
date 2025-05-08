//
//  ShopView.swift
//  gam
//
//  Created by Scaife, Benjamin (512176) on 4/30/25.
//

import SwiftUI

struct ShopView: View {
    
    @State var tab = 0
    var boxSize: CGFloat = 100
    var spacing: CGFloat = 10
    
    @State var ShopItems = [
        ["Red", "Blue", "Green"],
        ["Hat", "Chain"],
        ["Chair", "Rope Swing"],
    ]
    
    var body: some View {
        ZStack {
            Image("chalkbg")
                .scaleEffect(1.52)
            ScrollView {
                Rectangle()
                    .frame(width: 1, height: 50)
                    .opacity(0)
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
                        }
                        label: {
                            Rectangle()
                                .stroke(.white, lineWidth: 3)
                                .frame(width: 100, height: 65)
                                .padding(3)
                        }
                    }
                }
                Rectangle()
                    .stroke(.white, lineWidth: 3)
                    .frame(width: 350, height: 5)
                ZStack {
                    ForEach(0..<Int(ShopItems[tab].count)) {i in
                        Button {
                            tab = i
                        }
                        label: {
                            Rectangle()
                                .stroke(.white, lineWidth: 3)
                                .frame(width: boxSize, height: boxSize)
                                .padding(3)
                        }
                        .offset(x: (boxSize + spacing) * CGFloat((i % 3) - 1),
                            y: (boxSize + spacing) * CGFloat(Int(i / 3)))
                        
                    }
                }
            }
        }
        .ignoresSafeArea()
    }
}

#Preview {
    ShopView()
}
