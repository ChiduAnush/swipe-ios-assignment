//
//  APIfile.swift
//  Discover
//
//  Created by ChiduAnush on 02/01/25.
//

import Foundation

class APIservice{
    static let shared = APIservice()
    private init(){
        print("API service started")
    }
    
    func fetchProducts(completion: @escaping (Result<[Product], Error>) -> Void){
        
        print("Start fetch")
        
        guard let url = URL(string: "https://app.getswipe.in/api/public/get") else {
            print("Invalid URL")
            return
        }
        
        print("url: \(url.absoluteString)")
        
        URLSession.shared.dataTask(with: url){ data, response, error in
            if error != nil{
                print("error 1")
                return
            }
            guard let data = data else {
                print("no data got")
                return
            }
            print("got data ")
            do {
                // Print the raw JSON for debugging
                if let jsonString = String(data: data, encoding: .utf8) {
                    print("Json Received: \(jsonString)")
                }
                
                let products = try JSONDecoder().decode([Product].self, from: data)
                print("Successfully decoded \(products.count) products")
                completion(.success(products))
            } catch {
                print("Decoding Error: \(error.localizedDescription)")
                completion(.failure(error))
            }
        }.resume()
    }
    
    func addProduct(product: Product, completion: @escaping (Result<String, Error>) -> Void) {
        print("Adding product: \(product.productName)")

        guard let url = URL(string: "https://app.getswipe.in/api/public/add") else {
            print("URL invalid.")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type") // Format we're using

        let formData = [
            "product_name": product.productName,
            "product_type": product.productType,
            "price": String(format: "%.2f", product.price),
            "tax": String(format: "%.2f", product.tax)
        ]

        let formBody = formData.map { key, value in
            let encodedKey = key.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? key
            let encodedValue = value.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? value
            return "\(encodedKey)=\(encodedValue)"
        }.joined(separator: "&")

        request.httpBody = formBody.data(using: .utf8)

        print("Sending data: \(formBody)")

        URLSession.shared.dataTask(with: request) { data, response, error in

            if let error = error {
                print("Network error: \(error.localizedDescription)")
                completion(.failure(error))
                return
            }

            if let httpResponse = response as? HTTPURLResponse {
                print("Got response: \(httpResponse.statusCode)")
            }

            guard let data = data else {
                print("No data received")
                completion(.failure(NSError(domain: "NoDataError", code: -1)))
                return
            }

            do {
                if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any] {
                    print("Parsed response: \(json)")
                    
                    if let message = json["message"] as? String {
                        completion(.success(message))
                    } else if let error = json["error"] as? String {
                        completion(.failure(NSError(domain: "APIError", code: -1, userInfo: ["message": error])))
                    } else {
                        print("Unexpected response format.")
                        completion(.failure(NSError(domain: "ResponseError", code: -1)))
                    }
                }
            } catch {
                print("Failed to parse error JSON: \(error)")
                completion(.failure(error))
            }
        }.resume()
    }

    
    
    
    
}

