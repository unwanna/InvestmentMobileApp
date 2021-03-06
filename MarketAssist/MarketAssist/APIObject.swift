//
//  APIObject.swift
//  MarketAssist
//
//  Created by Uzoma Nwanna on 11/28/21.
//

import Foundation

let url = "https://financialmodelingprep.com/api/v3/profile/"
let apiKey = "85e0b59949f37b05b283ad2bff14179b"

struct DataObject: Codable, Hashable {
    var symbol : String
    var currency : String
    var exchange : String
    var exchangeShortName: String
    var price : Float
    var beta : Float
    var volAvg : Int
    var mktCap : Int
    var lastDiv : Float
    var range : String
    var changes : Float
    var companyName : String
    var cik : String
    var isin : String
    var cusip : String
    var industry : String
    var website : String
    var description : String
    var ceo : String
    var sector : String
    var country : String
    var fullTimeEmployees : String
    var phone : String
    var address : String
    var city : String
    var state : String
    var zip : String
    var dcfDiff : Float
    var dcf : Float
    var image : String
    var ipoDate : String
    var defaultImage : Bool
    var isEtf : Bool
    var isActivelyTrading : Bool
    var isAdr : Bool
    var isFund : Bool
}

struct StockObj: Codable, Hashable {
    var id : UUID = UUID()
    var ticker : String
    var changes: Float
    var price: String
    var changesPercentage: String
    var companyName: String
    
    init(ticker: String, changes: Float, price: String, changesPercentage: String, companyName: String) {
        self.ticker = ticker
        self.changes = changes
        self.price = price
        self.changesPercentage = changesPercentage
        self.companyName = companyName
    }
}

class APIObject : NSObject, ObservableObject {
    @Published var responseObj = [DataObject]()
    @Published var dailyGainers = [StockObj]()
    @Published var dailyLosers = [StockObj]()
    
    override init() {
        super.init()
        self.getDailyGainers()
        self.getDailyLosers()
    }
    
    func getBasicStockInfo(ticker: String) {
        let fetchUrl = "\(url)\(ticker)?apikey=\(apiKey)"
        guard let url = URL(string: fetchUrl) else { return }
        print(fetchUrl)
        URLSession.shared.dataTask(with: url) { (data, _, _) in
            do {
                let data = try JSONDecoder().decode([DataObject].self, from: data!)
                DispatchQueue.main.async {
                    self.responseObj = data
                }
            } catch {
                DispatchQueue.main.async {
                    self.responseObj = []
                }
            }
        }
        .resume()
    }
    
    func getDailyGainers() {
        let fetchUrl = "\(url)gainers?apikey=\(apiKey)"
        guard let url = URL(string: fetchUrl) else { return }
        print(fetchUrl)
        URLSession.shared.dataTask(with: url) { (data, _, _) in
            do {
                let data = try JSONDecoder().decode([StockObj].self, from: data!)
                DispatchQueue.main.async {
                    self.dailyGainers = data
                }
            } catch {
                DispatchQueue.main.async {
                    self.dailyGainers = []
                }
            }
        }
        .resume()
    }
    
    func getDailyLosers() {
        let fetchUrl = "\(url)losers?apikey=\(apiKey)"
        guard let url = URL(string: fetchUrl) else { return }
        print(fetchUrl)
        URLSession.shared.dataTask(with: url) { (data, _, _) in
            do {
                let data = try JSONDecoder().decode([StockObj].self, from: data!)
                DispatchQueue.main.async {
                    self.dailyGainers = data
                }
            } catch {
                DispatchQueue.main.async {
                    self.dailyGainers = []
                }
            }
        }
        .resume()
    }
}
