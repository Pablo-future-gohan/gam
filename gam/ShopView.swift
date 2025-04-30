//
//  ShopView.swift
//  gam
//
//  Created by Scaife, Benjamin (512176) on 4/30/25.
//

import SwiftUI

struct ShopView: View {
    var body: some View {
        ZStack {
            Image("chalkbg")
                .scaleEffect(1.52)
            Text("BLOB SHOP")
                .font(.custom("chalkduster", size: 60))
                .foregroundStyle(.white)
        }
        .ignoresSafeArea()
    }
}

#Preview {
    ShopView()
}
