//
//  ProductsDetailViewModel.swift
//  ECommerceApp
//
//  Created by Talha Coşkun on 7.10.2024.
//

import Foundation
import RxSwift

class ProductsDetailViewModel {
    private let prepo = ProductsRepository() // Repository örneği
    private let disposeBag = DisposeBag() // Bellek yönetimi
    

    // Sepete ürün ekleme fonksiyonu
    func addBasket(name: String, image: String, category: String, price: Int, brand: String, orderCount: Int, nickname: String) {
        prepo.kaydet(name: name, image: image, category: category, price: price, brand: brand, orderCount: orderCount, nickname: nickname)
        print("\(name) sepete eklendi.")
    }

    // Kullanıcı güncelleme fonksiyonu (Eğer gerekiyorsa)
    func guncelle(userId: Int, userName: String, userPhone: String) {
        // Buraya ileride güncelleme işlemi için kod eklenebilir
        print("Kullanıcı \(userName) güncelleniyor...")
    }
    
}
