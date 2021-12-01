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

    func openMenu() {
        self.menuOpen.toggle()
    }

    var body: some View {
        NavigationView {
            ZStack {
                if !self.menuOpen {
                    // search and detail screen
                    VStack(alignment: .leading) {
                        SearchBar(searchText: $searchText, searching: $searching).environmentObject(api)
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
                        CompanyInfo(dataObjects: $api.responseObj)
                        Spacer()
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
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
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
            }
                .headerProminence(.increased)
        }
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
    @State private var isAnimating = false
    @Binding var dataObjects: [DataObject]
    @State var isExpanded : Bool = false
    
    var body: some View {
        ForEach($dataObjects, id: \.self) { $dataObject in
            CardView(isExpanded: $isExpanded, dataObject: $dataObject)
                .scaleEffect(isAnimating ? 0.5 : 1)
                .opacity(isAnimating ? 0 : 1)
                .gesture(
                    TapGesture()
                        .onEnded{_ in
                             withAnimation(Animation.easeOut(duration: 0.5)) {
                                 self.isAnimating = true
                             }

                             DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                 self.isAnimating = false
                                 self.isExpanded = !isExpanded
                             }}
                )
        }
    }
}

extension UIApplication {
     func dismissKeyboard() {         sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
     }
 }
