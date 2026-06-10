//
//  MoneyView.swift
//  gam
//
//  Created by 3 Kings on 6/10/26.
//

import SwiftUI

struct MoneyView: View {
    @Environment(\.dismiss) var dismiss

    var body: some View {
        VStack {
            Button("Back") {
                dismiss()
            }

            Text("Money")
                .font(.largeTitle)

            Text("This is where information about your cash goes.")
        }
    }
}

#Preview {
    MoneyView()
}
