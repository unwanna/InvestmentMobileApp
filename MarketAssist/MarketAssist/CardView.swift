//
//  CardView.swift
//  MarketAssist
//
//  Created by Uzoma Nwanna on 12/1/21.
//

import SwiftUI

struct CardView: View {
    @Binding var isExpanded : Bool
    @Binding var dataObject : DataObject
    
    var body: some View {
        ZStack {
            AsyncImage(url: URL(string: dataObject.image)) { image in
               image
                   .resizable()
                   .scaledToFill()
                   .overlay(Material.ultraThin)
               } placeholder: {
                   ProgressView()
               }
            .aspectRatio(contentMode: .fit)
            HStack {
                VStack(alignment: .leading) {
                    if (isExpanded) {
                        Text(dataObject.companyName)
                            .font(.title)
                            .fontWeight(.black)
                            .foregroundColor(.primary)
                            .lineLimit(3)
                            .padding(.bottom, 13)
                        Text(dataObject.description)
                            .font(.body)
                            .fontWeight(.black)
                            .foregroundColor(.primary)
                            .lineLimit(8)
                    } else {
                        Text(dataObject.companyName)
                            .font(.title)
                            .fontWeight(.black)
                            .foregroundColor(.primary)
                            .lineLimit(3)
                        Link("Visit \(dataObject.companyName)".uppercased(), destination: URL(string: dataObject.website)!)
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .padding(.bottom, 13) 
                        Text("Ticker: \(dataObject.symbol)")
                            .font(.body)
                            .fontWeight(.black)
                            .foregroundColor(.primary)
                        Text("Price: $\(dataObject.price)")
                            .font(.body)
                            .fontWeight(.black)
                            .foregroundColor(.primary)
                            .lineLimit(3)
                        Text("CEO: \(dataObject.ceo)")
                            .font(.body)
                            .fontWeight(.black)
                            .foregroundColor(.primary)
                            .lineLimit(3)
                    }
                }
                .layoutPriority(100)
            }
            .padding()
        }
        .cornerRadius(10)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color(.sRGB, red: 150/255, green: 150/255, blue: 150/255, opacity: 0.1), lineWidth: 1)
        )
        .padding([.top, .horizontal])
    }
}
