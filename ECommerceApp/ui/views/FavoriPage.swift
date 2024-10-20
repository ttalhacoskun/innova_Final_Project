//
//  FavoriPage.swift
//  ECommerceApp
//
//  Created by Talha Coşkun on 19.10.2024.
//

import UIKit
import RxSwift

class FavoriPage: UIViewController {

    @IBOutlet weak var favoriTableView: UITableView!
    var favoriProductList = [FavoriProduct]()
    
    var viewModel = FavoriPageViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        favoriTableView.delegate = self
        favoriTableView.dataSource = self
       
        favoriTableView.rowHeight = 110
        favoriTableView.estimatedRowHeight = 110
        
        _ = viewModel.favoriProductList.subscribe(onNext: { liste in
            self.favoriProductList  = liste
            self.favoriTableView.reloadData()
        })
    }
    override func viewDidAppear(_ animated: Bool) {
        viewModel.favoriYukle()
    }
}




extension FavoriPage: UITableViewDelegate, UITableViewDataSource {
  
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoriProductList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let hucre = tableView.dequeueReusableCell(withIdentifier: "favoriCell") as! FavoriCell
        let favori = favoriProductList[indexPath.row]
        hucre.labelFavoriCategory.text = favori.kategori
        hucre.labelFavoriName.text = favori.ad
        hucre.labelFavoriBrand.text = favori.marka
        hucre.labelFavoriImage.text = favori.resim
        hucre.labelFavoriPrice.text = String(favori.fiyat)
        if let url = URL(string: "http://kasimadalan.pe.hu/urunler/resimler/\(favori.resim)"){
            DispatchQueue.main.async {
                hucre.favoriImageView.kf.setImage(with: url)
            }
        }
        print("favvvv listesi")
        print(favori.ad)
        return hucre
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let favori = favoriProductList[indexPath.row]
        print("\(favori.ad)  seçildi")
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let silAction = UIContextualAction(style: .destructive, title: "Sil") { [weak self] _, _, completionHandler in
            guard let self = self else { return }
            let favori = self.favoriProductList[indexPath.row]

            let alert = UIAlertController(title: "Silme İşlemi", message: "\(favori.ad) silinsin mi?", preferredStyle: .alert)
            
            let iptalAction = UIAlertAction(title: "İptal", style: .cancel) { _ in
                completionHandler(false)
            }
            alert.addAction(iptalAction)

            let evetAction = UIAlertAction(title: "Evet", style: .destructive) { _ in
                self.viewModel.sil(favori: favori)  // Silme işlemi
                completionHandler(true)
            }
            alert.addAction(evetAction)

            self.present(alert, animated: true)
        }

        return UISwipeActionsConfiguration(actions: [silAction])
    }


}
