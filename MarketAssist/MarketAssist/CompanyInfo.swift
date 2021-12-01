//
//  CompanyInfo.swift
//  MarketAssist
//
//  Created by Uzoma Nwanna on 11/30/21.
//

import SwiftUI

struct CompanyInfo: View {
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

struct CompanyInfo_Previews: PreviewProvider {
    @State var x = [DataObject]()
    static var previews: some View {
        CompanyInfo(dataObjects: $x)
    }
}
