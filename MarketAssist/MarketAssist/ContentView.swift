//
//  ContentView.swift
//  MarketAssist
//
//  Created by Uzoma Nwanna on 11/26/21.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var api : APIObject
    @State var searchText = ""
    @State var searching = false
    //let searchedTickers : [String] = ["AAPL", "FB"]
    
    var body: some View {
        NavigationView {
                    VStack(alignment: .leading) {
                        SearchBar(searchText: $searchText, searching: $searching).environmentObject(api)
                        List {
                            ForEach(api.searchedTickers.filter({ (ticker: String) -> Bool in
                                return ticker.hasPrefix(searchText) || searchText == ""
                            }), id: \.self) { ticker in
                                Text(ticker)
                            }
                        }
                            .listStyle(GroupedListStyle())
                            .navigationTitle(searching ? "Searching" : "MarketAssist")
                            .toolbar {
                                if searching {
                                    Button("Cancel") {
                                        searchText = ""
                                        withAnimation {
                                           searching = false
                                           UIApplication.shared.dismissKeyboard()
                                        }
                                    }
                                }
                            }
                            .gesture(DragGesture()
                                        .onChanged({ _ in
                                UIApplication.shared.dismissKeyboard()
                                searchText = ""
                                        })
                            )
                    }
                }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct SearchBar: View {
    @EnvironmentObject var api : APIObject
    @Binding var searchText: String
    @Binding var searching: Bool
    
    var body: some View {
        ZStack {
            Rectangle()
                .foregroundColor(Color("LightGray"))
            HStack {
                Image(systemName: "magnifyingglass")
                TextField("Search ..", text: $searchText) { startedEditing in
                    if startedEditing {
                        withAnimation {
                            searching = true
                        }
                    }
                } onCommit: {
                    withAnimation {
                        searching = false
                    }
                    api.getBasicStockInfo(ticker: searchText)
                }
            }
            .foregroundColor(.gray)
            .padding(.leading, 13)
        }
            .frame(height: 40)
            .cornerRadius(13)
            .padding()
    }
}


extension UIApplication {
     func dismissKeyboard() {         sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
     }
 }
