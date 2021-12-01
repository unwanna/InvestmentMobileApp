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
