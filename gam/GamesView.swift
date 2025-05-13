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
    var ballJuggler: SKScene {
        let scene = BallJuggler(size: UIScreen.main.bounds.size);
        scene.onGameOver = {
            dismiss();
        }
        return scene;
    } // thanks chatgpt
    var whackAMole: SKScene {
        let scene = WhackAMoleScene(size: UIScreen.main.bounds.size);
        scene.onGameOver = {
            dismiss();
        }
        return scene;
    } // thanks chatgpt
    var ballRoller: SKScene {
        let scene = BallRollerScene(size: UIScreen.main.bounds.size);
        scene.onGameOver = {
            dismiss();
        }
        return scene;
    } // thanks chatgpt
    var stimOut: SKScene {
        let scene = StimOut(size: UIScreen.main.bounds.size);
        scene.onGameOver = {
            dismiss();
        }
        return scene;
    } // thanks chatgpt
    var body: some View {
        NavigationView {
            ZStack {
                Button {
                    dismiss();
                } label: {
                    Rectangle()
                        .fill(.clear)
                }
                .buttonMod(-120, -410, 100, 30, "Back")
                NavigationLink {
                    SpriteView(scene: knots)
                        .ignoresSafeArea()
                        .navigationBarBackButtonHidden(true)
                } label: {
                    Rectangle()
                        .fill(.clear)
                }
                .buttonMod(0,90,180,30,"Knots")
                NavigationLink {
                    SpriteView(scene: stimOut)
                        .ignoresSafeArea()
                        .navigationBarBackButtonHidden(true)
                } label: {
                    Rectangle()
                        .fill(.clear)
                }
                .buttonMod(0,45,180,30,"Stim Out")
                NavigationLink {
                    SpriteView(scene: ballJuggler)
                        .ignoresSafeArea()
                        .navigationBarBackButtonHidden(true)
                } label: {
                    Rectangle()
                        .fill(.clear)
                }
                .buttonMod(0,0,180,30,"Ball Jugglin'")
                NavigationLink {
                    SpriteView(scene: whackAMole)
                        .ignoresSafeArea()
                        .navigationBarBackButtonHidden(true)
                } label: {
                    Rectangle()
                        .fill(.clear)
                }
                .buttonMod(0,-45,180,30,"Whack-A-Mole")
                NavigationLink {
                    SpriteView(scene: ballRoller)
                        .ignoresSafeArea()
                        .navigationBarBackButtonHidden(true)
                } label: {
                    Rectangle()
                        .fill(.clear)
                }
                .buttonMod(0,-90,180,30,"Ball Roller")
            }
        }
    }
}

#Preview {
    GamesView()
}
