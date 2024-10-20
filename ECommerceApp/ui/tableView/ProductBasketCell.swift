//
//  ProductBasketCell.swift
//  ECommerceApp
//
//  Created by Talha Coşkun on 8.10.2024.
//
import UIKit
import Kingfisher

class ProductBasketCell: UITableViewCell {

    // MARK: - Outlets
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var labelProductBasketName: UILabel!
    @IBOutlet weak var labelProductBasketCategory: UILabel!
    @IBOutlet weak var labelProductBasketPrice: UILabel!
    @IBOutlet weak var buttonIncrease: UIButton!
    @IBOutlet weak var buttonDecrease: UIButton!
    @IBOutlet weak var labelOrderCount: UILabel!

    // MARK: - Actions
    var increaseAction: (() -> Void)?
    var decreaseAction: (() -> Void)?

    // MARK: - Lifecycle Methods
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        productImageView.image = nil // Eski resimlerin hücrede kalmasını önlemek için.
    }

    // MARK: - Configuration
    /// Ürün bilgilerini hücreye atar.
    /// - Parameter product: Sepetteki ürün bilgisi.
    func configureCell(with product: ProductsBasket) {
        labelProductBasketName.text = product.ad ?? "Ürün Adı Yok"
        labelProductBasketCategory.text = product.kategori ?? "Kategori Yok"
        labelProductBasketPrice.text = "\(product.fiyat ?? 0) ₺"
        labelOrderCount.text = "\(product.siparisAdeti ?? 1)"
    }

    /// Verilen resim adını kullanarak URL üzerinden resmi yükler.
    /// - Parameter resimAd: Resim adı.
    func resimGoster(resimAd: String) {
        guard let url = URL(string: "http://kasimadalan.pe.hu/urunler/resimler/\(resimAd)") else { return }
        DispatchQueue.main.async {
            self.productImageView.kf.setImage(with: url)
        }
    }

    // MARK: - Button Actions
    /// Sipariş adedini artırır ve ilgili aksiyonu tetikler.
    @IBAction func increaseTapped(_ sender: UIButton) {
        guard var orderCount = Int(labelOrderCount.text ?? "1") else { return }
        orderCount += 1
        labelOrderCount.text = "\(orderCount)"
        increaseAction?()
    }

    /// Sipariş adedini 1'den küçük olmayacak şekilde azaltır ve ilgili aksiyonu tetikler.
    @IBAction func decreaseTapped(_ sender: UIButton) {
        guard var orderCount = Int(labelOrderCount.text ?? "1"), orderCount > 1 else { return }
        orderCount -= 1
        labelOrderCount.text = "\(orderCount)"
        decreaseAction?()
    }
}
