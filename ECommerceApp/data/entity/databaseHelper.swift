//
//  databaseHelper.swift
//  ECommerceApp
//
//  Created by Talha Coşkun on 14.10.2024.
//

import SQLite

class DatabaseHelper {
    static let shared = DatabaseHelper() // Singleton
    private var db: Connection?

    let favorites = Table("favorites") // Favori ürün tablosu
    let productId = Expression<Int>("product_id") // Ürün ID sütunu

    private init() {
        do {
            let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
            db = try Connection("\(path)/favori.db")

            // Tabloyu oluştur (eğer yoksa)
            try db?.run(favorites.create(ifNotExists: true) { table in
                table.column(productId, primaryKey: true)
            })
        } catch {
            print("Veritabanı bağlantı hatası: \(error.localizedDescription)")
        }
    }

    // Favori ürünlerin ID'lerini getir
    func getFavoriteProducts() -> [Int] {
        var ids: [Int] = []
        do {
            for product in try db!.prepare(favorites) {
                ids.append(product[productId])
            }
        } catch {
            print("Favori ürünleri alma hatası: \(error.localizedDescription)")
        }
        return ids
    }

    // Ürünü favorilere ekle
    func addFavorite(productId: Int) {
        do {
            try db?.run(favorites.insert(or: .replace, self.productId <- productId))
            print("Ürün favorilere eklendi: \(productId)")
        } catch {
            print("Favori ekleme hatası: \(error.localizedDescription)")
        }
    }

    // Ürünü favorilerden çıkar
    func removeFavorite(productId: Int) {
        let query = favorites.filter(self.productId == productId)
        do {
            try db?.run(query.delete())
            print("Ürün favorilerden çıkarıldı: \(productId)")
        } catch {
            print("Favori silme hatası: \(error.localizedDescription)")
        }
    }

    // Ürünün favori olup olmadığını kontrol et
    func isFavorite(productId: Int) -> Bool {
        let query = favorites.filter(self.productId == productId)
        do {
            if let _ = try db?.pluck(query) {
                return true // Favori
            }
        } catch {
            print("Favori kontrol hatası: \(error.localizedDescription)")
        }
        return false // Favori değil
    }
}
