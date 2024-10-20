//
//  ProductsRepository.swift
//  ECommerceApp
//
//  Created by Talha Coşkun on 7.10.2024.
//
import Foundation
import RxSwift
import Alamofire

class ProductsRepository {
    
    var productsList = BehaviorSubject <[Products]> (value: [Products]())
    var filteredProductsList = BehaviorSubject <[Products]> (value: [Products]())
    var basketProductsList = BehaviorSubject <[ProductsBasket]> (value: [ProductsBasket]())
    
    func getProducts(){
        let url = "http://kasimadalan.pe.hu/urunler/tumUrunleriGetir.php";
        
        AF.request(url, method: .get).response { response in
            if let data = response.data {
                do {
                    let reply = try JSONDecoder().decode(ProductsReply.self, from: data)
                    if let list = reply.urunler {
                        print("111")
                        print(self.productsList)
                        self.productsList.onNext(list) // tetikleme
                    }
                    else {
                        print("333")
                    }
                }
                catch{
                    print(error.localizedDescription)
                }
                
            }
        }
    }
    
    
    func kaydet(name: String, image: String, category: String, price: Int, brand: String, orderCount: Int, nickname: String) {
        let url = "http://kasimadalan.pe.hu/urunler/sepeteUrunEkle.php"
        
        // API'ye gönderilen parametreler
        let params: Parameters = [
            "ad": name,
            "resim": image,
            "kategori": category,
            "fiyat": price,
            "marka": brand,
            "siparisAdeti": orderCount,
            "kullaniciAdi": nickname
        ]
        
        // Parametrelerin doğru gönderilip gönderilmediğini kontrol edin
        print("Gönderilen Parametreler: \(params)")
        
        // API isteği başlatılıyor
        AF.request(url, method: .post, parameters: params).response { response in
            if let data = response.data {
                do {
                    // Yanıtı JSON olarak parse ediyoruz
                    let cevap = try JSONDecoder().decode(CRUDreply.self, from: data)
                    
                    // Sipariş adedini ve yanıtı kontrol edin
                    print("SİPARİŞ ADEDİ: \(orderCount)")
                    print("Başarı: \(cevap.success ?? 0)")
                    print("Mesaj: \(cevap.message ?? "Yanıt yok")")
                    
                } catch {
                    print("JSON decode hatası: \(error.localizedDescription)")
                }
            } else if let error = response.error {
                print("Ağ hatası: \(error.localizedDescription)")
            }
        }
    }
    func getBasketProducts(nickname:String){
        let url = "http://kasimadalan.pe.hu/urunler/sepettekiUrunleriGetir.php";
        let params:Parameters = ["kullaniciAdi":nickname]
        AF.request(url, method: .post,parameters: params).response { response in
            if let data = response.data {
                do {
                    let reply = try JSONDecoder().decode(ProductsBasketReply.self, from: data)
                    if let basketList = reply.urunler_sepeti {
                        self.basketProductsList.onNext(basketList) // BehaviorSubject'i tetikle
                        for productBasket in basketList {
                            print("Sepet ID: \(productBasket.sepetId!)")
                            print("Ürün Adı: \(productBasket.ad!)")
                            print("Resim: \(productBasket.resim ?? "Resim Yturkok")")
                        }
                        
                        print("Sepetteki ürünler başarıyla alındı")
                    } else {
                        print("Sepetteki ürünler listesi boş.")
                    }
                    print("başarı: \(reply.success!)")
                    print("sepetim: \(reply.urunler_sepeti!)")
                    
                }
                catch{
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    
    func sil(basketId:Int, nickname:String){
        //sepetId int
        // kullaniciAdi String
        print("silmeye calısıldu: aaaaa")
        print(basketId)
        print("aaaaa")
        let url = "http://kasimadalan.pe.hu/urunler/sepettenUrunSil.php";
        let params:Parameters = ["sepetId":basketId, "kullaniciAdi":"talha_coskun"]
        AF.request(url, method: .post,parameters: params).response { response in
            if let data = response.data {
                print("silmeye calısıldııııııı")
                do {
                    let reply = try JSONDecoder().decode(CRUDreply.self, from: data)
                    print("başarı: \(reply.success!)")
                    print("mesaj: \(reply.message!)")
                }
                catch{
                    print(error.localizedDescription)
                }
            }
        }
    }
        
        func ara(aramaKelimesi:String){
            /*   let url = "http://kasimadalan.pe.hu/kisiler/tumkisiler_arama.php";
             let params:Parameters = ["kisi_id":aramaKelimesi]
             AF.request(url, method: .post,parameters: params).response { response in
             if let data = response.data {
             do{
             let cevap = try JSONDecoder().decode(KisilerCevap.self, from: data)
             if let liste = cevap.kisiler {
             self.kisilerListesi.onNext(liste)//Tetikleme
             }
             }catch{
             print(error.localizedDescription)
             }
             }
             }*/
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
        
    }
