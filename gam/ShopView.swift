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
    @State var selectedButton: Int = -1
    var boxSize: CGFloat = 100
    var spacing: CGFloat = 10
    let numButtons = 30
    
    let colorKey = [Color.red, Color.orange, Color.yellow, Color.green, Color.cyan, Color.purple, Color(red: 1, green: 0.7, blue: 0.8)]
    
    let defaults = UserDefaults.standard
    @State var subtext: String = " "
    @State var money = 0;
    
    
    @State var ShopTabs = ["Colors", "Hats", "Decor"]
    // tried to make all the awways one big array but after several type-checking errors caved on making a bunch of 2d arrays instead of a big 3d one
    
    
    @State var itemNames: [[String]] = [
        ["Red", "Orange", "Yellow", "Green", "Cyan", "Purple", "Pink"],
        ["Party Hat", "Top Hat"],
        ["Rope Swing", "Chair"],
    ]
    
    @State var itemCosts: [[Int]] = [
        [100, 200, 300, 400, 500, 600, 700],
        [500, 1000],
        [2000, 3000],
    ]
    
    @State var isPurchased: [[Bool]] = [
        Array(repeating: false, count: 7),
        Array(repeating: false, count: 2),
        Array(repeating: false, count: 2)
    ]
    
    @State var isEquipped: [[Bool]] = [
        Array(repeating: false, count: 7),
        Array(repeating: false, count: 2),
        Array(repeating: false, count: 2)
    ]
    
    var body: some View {
        ZStack {
            Image("chalkbg")
//                .rotationEffect(Angle(degrees: 90))
                .scaleEffect(1.55)
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
                            subtext = " "
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
                ScrollView {
                    ZStack {
                        ForEach(0..<30) {i in
                            Button {
                                if (selectedButton == i && i < itemNames[tab].count) {
                                    if (!isPurchased[tab][i]) {
                                        if itemCosts[tab][i] <= money {
                                            isPurchased[tab][i] = true
                                            money -= itemCosts[tab][i]
                                            defaults.set(money, forKey: "Money")
                                            subtext = "Purchased \(itemNames[tab][i])!"
                                            defaults.set(isPurchased, forKey: "IsPurchased")
                                        }
                                        else {
                                            subtext = "Insufficient funds!"
                                        }
                                    }
                                    else if (!isEquipped[tab][i]) {
                                        // only one color can be equipped at once
                                        if (tab == 0) {
                                            isEquipped[0] = Array(repeating: false, count: isEquipped[0].count)
                                        }
                                        isEquipped[tab][i] = true
                                        subtext = "\(itemNames[tab][i]) - tap to unequip"
                                        defaults.set(isEquipped, forKey: "IsEquipped")
                                    }
                                    else {
                                        isEquipped[tab][i] = false
                                        subtext = "\(itemNames[tab][i]) - tap to equip"
                                        defaults.set(isEquipped, forKey: "IsEquipped")
                                    }
                                }
                                else if i < itemNames[tab].count {
                                    if (!isPurchased[tab][i]) {
                                        subtext = "$\(itemCosts[tab][i]) - tap again to buy"
                                    }
                                    else if (!isEquipped[tab][i]) {
                                        subtext = "\(itemNames[tab][i]) - tap to equip"
                                    }
                                    else {
                                        subtext = "\(itemNames[tab][i]) - tap to unequip"
                                    }
                                    
                                }
                                else {
                                    subtext = " "
                                }
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
                                        if (i < itemNames[tab].count) {
                                            Text(itemNames[tab][i])
                                                .font(.custom("Chalkduster", size: 20))
                                                .foregroundStyle(.white)
                                                .offset(y: -30)
                                            Circle()
                                                .fill(tab == 0 ? colorKey[i] : Color.gray)
                                                .opacity(0.5)
                                                .overlay(
                                                    Circle().stroke(.white, lineWidth: 3)
                                                )
                                                .frame(width: 20, height: 20)
                                                .offset(y: 5)
                                            Text(isPurchased[tab][i] ? (isEquipped[tab][i] ? "Equipped" : "Owned") : "$\(itemCosts[tab][i])")
                                                .offset(y: 35)
                                                .font(.custom("Chalkduster", size: 17))
                                                .foregroundStyle(.white)
                                        }
                                        else {
                                            Text("Coming Soon")
                                                .font(.custom("Chalkduster", size: 20))
                                                .foregroundStyle(.white)
                                        }
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
                .frame(width: 400, height: UIScreen.main.bounds.height - 300)
                Rectangle()
                    .stroke(.white, lineWidth: 3)
                    .frame(width: 350, height: 5)
                Text(subtext)
                    .font(.custom("Chalkduster", size:24))
                    .foregroundStyle(.white)
                    .padding(-2)
                
            }
        }
        .ignoresSafeArea()
        .onAppear {
//             un-comment out the bottom line to reset shop options
//            defaults.set(1000, forKey: "Money")
//            defaults.set(isPurchased, forKey: "IsPurchased")
//            defaults.set(isEquipped, forKey: "IsEquipped")
            
            money = (defaults.object(forKey: "Money") as? Int ?? 0)
            isPurchased = (defaults.object(forKey: "IsPurchased") as? [[Bool]] ?? isPurchased)
            isEquipped = (defaults.object(forKey: "IsEquipped") as? [[Bool]] ?? isPurchased)
        }
    }
    
}

#Preview {
    ShopView()
}
