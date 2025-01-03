//
//  ProductListingView.swift
//  Discover
//
//  Created by ChiduAnush on 02/01/25.
//




//------------------------- - - --


import SwiftUI

struct ProductListView: View {
    
    @StateObject private var viewModel = ProductListViewModel()
    @State private var showSearchBar = false
    @State private var navigateToAddProduct = false
    
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    // Header
                    HStack {
                        Text("Discover")
                            .font(.system(size: 32))
                            .padding(.top, 30)
                        Spacer()
                    }
                    .padding(.horizontal)
                    
                    // Tip Card
                    VStack(alignment: .leading, spacing: 10) {
                        Image(systemName: "lightbulb.circle")
                            .resizable()
                            .frame(width: 20, height: 20)
                            .foregroundStyle(.primary).opacity(0.8)
                        Text("Use the “Search” and “Plus” icon at the bottom, to search the list and add a product, respectively.")
                            .font(.system(size: 12))
                            .opacity(0.9)
                    }
                    .padding()
                    .background(Color(.secondarySystemBackground).opacity(0.8))
                    .cornerRadius(8)
                    .padding(.horizontal, 15)
                    
                    // Search Bar
                    if showSearchBar {
                        HStack {
                            TextField("Search Products", text: $viewModel.searchQuery)
                                .padding(12)
                                .background(Color(.secondarySystemBackground))
                                .cornerRadius(8)
                                .padding(.leading)
                            
                            Button(action: {
                                viewModel.searchQuery = ""
                                showSearchBar = false
                            }) {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(.secondary)
                                    .padding(.trailing)
                            }
                        }
                        .padding(.top, 5)
                        .transition(.move(edge: .top))
                        .animation(.spring(), value: showSearchBar)
                    }
                    
                    // Product List
                    ScrollView {
                        LazyVStack(spacing: 20) {
                            ForEach(viewModel.filteredProducts) { product in
                                ProductCard(product: product, isFavorite: viewModel.favorites.contains(product.productName)) {
                                    viewModel.toggleFavorite(product)
                                }
                            }
                        }
                        .padding()
                    }
                    
                    // Empty State
                    if viewModel.products.isEmpty && !viewModel.isLoading {
                        Text("No products found.")
                            .foregroundColor(.gray)
                            .padding()
                    }
                }
                
                // Floating Tab Bar
                VStack {
                    Spacer()
                    FloatingTabBar(showSearchBar: $showSearchBar, onAddTapped: {
                        navigateToAddProduct = true
                    })
                    .padding(.bottom, 40)
                    .frame(maxWidth: .infinity, alignment: .center)
                }
            }
            .navigationTitle("")
            .background(
                NavigationLink(
                    destination: AddProductView(parentViewModel: self.viewModel),
                    isActive: $navigateToAddProduct,
                    label: { EmptyView() }
                )
            )
        }
    }
}

struct ProductCard: View {
    let product: Product
    let isFavorite: Bool
    let onFavoriteTapped: () -> Void
    
    
    var body: some View {
        VStack(spacing: 20){
            ZStack(alignment: .bottomTrailing){
                HStack {
                    VStack(alignment: .leading, spacing: 17) {
                        
                        HStack(alignment: .bottom, spacing: 5){
                            Text("\(product.price, specifier: "%.1f")")
                                .font(.custom(Fonts.SpaceMonoRegular, size: 28))
                                .tracking(-0.5)
                                .fontWeight(.regular)
                                .foregroundColor(.primary)
                            Text("₹")
                                .font(.system(size: 18))
                                .padding(.bottom, 5)
                        }
                        .padding(.top, -5)
                        
                        
                        
                        VStack(alignment: .leading, spacing: 5){
                            Text(product.productName)
                                .font(.system(size: 19))
                                .foregroundColor(.primary)
                            
                            HStack(spacing: 20) {
                                
                                HStack(spacing: 5){
                                    Image(systemName: "number")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 13, height: 13)
                                        .foregroundColor(.secondary).opacity(0.7)
                                        .bold()
                                    Text(product.productType)
                                        .font(.system(size: 12))
                                        .foregroundColor(.secondary)
                                }
                                
                                HStack(spacing: 0){
                                    Image(systemName: "doc.text.image")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 15, height: 15)
                                        .foregroundColor(.secondary).opacity(0.7)
                                    Text(" Tax: \(product.tax, specifier: "%.2f")")
                                        .font(.system(size: 12))
                                        .foregroundColor(.secondary)
                                }
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    Spacer()
        //            RoundedRectangle(cornerRadius: 0)
        //                .fill(Color.gray.opacity(0.1))
        //                .frame(width: 125, height: 125)
        ////                .onTapGesture(perform: {
        ////                    bleh()
        ////                })
                    AsyncImage(url: URL(string: product.image ?? "")) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 115, height: 115)
                            .cornerRadius(0)
                            .background(Color(.systemGray5)) // Grey background placeholder
                    } placeholder: {
                        Color(.systemGray6) // Grey background placeholder
                            .frame(width: 115, height: 115)
                            .cornerRadius(0)
                            .overlay(
                                Image(systemName: "photo")
                                    .foregroundColor(.secondary).opacity(0.3)
                            )
                    }
                }
                .padding(10)
        //        .background(
        //            RoundedRectangle(cornerRadius: 16)
        //                .stroke(Color.gray.opacity(0.5), lineWidth: 1)
        //                .background(
        //                    RoundedRectangle(cornerRadius: 16)
        //                        .fill(Color.white)
        //                )
        //        )
                .padding(.horizontal, 10)
                
                Button(action: onFavoriteTapped) {
                    Image(systemName: isFavorite ? "heart.fill" : "heart")
                        .foregroundColor(isFavorite ? .red : .gray)
                        .font(.system(size: 17))
                        .padding(8)
                        .padding(.top, 1)
                        .background(Color.white.opacity(0.8))
                        .clipShape(Circle())
                        .shadow(color: .black.opacity(0.15), radius: 10)
                }
                .padding([.bottom, .trailing], 10)
            }
            
            Divider()
                .padding(.horizontal, 10)
                .opacity(0.5)
        }
    }
}


struct BProductCard: View {
    let product: Product
    let isFavorite: Bool
    let onFavoriteTapped: () -> Void
    
    var body: some View {
        HStack(alignment: .center, spacing: 16) {
            // Product Details (Left Side)
            VStack(alignment: .leading, spacing: 8) {
                Text(product.productName)
                    .font(.headline)
                    .foregroundColor(.primary)
                
                Text("₹\(product.price, specifier: "%.2f")")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            // Image (Right Side)
            AsyncImage(url: URL(string: product.image ?? "")) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 80, height: 80)
                    .cornerRadius(8)
                    .background(Color(.systemGray5))
            } placeholder: {
                Color(.systemGray5)
                    .frame(width: 80, height: 80)
                    .cornerRadius(8)
                    .overlay(
                        Image(systemName: "photo")
                            .foregroundColor(.gray)
                    )
            }
            
            // Heart Icon for Favorites
            Button(action: onFavoriteTapped) {
                Image(systemName: isFavorite ? "heart.fill" : "heart")
                    .foregroundColor(isFavorite ? .red : .gray)
                    .font(.system(size: 20))
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(radius: 2)
    }
}




#Preview {
    ProductListView()
}
