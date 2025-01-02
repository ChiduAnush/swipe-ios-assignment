//
//  ProductListViewModel.swift
//  Discover
//
//  Created by ChiduAnush on 03/01/25.
//

import Foundation
import SwiftUI
import Combine

class ProductListViewModel: ObservableObject {
    
    @Published var products: [Product] = []
    @Published var favorites: Set<String> = []
    @Published var searchQuery: String = ""
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    init() {
        loadFavorites()
        fetchProducts()
    }
    
    
    var filteredProducts: [Product] {
        let filtered = searchQuery.isEmpty ? products : products.filter {
            $0.productName.localizedCaseInsensitiveContains(searchQuery)
        }
        
        // Sort favorites to the top
        return filtered.sorted { favorites.contains($0.productName) && !favorites.contains($1.productName) }
    }
    
    func fetchProducts() {
        isLoading = true
        errorMessage = nil
        
        APIservice.shared.fetchProducts { result in
            DispatchQueue.main.async {
                self.isLoading = false
                switch result {
                case .success(let fetchedProducts):
                    self.products = fetchedProducts
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }
  
    
    func toggleFavorite(_ product: Product) {
        if favorites.contains(product.productName) {
            favorites.remove(product.productName)
        } else {
            favorites.insert(product.productName)
        }
        saveFavorites()
    }
    
    private func loadFavorites() {
        let savedFavorites = UserDefaults.standard.stringArray(forKey: "favoriteProducts") ?? []
        favorites = Set(savedFavorites)
    }
    
    private func saveFavorites() {
        UserDefaults.standard.set(Array(favorites), forKey: "favoriteProducts")
    }
}
