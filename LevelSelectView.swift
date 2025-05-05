//
//  LevelSelectView.swift
//  gam
//
//  Created by Scaife, Benjamin (512176) on 5/1/25.
//

import SwiftUI

struct LevelSelectView: View {
    var body: some View {
        ZStack {
            Image("chalkbg")
                .scaleEffect(1.52)
            Text("LEVEL SELECT")
                .font(.custom("chalkduster", size: 50))
                .foregroundStyle(.white)
        }
        .ignoresSafeArea()
    }
}

#Preview {
    ShopView()
}
