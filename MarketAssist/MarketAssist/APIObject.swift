//
//  APIObject.swift
//  MarketAssist
//
//  Created by Uzoma Nwanna on 11/28/21.
//

import Foundation

let url = "https://financialmodelingprep.com/api/v3/profile/"
let apiKey = "85e0b59949f37b05b283ad2bff14179b"

struct DataObject: Codable {
    var symbol : String = ""
    var currency : String = ""
    var exchange : String = ""
    var exchangeShortName: String = ""
    var price : Float = 0.0
    var beta : Float = 0.0
    var volAvg : Int = 0
    var mktCap : Int = 0
    var lastDiv : Float = 0.0
    var range : String = ""
    var changes : Float = 0.0
    var companyName : String = ""
    var cik : String = ""
    var isin : String = ""
    var cusip : String = ""
    var industry : String = ""
    var website : String = ""
    var description : String = ""
    var ceo : String = ""
    var sector : String = ""
    var country : String = ""
    var fullTimeEmployees : String = ""
    var phone : String = ""
    var address : String = ""
    var city : String = ""
    var state : String = ""
    var zip : String = ""
    var dcfDiff : Float = 0.0
    var dcf : Float = 0.0
    var image : String = ""
    var ipoDate : String = ""
    var defaultImage : Bool = false
    var isEtf : Bool = false
    var isActivelyTrading : Bool = false
    var isAdr : Bool = false
    var isFund : Bool = false
}

class APIObject : NSObject, ObservableObject {
    @Published var responseObj: DataObject = DataObject()
    @Published var searchedTickers: [String] = []
    
    override init() {
        super.init()
    }
    
    func getBasicStockInfo(ticker: String) {
        let fetchUrl = "\(url)ticker?apikey=\(apiKey)"
        guard let url = URL(string: fetchUrl) else { return }
        URLSession.shared.dataTask(with: url) { (data, _, _) in
//            let posts = try! JSONDecoder().decode(DataObject.self, from: data!)
//
//
//            print(posts)
//            guard let data = data, error == nil else {
//                print ("Somthing went wrong")
//                return
//            }
//
//            var result: DataObject?
//            do {
//                result = try JSONDecoder().decode(DataObject.self, from: data)
//            } catch {
//                print("failted to convert \(error.localizedDescription)")
//            }
//
//            guard let json = result else {
//                return
//            }
//
//            self.responseObj = json
            print(self.searchedTickers.contains(ticker))
            if (self.searchedTickers.contains(ticker) == false) {
                self.searchedTickers.append(ticker)
                print(self.searchedTickers)
            }
        }
        .resume()
    }
}
