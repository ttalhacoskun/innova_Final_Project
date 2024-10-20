//
//  favoriteMenager.swift
//  ECommerceApp
//
//  Created by Talha Coşkun on 14.10.2024.
//

import Foundation

class FavoriteManager {
    static let shared = FavoriteManager() // Singleton instance

    private init() {} // Başka yerden init edilmesini önler

    var favoriteProducts: [ProductsBasket] = []

    func addToFavorites(_ product: ProductsBasket) {
        if !isFavorite(product) {
            favoriteProducts.append(product)
        }
    }

    func isFavorite(_ product: ProductsBasket) -> Bool {
        return favoriteProducts.contains { $0.sepetId == product.sepetId }
    }
}
