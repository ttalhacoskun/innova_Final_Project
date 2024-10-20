//
//  BasketPageViewModel.swift
//  ECommerceApp
//
//  Created by Talha Coşkun on 7.10.2024.
//
import Foundation
import RxSwift
import Kingfisher


class BasketpageViewModel {
    
    var prepo = ProductsRepository()
    var basketProductsList = BehaviorSubject <[ProductsBasket]> (value: [ProductsBasket]())
    
    init(){
        basketProductsList = prepo.basketProductsList
        prepo.getBasketProducts(nickname: "talha_coskun")
        print("222")
        print(basketProductsList)
    }
    
    func sil(basketId:Int){
        prepo.sil(basketId: basketId, nickname: "talha_coskun")
        getBasketProducts()
    }
    
    func ara(aramaKelimesi:String){
       // prepo.ara(aramaKelimesi: aramaKelimesi)
    }
   
    func getBasketProducts(){
        print("burası2")
        prepo.getBasketProducts(nickname: "talha_coskun")
    }
}
