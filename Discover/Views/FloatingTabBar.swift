//
//  FloatingTabBar.swift
//  Discover
//
//  Created by ChiduAnush on 02/01/25.
//


import SwiftUI

struct FloatingTabBar: View {
    @Binding var showSearchBar: Bool
    var onAddTapped: () -> Void
    
    var body: some View {
        HStack(spacing: 50) {
            Button(action: {
                withAnimation {
                    showSearchBar.toggle()
                }
            }) {
                Image(systemName: "magnifyingglass")
                    .font(.title2)
                    .foregroundColor(.white)
            }
            
            Button(action: onAddTapped) {
                Image(systemName: "plus")
                    .font(.title2)
                    .foregroundColor(.white)
            }
        }
        .padding()
        .background(Color.blue)
        .cornerRadius(25)
        .shadow(radius: 5)
    }
}

#Preview {
    FloatingTabBar(showSearchBar: .constant(false), onAddTapped: {})
}

