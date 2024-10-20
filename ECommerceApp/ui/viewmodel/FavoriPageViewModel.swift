//
//  FavoriPageViewModel.swift
//  ECommerceApp
//
//  Created by Talha Coşkun on 19.10.2024.
//

import Foundation
import RxSwift


class FavoriPageViewModel {
    
    var frepo = FavoriProductRepository()
    var favoriProductList = BehaviorSubject <[FavoriProduct]> (value: [FavoriProduct]())
    
    init(){
        veritabaniKopyala()
        favoriProductList = frepo.favoriProductList
        favoriYukle()
    }
    
    func favoriYukle(){
        frepo.favoriUrunleriYukle()
    }
    
    // Ürün favorilerde mi kontrol eder
    func isProductFavorited(id: Int) -> Bool {
        do {
            let currentList = try favoriProductList.value()
            return currentList.contains { $0.id == id }
        } catch {
            print("Favori listesi alınamadı: \(error.localizedDescription)")
            return false
        }
    }
    
    func kaydet(ad:String, resim:String,kategori:String,fiyat:Int , marka:String, favori:Int){
        frepo.favoriEkle(ad: ad, resim: resim, kategori: kategori, fiyat: fiyat, marka: marka, favori: favori)
    }
    
    func sil(favori: FavoriProduct) {
        frepo.favoriKaldir(id: favori.id)  // ID üzerinden silme işlemi
        favoriYukle()  // Listeyi güncelle
    }

     
    func veritabaniKopyala(){
            let bundleYolu = Bundle.main.path(forResource: "favori", ofType: ".db")
            let hedefYol = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
            let kopyalanacakYer = URL(fileURLWithPath: hedefYol).appendingPathComponent("favori.db")
            let fileManager = FileManager.default
            if fileManager.fileExists(atPath: kopyalanacakYer.path){
                print("Veritabanı zaten var")
            }else{
                do{
                    try fileManager.copyItem(atPath: bundleYolu!, toPath: kopyalanacakYer.path)
                }catch{}
            }
        }
}
