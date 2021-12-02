//
//  ActionSheetView.swift
//  MarketAssist
//
//  Created by Uzoma Nwanna on 12/1/21.
//

import SwiftUI

struct ActionSheetView: View {
    @State private var showingActionSheet = false
    var body: some View {
        Button(action: {
            self.showingActionSheet = true
        }) {
            Text("Show ActionSheet")
                .font(.title)
                .foregroundColor(Color.white)
        }
        .actionSheet(isPresented: $showingActionSheet) {
            ActionSheet(title: Text("SwiftUI ActionSheet"), message: Text("How was that"), buttons: [.default(Text("Awesome")), .cancel()])
        }
    }
}

