//
//  TrialView.swift
//  Discover
//
//  Created by ChiduAnush on 02/01/25.
//

import SwiftUI

struct TrialView: View {
    // State to hold our products
    @State private var products: [Product] = []
    @State private var isLoading = false
    @State private var errorMessage: String?
    
    var body: some View {
        VStack {
            // Show loading indicator
            if isLoading {
                ProgressView("Loading products...")
            }
            
            // Show error if any
            if let error = errorMessage {
                Text("Error: \(error)")
                    .foregroundColor(.red)
            }
            
            // Show products
            List(products) { product in
                VStack(alignment: .leading) {
                    Text(product.productName)
                        .font(.headline)
                    Text("Price: $\(product.price, specifier: "%.2f")")
                    Text("Tax: $\(product.tax, specifier: "%.2f")")
                }
            }
            
            // Test button for fetching products
            Button("Fetch Products") {
                fetchProducts()
            }
            .padding()
            
//             Test button for adding a product
            Button("Add Test Product") {
                addTestProduct()
            }
            .padding()
        }
    }
    
    // Function to fetch products
    private func fetchProducts() {
        isLoading = true
        errorMessage = nil
        
        APIservice.shared.fetchProducts { result in
            // Switch back to main thread since we're updating UI
            DispatchQueue.main.async {
                isLoading = false
                
                switch result {
                case .success(let fetchedProducts):
                    self.products = fetchedProducts
                    print("Successfully fetched \(fetchedProducts.count) products")
                    
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                    print("Error fetching products: \(error)")
                }
            }
        }
    }
    
    // Function to add a test product
    private func addTestProduct() {
        let testProduct = Product(
            productName: "TestProduct",
            productType: "Test Category",
            price: 99.99,
            tax: 10.00,
            image: nil
        )
        
        print("Name: '\(testProduct.productName)'")
        print("Type: '\(testProduct.productType)'")
        print("Price: \(testProduct.price)")
        print("Tax: \(testProduct.tax)")
        
        APIservice.shared.addProduct(product: testProduct) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let message):
                    print("Prodyct Added!: \(message)")
                    self.errorMessage = nil
                    fetchProducts()
                    
                case .failure(let error):
                    let errorMessage = (error as NSError).userInfo["message"] as? String ?? error.localizedDescription
                    self.errorMessage = "Failed to add product"
                    print("Add product Error: \(errorMessage)")
                }
            }
        }
    }
}

#Preview {
    TrialView()
}


