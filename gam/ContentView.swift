//
//  ContentView.swift
//  gam
//
//  Created by Popovich, Daniel (512413) on 4/30/25.
//

import SwiftUI
import SpriteKit

struct ContentView: View {
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
                    ZStack {
                        RoundedRectangle(cornerRadius: 20)
                            .frame(width: 110, height: 60)
                        Text("The Shop")
                            .foregroundStyle(.black)
                            .font(.custom("Chalkduster", size: 18))
                    }
                }
                .offset(x: -125, y: -390)
                NavigationLink {
                    ShopView()
                        .offset(y: -20)
                }
                label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 20)
                            .frame(width: 110, height: 60)
                        Text("Worlds")
                            .foregroundStyle(.black)
                            .font(.custom("Chalkduster", size: 18))
                    }
                }
                .offset(x: 125, y: -390)
            }
        }
    }
}

#Preview {
    ContentView()
}
