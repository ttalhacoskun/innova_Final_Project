//
//  HomepageViewModel.swift
//  ECommerceApp
//
//  Created by Talha Coşkun on 7.10.2024.
//
import Foundation
import RxSwift

class HomepageViewModel {
    var basketProductCount = BehaviorSubject<Int>(value: 0) // Ürün sayısını izleme
    
    func addProductToBasket(product: Products) {
        // Ürün sepete eklenince sayıyı artır
        var currentCount = (try? basketProductCount.value()) ?? 0
        currentCount += 1
        basketProductCount.onNext(currentCount)
    }
    
    
    var prepo = ProductsRepository()
    var productsList = BehaviorSubject <[Products]> (value: [Products]())
    
    init(){
        productsList = prepo.productsList
        getProducts()
        print("222")
        print(productsList)
    }
    
    func sil(basketId:Int){
        prepo.sil(basketId: basketId, nickname: "talha_coskun")
        getProducts()
    }
    
    func searchProducts(searchText: String) {
            do {
                    let products = try productsList.value()
                    print("11111")

                    if searchText.isEmpty {
                        productsList.onNext(products)
                        print("22222")
                    } else {
                        print("3333")
                        print(searchText)
                        let filtered = products.filter { product in
                            product.ad?.lowercased().contains(searchText.lowercased()) ?? false
                        }
                        print(filtered)
                        productsList.onNext(filtered)
                        //filteredProductsList.onNext(filtered)
                    }
                } catch {
                    print("44444")
                    print("Ürün listesi okunamadı: \(error.localizedDescription)")
                }
            }
    
    // asagıdaki add basket yeni eklendi :::
   /* func addBasket(name:String, image:String, category:String, price:Int, brand:String, orderCount:Int, nickname:String){
        prepo.kaydet(name: name, image: image, category: category, price: price, brand: brand, orderCount: orderCount, nickname: nickname)
    } */
  
    
    func getProducts(){
        print("burası2")
        prepo.getProducts()
    }
    
}
