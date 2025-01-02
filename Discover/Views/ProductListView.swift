

//
//  ProductListView.swift
//  Discover
//
//  Created by ChiduAnush on 02/01/25.
//

import SwiftUI

struct ProductListView: View {
    @State private var products: [Product] = []
    @State private var favorites: Set<String> = loadFavorites()
    @State private var searchQuery: String = ""
    @State private var isLoading = false
    @State private var errorMessage: String?
    @State private var showSearchBar = false
    @State private var navigateToAddProduct = false
    
    var filteredProducts: [Product] {
        let sortedProducts = products.sorted {
            (favorites.contains($0.productName) ? 0 : 1) < (favorites.contains($1.productName) ? 0 : 1)
        }
        if searchQuery.isEmpty {
            return sortedProducts
        } else {
            return sortedProducts.filter {
                $0.productName.localizedCaseInsensitiveContains(searchQuery)
            }
        }
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    if showSearchBar {
                        HStack {
                            TextField("Search Products", text: $searchQuery)
                                .padding(8)
                                .background(Color(.systemGray6))
                                .cornerRadius(8)
                                .padding(.horizontal)
                            
                            Button(action: {
                                searchQuery = ""
                                showSearchBar = false
                            }) {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(.gray)
                                    .padding(.trailing)
                            }
                        }
                        .transition(.move(edge: .top))
                        .animation(.spring(), value: showSearchBar)
                    }
                    
                    List(filteredProducts) { product in
                        HStack {
                            AsyncImage(url: URL(string: product.image ?? "")) { image in
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 50, height: 50)
                            } placeholder: {
                                Image(systemName: "photo")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 50, height: 50)
                                    .foregroundColor(.gray)
                            }
                            
                            VStack(alignment: .leading) {
                                Text(product.productName)
                                    .font(.headline)
                                Text("Type: \(product.productType)")
                                    .font(.subheadline)
                                Text("Price: $\(product.price, specifier: "%.2f")")
                                Text("Tax: $\(product.tax, specifier: "%.2f")")
                            }
                            
                            Spacer()
                            
                            Button(action: {
                                toggleFavorite(product)
                            }) {
                                Image(systemName: favorites.contains(product.productName) ? "heart.fill" : "heart")
                                    .foregroundColor(favorites.contains(product.productName) ? .red : .gray)
                            }
                        }
                    }
                    .listStyle(PlainListStyle())
                    
                    if products.isEmpty && !isLoading {
                        Text("No products found.")
                            .foregroundColor(.gray)
                            .padding()
                    }
                }
                
                VStack {
                    Spacer()
                    
                    FloatingTabBar(showSearchBar: $showSearchBar, onAddTapped: {
                        // Navigate to AddProductView
                        navigateToAddProduct = true
                    })
                        .padding(.bottom, 20)
                        .frame(maxWidth: .infinity, alignment: .center)
                }
            }
            .navigationTitle("Product List")
            .onAppear(perform: fetchProducts)
            .background(
                NavigationLink(
                    destination: AddProductView(),
                    isActive: $navigateToAddProduct,
                    label: { EmptyView() }
                )
            )
        }
    }
    
    private func fetchProducts() {
        isLoading = true
        errorMessage = nil
        
        APIservice.shared.fetchProducts { result in
            DispatchQueue.main.async {
                isLoading = false
                switch result {
                case .success(let fetchedProducts):
                    self.products = fetchedProducts
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }
    
    private func toggleFavorite(_ product: Product) {
        if favorites.contains(product.productName) {
            favorites.remove(product.productName)
        } else {
            favorites.insert(product.productName)
        }
        saveFavorites(favorites)
    }
    
    private static func loadFavorites() -> Set<String> {
        let savedFavorites = UserDefaults.standard.stringArray(forKey: "favoriteProducts") ?? []
        return Set(savedFavorites)
    }
    
    private func saveFavorites(_ favorites: Set<String>) {
        UserDefaults.standard.set(Array(favorites), forKey: "favoriteProducts")
    }
}

#Preview {
    ProductListView()
}
