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
        HStack(spacing: 30) {
            Button(action: {
                withAnimation {
                    showSearchBar.toggle()
                }
            }) {
                Image(systemName: "magnifyingglass")
                    .font(.system(size: 26))
                    .foregroundColor(.primary)
            }
            
            Button(action: onAddTapped) {
                Image(systemName: "plus.circle.fill")
                    .font(.system(size: 30))
                    .foregroundColor(.primary)
            }
        }
        .padding()
//        .background(Color(.systemBackground))
        .background(Color(UIColor { traitCollection in
           return traitCollection.userInterfaceStyle == .dark ? .secondarySystemBackground : .white
        }))
        .cornerRadius(50)
        .shadow(color: .black.opacity(0.1), radius: 25, y: 15)
    }
}

#Preview {
    FloatingTabBar(showSearchBar: .constant(false), onAddTapped: {})
}

