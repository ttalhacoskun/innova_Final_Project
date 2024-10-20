//
//  FavoriPagecell.swift
//  ECommerceApp
//
//  Created by Talha Coşkun on 19.10.2024.
//
import UIKit
import Kingfisher

class FavoriCell: UITableViewCell {

    // MARK: - Outlets
    @IBOutlet weak var labelFavoriImage: UILabel!
    @IBOutlet weak var labelFavoriBrand: UILabel!
    @IBOutlet weak var labelFavoriPrice: UILabel!
    @IBOutlet weak var labelFavoriCategory: UILabel!
    @IBOutlet weak var labelFavoriName: UILabel!
    @IBOutlet weak var favoriImageView: UIImageView!

    // MARK: - Lifecycle Methods
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    // MARK: - Configuration
    /// Ürün bilgilerini hücreye atar.
    /// - Parameter product: Favori ürün bilgisi.
    func configure(with product: FavoriProduct) {
        labelFavoriName.text = product.ad
        labelFavoriBrand.text = product.marka
        labelFavoriCategory.text = product.kategori
        labelFavoriPrice.text = "\(product.fiyat) TL"
        
        // Resim URL'sini kontrol edip yükler, yoksa varsayılan resmi gösterir.
        if let imageUrl = URL(string: product.resim) {
            favoriImageView.kf.setImage(with: imageUrl)  // Kingfisher ile resmi yükle
        } else {
            favoriImageView.image = UIImage(named: "placeholder")  // Varsayılan resim
        }
    }
}
