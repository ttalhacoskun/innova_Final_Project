//
//  FavoriteCell.swift
//  ECommerceApp
//
//  Created by Talha Coşkun on 15.10.2024.
//

import UIKit

class FavoriteCell: UITableViewCell {
    @IBOutlet weak var productImageView: UIImageView! // Ürün görseli
    @IBOutlet weak var productNameLabel: UILabel! // Ürün adı
    @IBOutlet weak var productCategoryLabel: UILabel! // Ürün kategorisi
    @IBOutlet weak var productPriceLabel: UILabel! // Ürün fiyatı
    @IBOutlet weak var productBrandLabel: UILabel! // Ürün markası
    @IBOutlet weak var productDescriptionLabel: UILabel! // Ürün açıklaması

    override func awakeFromNib() {
        super.awakeFromNib()
        // Hücreyi başlatırken gerekli ayarlar
        productImageView.layer.cornerRadius = 8
        productImageView.clipsToBounds = true
    }
}
