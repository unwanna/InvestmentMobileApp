//
//  InitialInfoView.swift
//  MarketAssist
//
//  Created by Uzoma Nwanna on 12/5/21.
//

import SwiftUI

struct InitialInfoView: View {
    @EnvironmentObject var api : APIObject
    @State private var selectedTab = 0
    @Binding var dailyGainers: [StockObj]
    @Binding var dailyLosers: [StockObj]
    
    @Binding var searchText : String
    
    var body: some View {
        TabView(selection: $selectedTab) {
            VStack(alignment: .center) {
                List {
                    Section(header: Text("Daily Gainers").font(.title).bold()) {
                        ForEach(dailyGainers, id: \.id) { stock in
                            Button {
                                api.getBasicStockInfo(ticker: stock.ticker)
                                searchText = ""
                            } label: {
                                Text("\(stock.ticker): \(stock.changesPercentage) Gain")
                                Text("Current Price: \(stock.price)")
                            }
                        }
                    }
                    .headerProminence(.increased)
                }
            }
            .tabItem {
                Text("Daily Gainers")
            }.tag(0)
            
            VStack(alignment: .center) {
                List {
                    Section(header: Text("Daily Losers").font(.title).bold()) {
                        ForEach(dailyLosers, id: \.id) { stock in
                            Button {
                                api.getBasicStockInfo(ticker: stock.ticker)
                                searchText = ""
                            } label: {
                                Text("\(stock.ticker): \(stock.changesPercentage) Loss")
                                Text("Current Price: \(stock.price)")
                            }
                        }
                    }
                    .headerProminence(.increased)
                }
            }
            .tabItem {
                Text("Daily Losers")
            }.tag(1)
        }
        .cornerRadius(10)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color(.sRGB, red: 150/255, green: 150/255, blue: 150/255, opacity: 0.1), lineWidth: 1)
        )
        .padding([.top, .horizontal])
    }
}
