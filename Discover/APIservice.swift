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
            
            if let error = error{
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
    
    
    
    
    
    
    
}

