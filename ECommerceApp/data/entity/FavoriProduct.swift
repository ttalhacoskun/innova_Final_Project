//
//  FavoriProduct.swift
//  ECommerceApp
//
//  Created by Talha Coşkun on 19.10.2024.
//

import Foundation

class FavoriProduct {
    let id: Int
    let ad: String
    let resim: String
    let kategori: String
    let fiyat: Int
    let marka: String
    let favori: Int
    
    init(id: Int, ad: String, resim: String, kategori: String, fiyat: Int, marka: String, favori: Int) {
        self.id = id
        self.ad = ad
        self.resim = resim
        self.kategori = kategori
        self.fiyat = fiyat
        self.marka = marka
        self.favori = favori
    }
}
