//
//  APIfile.swift
//  Discover
//
//  Created by ChiduAnush on 02/01/25.
//

import Foundation

class APIservice {
    static let shared = APIservice() // Singleton instance
    
    private init() {
        print("API service started")
    }
    
    // Fetch products from the API
    func fetchProducts(completion: @escaping (Result<[Product], Error>) -> Void) {
        guard let url = URL(string: "https://app.getswipe.in/api/public/get") else {
            print("Invalid URL")
            return
        }
        
        print("Fetching products from: \(url.absoluteString)")
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Network error: \(error.localizedDescription)")
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                print("No data received")
                completion(.failure(NSError(domain: "NoDataError", code: -1)))
                return
            }
            
            // Print raw JSON for debugging
            if let jsonString = String(data: data, encoding: .utf8) {
                print("JSON Received: \(jsonString)")
            }
            
            do {
                let products = try JSONDecoder().decode([Product].self, from: data)
                print("Successfully decoded \(products.count) products")
                completion(.success(products))
            } catch {
                print("Decoding error: \(error.localizedDescription)")
                completion(.failure(error))
            }
        }.resume()
    }
    
    // Add a product to the API
    func addProduct(product: Product, completion: @escaping (Result<String, Error>) -> Void) {
        guard let url = URL(string: "https://app.getswipe.in/api/public/add") else {
            print("Invalid URL")
            return
        }
        
        print("Adding product: \(product.productName)")
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        // Prepare form data
        let formData = [
            "product_name": product.productName,
            "product_type": product.productType,
            "price": String(product.price),
            "tax": String(product.tax)
        ]
        
        // Encode form data
        let formBody = formData.map { "\($0.key)=\($0.value)" }.joined(separator: "&")
        request.httpBody = formBody.data(using: .utf8)
        
        print("Sending data: \(formBody)")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Network error: \(error.localizedDescription)")
                completion(.failure(error))
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                print("Response status code: \(httpResponse.statusCode)")
            }
            
            guard let data = data else {
                print("No data received")
                completion(.failure(NSError(domain: "NoDataError", code: -1)))
                return
            }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                   let message = json["message"] as? String {
                    completion(.success(message))
                } else {
                    print("Unexpected response format")
                    completion(.failure(NSError(domain: "ResponseError", code: -1)))
                }
            } catch {
                print("Failed to parse JSON: \(error.localizedDescription)")
                completion(.failure(error))
            }
        }.resume()
    }
}
