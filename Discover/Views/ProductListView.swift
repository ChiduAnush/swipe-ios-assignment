//
//  ProductListView.swift
//  Discover
//
//  Created by ChiduAnush on 02/01/25.
//

import SwiftUI

struct ProductListView: View {
    var body: some View {
        
//        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
        
        NavigationStack {
            VStack{
                Text("productss")
            }
            .navigationTitle("Products")
        }

        
        
    }
}


struct ProductRow: View {
//    let product: Product
//    let isFavorite: Bool
    
    var body: some View {
        HStack {
            // Product image
            AsyncImage(url: URL( string: "https://www.google.com/url?sa=i&url=https%3A%2F%2Fwww.ampimex.in%2Fproduct%2Fapple%2F&psig=AOvVaw2xEDTcO6WMY22CIEWWrOTD&ust=1735903585352000&source=images&cd=vfe&opi=89978449&ved=0CBQQjRxqFwoTCNjdxvv21ooDFQAAAAAdAAAAABAE")) { image in
                image.resizable().scaledToFit()
            } placeholder: {
                Image(systemName: "photo")
            }
            .frame(width: 50, height: 50)
            
            // Product details
            VStack(alignment: .leading) {
                Text("Product Name")
                    .font(.headline)
                Text("Texr")
                Text("Tax: \("tax")%")
            }
            
            Spacer()
            
            // Favorite icon
            Image(systemName: true ? "heart.fill" : "heart")
        }
        .padding(.vertical, 4)
    }
}



#Preview {
//    ProductListView()
    ProductRow()
}
