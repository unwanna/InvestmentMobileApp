//
//  model.swift
//  MarketAssist
//
//  Created by Uzoma Nwanna on 12/1/21.
//

import Foundation
import SwiftUI

struct Stock : Identifiable {
    let id: UUID = UUID()
    var ticker : String
    
    init(ticker: String) {
        self.ticker = ticker
    }
}

class Watchlist : ObservableObject {
    
    @EnvironmentObject var api : APIObject
    @Published var list : [Stock]
    
    init() {
        list = []
    }
    
    // take API data and make a struct then add that struct to the array
    func addToList(ticker: String) {
        if (!isInWatchlist(ticker: ticker)) {
            list.append(Stock(ticker: ticker))
        }
    }
    
    func removeFromList(ticker: String) {
        if (isInWatchlist(ticker: ticker)) {
            var index = 0
            
            for stock in list {
                if (stock.ticker == ticker) {
                    break
                } else {
                    index += 1
                }
            }
            
            list.remove(at: index)
        }
    }
    
    func isInWatchlist(ticker: String) -> Bool {
        for stock in list {
            if (stock.ticker == ticker) {
                return true
            }
        }
        
        return false
    }
    
}
