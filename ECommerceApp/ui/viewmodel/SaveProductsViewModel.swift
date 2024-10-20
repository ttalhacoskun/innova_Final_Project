//
//  SaveProductsViewModel.swift
//  ECommerceApp
//
//  Created by Talha Coşkun on 7.10.2024.
//

import Foundation

class SaveProductsViewModel {
    var prepo = ProductsRepository()
    
    func kaydet(kisi_ad:String, kisi_tel:String){
       // krepo.kaydet(kisi_ad: kisi_ad, kisi_tel: kisi_tel)
    }
    
    func addBasket(name:String, image:String, category:String, price:Int, brand:String, orderCount:Int, nickname:String){
        prepo.kaydet(name: name, image: image, category: category, price: price, brand: brand, orderCount: orderCount, nickname: nickname)
    }
    
    
}
