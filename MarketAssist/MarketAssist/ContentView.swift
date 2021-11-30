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
    
    var body: some View {
        NavigationView {
                    VStack(alignment: .leading) {
                        SearchBar(searchText: $searchText, searching: $searching).environmentObject(api)
                        
                        CompanyInfo(dataObjects: $api.responseObj)
                        List {
                            ForEach(api.searchedTickers.filter({ (ticker: String) -> Bool in
                                return ticker.hasPrefix(searchText) || searchText == ""
                            }), id: \.self) { ticker in
                                Text(ticker)
                            }
                        }
                            .listStyle(GroupedListStyle())
                            .navigationTitle(searching ? "Searching" : "Market Assist")
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
                .foregroundColor(Color(UIColor.white))
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

struct CompanyInfo : View {
    @Binding var dataObjects: [DataObject]
    
    var body: some View {
        List {
            ForEach(dataObjects, id: \.self) { dataObject in
                ZStack {
                    HStack {
                        Text(dataObject.companyName)
                        AsyncImage(url: URL(string: dataObject.image))
                    }
                    HStack {
                        Text(dataObject.symbol)
                        Text("\(dataObject.price)")
                    }
                    HStack {
                        Text(dataObject.industry)
                        Text(dataObject.website)
                    }
                }
                    .frame(height: 40)
                    .cornerRadius(13)
                    .padding()
            }
        }
        .listStyle(GroupedListStyle())
    }
}

extension UIApplication {
     func dismissKeyboard() {         sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
     }
 }
