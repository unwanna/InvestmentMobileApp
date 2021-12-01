//
//  ContentView.swift
//  MarketAssist
//
//  Created by Uzoma Nwanna on 11/26/21.
//

import SwiftUI

struct ContentView: View {
    @State var menuOpen: Bool = false
    @EnvironmentObject var api : APIObject
    @EnvironmentObject var watchlist : Watchlist
    @State var searchText = ""
    @State var searching = false

    var body: some View {
        NavigationView {
            ZStack {
                if !self.menuOpen {
                    // search and detail screen
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
                    
                    // nav button in corner
                        .navigationBarItems(leading: (
                          Button(action: { // the button to open/close the menu
                            withAnimation {
                              self.menuOpen.toggle()
                             }
                           }) {
                             Image(systemName: "line.horizontal.3")
                               .imageScale(.large)
                           }
                         ))
                }
                
                SideMenu(width: 270,
                         isOpen: self.menuOpen,
                         menuClose: self.openMenu)
            }
        }
    }

    func openMenu() {
        self.menuOpen.toggle()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct SideMenu: View {
    let width: CGFloat
    let isOpen: Bool
    let menuClose: () -> Void
    
    var body: some View {
        ZStack {
            GeometryReader { _ in
                EmptyView()
            }
            .background(Color.gray.opacity(0.3))
            .opacity(self.isOpen ? 1.0 : 0.0)
            .animation(Animation.easeIn.delay(0.25))
            .onTapGesture {
                self.menuClose()
            }
            
            HStack {
                MenuContent()
                    .frame(width: self.width)
                    .background(Color.white)
                    .offset(x: self.isOpen ? 0 : -self.width)
                    .animation(.default)
                
                Spacer()
            }
        }
    }
}

struct MenuContent: View {
    @EnvironmentObject var watchlist : Watchlist
    @EnvironmentObject var api : APIObject
    
    var body: some View {
        List {
            Section(header: Text("Watchlist").font(.title).bold()) {
                ForEach(watchlist.list, id: \.id) { stock in
                    Button {
                        api.getBasicStockInfo(ticker: stock.ticker)
                    } label: {
                        Text(String(stock.ticker))
                    }
                }
            }.headerProminence(.increased)
        }
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
