//
//  MarketAssistApp.swift
//  MarketAssist
//
//  Created by Uzoma Nwanna on 11/26/21.
//

import SwiftUI

@main
struct MarketAssistApp: App {
    @StateObject var api = APIObject()
    @StateObject var watchlist = Watchlist()
    
    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(api).environmentObject(watchlist)
        }
    }
}
