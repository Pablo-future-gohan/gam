//
//  CreditsView.swift
//  gam
//
//  Created by 3 Kings on 5/23/25.
// A little goodbye to the guys




import SwiftUI
import SpriteKit

struct CreditsView: View {
    @Environment(\.dismiss) public var dismiss;

    var body: some View {
        
        
        ZStack{
            
            //Gets the background to match the other background
            Rectangle()
                .fill(Color(red: 0.15, green: 0.15, blue: 0.15))
                .ignoresSafeArea()

            
            //back button
            HStack{
                
                VStack(alignment: .leading){
                    NavigationLink {
                        
                        ContentView()
                            .navigationBarBackButtonHidden(true)


                    } label: {
                        Rectangle()
                            .fill(.clear)
                    }
                    .buttonMod(0, 0, 100, 30, "Back")
                    .navigationBarBackButtonHidden(true)
                    Spacer()
                        .frame(maxWidth: .infinity)
                }
                .padding(20)
                .ignoresSafeArea()

            }
            
            
            //The credits of us who worked on the app
            VStack{
                Text("Jester-Ace-King Inqlumpulated")
                    .font(.custom("chalkduster", size: 30))
                    .foregroundStyle(.white)
                
                    Spacer()
                    .frame(height: 250)

                Text("Daniel \"Pablo\" Popovich")
                    .font(.custom("chalkduster", size: 20))
                    .foregroundStyle(.white)
                Text("Gus \"Perfect\" Meccia")
                    .font(.custom("chalkduster", size: 20))
                    .foregroundStyle(.white)
                Text("Ben \"Legendary\" Scaife")
                    .font(.custom("chalkduster", size: 20))
                    .foregroundStyle(.white)
                Spacer()
                .frame(height: 250)

            }
        }
    }
    
}

#Preview {
    CreditsView()
}
