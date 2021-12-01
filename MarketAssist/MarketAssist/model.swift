//
//  model.swift
//  MarketAssist
//
//  Created by Uzoma Nwanna on 12/1/21.
//

import Foundation
import SwiftUI

class Watchlist : ObservableObject {
    
    @EnvironmentObject var api : APIObject
    @Published var list : [Stock]
    
    struct Stock : Identifiable {
        let id: UUID = UUID()
        var ticker : String
    }
    
    init() {
        list = [Stock(ticker: "AAPL"), Stock(ticker: "TSLA")]
    }
    
    // take API data and make a struct then add that struct to the array
    func addToList() {
    }
    
}
