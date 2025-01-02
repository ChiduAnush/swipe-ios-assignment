//
//  AddProductViewModel.swift
//  Discover
//
//  Created by ChiduAnush on 03/01/25.
//

import Foundation
import SwiftUI
import Combine

class AddProductViewModel: ObservableObject {
    
    @Published var productName: String = ""
    @Published var productType: String = "Electronics"
    @Published var price: String = ""
    @Published var tax: String = ""
    @Published var selectedImage: UIImage? = nil
    
    @Published var showAlert: Bool = false
    @Published var alertMessage: String = ""
    
    let productTypes = ["Electronics", "Clothing", "Shoes", "Service", "Books", "Home Appliances", "Other"]
    
    
    func validateAndSubmit(completion: @escaping (Bool) -> Void) {
        guard !productName.isEmpty else {
            alertMessage = "Please enter a product name."
            showAlert = true
            completion(false)
            return
        }
        
        guard let priceValue = Double(price), priceValue > 0 else {
            alertMessage = "Please enter a valid price."
            showAlert = true
            completion(false)
            return
        }
        
        guard let taxValue = Double(tax), taxValue >= 0 else {
            alertMessage = "Please enter a valid tax rate."
            showAlert = true
            completion(false)
            return
        }
        
        // Create a product object (without image for now)
        let product = Product(productName: productName, productType: productType, price: priceValue, tax: taxValue, image: nil)
        
        // Call API
        APIservice.shared.addProduct(product: product) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let message):
                    self.alertMessage = message
                    self.showAlert = true
                    self.resetFields()
                    completion(true)
                case .failure(let error):
                    self.alertMessage = "Failed to add product: \(error.localizedDescription)"
                    self.showAlert = true
                    completion(false)
                }
            }
        }
    }
    
    
    func resetFields() {
        productName = ""
        productType = "Electronics"
        price = ""
        tax = ""
        selectedImage = nil
    }
}
