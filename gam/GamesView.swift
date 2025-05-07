//
//  GamesView.swift
//  gam
//
//  Created by Popovich, Daniel (512413) on 4/30/25.
//

import SwiftUI
import SpriteKit

struct GamesView: View {
    @Environment(\.dismiss) public var dismiss;
    @State var backButton: Bool = true;
    var knots: SKScene {
        let scene = KnotsGame(size: UIScreen.main.bounds.size);
        scene.onGameOver = {
            dismiss();
        }
        return scene;
    } // thanks chatgpt
    var body: some View {
        NavigationView {
            ZStack {
                if (backButton) {
                    Button {
                        dismiss();
                    } label: {
                        Rectangle()
                            .fill(.clear)
                    }
                    .buttonMod(-120, -420, 100, 30, "Back")
                }
                NavigationLink {
                    SpriteView(scene: knots)
                        .ignoresSafeArea()
                        .navigationBarBackButtonHidden(true)
                } label: {
                    Rectangle()
                        .fill(.clear)
                }
                .buttonMod(0,0,100,30,"Knots")
                .onDisappear() {
                    backButton = false;
                }
            }
        }
    }
}

#Preview {
    GamesView()
}
