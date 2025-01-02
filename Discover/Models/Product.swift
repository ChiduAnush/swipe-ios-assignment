//
//  Product.swift
//  Discover
//
//  Created by ChiduAnush on 02/01/25.
//

import Foundation

struct Product: Identifiable, Codable{
    let id = UUID()
    let productName: String
    let productType: String
    let price: Double
    let tax: Double
    let image: String?
    
    enum CodingKeys: String, CodingKey {
        case productName = "product_name"
        case productType = "product_type"
        case price, tax, image
    }
}
