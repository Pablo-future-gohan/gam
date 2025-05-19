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
    let buttonWidth: Double = 240;
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
    var barrels: SKScene {
        let scene = Barrels(size: UIScreen.main.bounds.size);
        scene.onGameOver = {
            dismiss();
        }
        return scene;
    } // thanks chatgpt
    var duckHunt: SKScene {
        let scene = DuckHunt(size: UIScreen.main.bounds.size);
        scene.onGameOver = {
            dismiss();
        }
        return scene;
    } // thanks chatgpt
    var body: some View {
        NavigationView {
            ZStack {
                VStack(alignment: .leading) {
                    Button {
                        dismiss();
                    } label: {
                        Rectangle()
                            .fill(.clear)
                    }
                    .buttonMod(0, 0, 100, 30, "Back")
                    Spacer()
                        .frame(maxWidth: .infinity)
                }
                .padding(20)
                .ignoresSafeArea()
                VStack {
                    NavigationLink {
                        SpriteView(scene: knots)
                            .ignoresSafeArea()
                            .navigationBarBackButtonHidden(true)
                    } label: {
                        Rectangle()
                            .fill(.clear)
                    }
                    .buttonMod(0,0,buttonWidth,30,"Knots")
                    .padding(5)
                    NavigationLink {
                        SpriteView(scene: stimOut)
                            .ignoresSafeArea()
                            .navigationBarBackButtonHidden(true)
                    } label: {
                        Rectangle()
                            .fill(.clear)
                    }
                    .buttonMod(0,0,buttonWidth,30,"Stim Out")
                    .padding(5)
                    NavigationLink {
                        SpriteView(scene: ballJuggler)
                            .ignoresSafeArea()
                            .navigationBarBackButtonHidden(true)
                    } label: {
                        Rectangle()
                            .fill(.clear)
                    }
                    .buttonMod(0,0,buttonWidth,30,"Ball Jugglin'")
                    .padding(5)
                    NavigationLink {
                        SpriteView(scene: whackAMole)
                            .ignoresSafeArea()
                            .navigationBarBackButtonHidden(true)
                    } label: {
                        Rectangle()
                            .fill(.clear)
                    }
                    .buttonMod(0,0,buttonWidth,30,"Whack-A-Mole")
                    .padding(5)
                    NavigationLink {
                        SpriteView(scene: ballRoller)
                            .ignoresSafeArea()
                            .navigationBarBackButtonHidden(true)
                    } label: {
                        Rectangle()
                            .fill(.clear)
                    }
                    .buttonMod(0,0,buttonWidth,30,"Ball Roller")
                    .padding(5)
                    NavigationLink {
                        SpriteView(scene: barrels)
                            .ignoresSafeArea()
                            .navigationBarBackButtonHidden(true)
                    } label: {
                        Rectangle()
                            .fill(.clear)
                    }
                    .buttonMod(0,0,buttonWidth,30,"Barrels")
                    .padding(5)
                    NavigationLink {
                        SpriteView(scene: duckHunt)
                            .ignoresSafeArea()
                            .navigationBarBackButtonHidden(true)
                    } label: {
                        Rectangle()
                            .fill(.clear)
                    }
                    .buttonMod(0,0,buttonWidth,30,"Duck Hunt")
                    .padding(5)
                }
            }
        }
    }
}

#Preview {
    GamesView()
}
