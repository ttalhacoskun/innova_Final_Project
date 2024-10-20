//
//  ProductsDetail.swift
//  ECommerceApp
//
//  Created by Talha Coşkun on 7.10.2024.
//
import UIKit
import Lottie

class ProductsDetail: UIViewController {
    
    @IBOutlet weak var labelProductName: UILabel!
    @IBOutlet weak var labelProductCategory: UILabel!
    @IBOutlet weak var labelProductPrice: UILabel!
    @IBOutlet weak var labelProductBrand: UILabel!
    @IBOutlet weak var labelProductImage: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var favoriteButton: UIBarButtonItem!
    @IBOutlet weak var labelQuantity: UILabel!
    
    var product: Products?
    var viewModel = ProductsDetailViewModel()
    var productQuantity = 1
    var isFavorite = false

    override func viewDidLoad() {
        super.viewDidLoad()
        displayProductDetails()
        updateQuantityLabel()
        updateFavoriteIcon()
    }

    // Hide Tab Bar when the page appears
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
    }

    // Show Tab Bar when the page disappears
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }

    // Display product details
    private func displayProductDetails() {
        guard let p = product else { return }
        
        labelProductName.text = p.ad
        labelProductCategory.text = p.kategori
        labelProductBrand.text = p.marka
        labelProductImage.text = p.resim
        labelProductPrice.text = formatPrice(p.fiyat ?? 0)

        if let resimAdi = p.resim {
            resimGoster(resimAdi: resimAdi)
        }
    }

    // Format price for display
    func formatPrice(_ fiyat: Int) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.locale = Locale(identifier: "tr_TR")
        let formattedPrice = formatter.string(from: NSNumber(value: fiyat)) ?? "\(fiyat)"
        return "\(formattedPrice) ₺"
    }

    // Load product image
    private func resimGoster(resimAdi: String) {
        if let url = URL(string: "http://kasimadalan.pe.hu/urunler/resimler/\(resimAdi)") {
            DispatchQueue.main.async {
                self.imageView.kf.setImage(with: url)
            }
        }
    }

    // Handle favorite button click
    @IBAction func buttonFavorite(_ sender: UIBarButtonItem) {
        guard let product = product else { return }

        let favoriProduct = FavoriProduct(
            id: product.id ?? 0,
            ad: product.ad ?? "",
            resim: product.resim ?? "",
            kategori: product.kategori ?? "",
            fiyat: product.fiyat ?? 0,
            marka: product.marka ?? "",
            favori: 1
        )

        let viewModel = FavoriPageViewModel()
        viewModel.kaydet(
            ad: favoriProduct.ad,
            resim: favoriProduct.resim,
            kategori: favoriProduct.kategori,
            fiyat: favoriProduct.fiyat,
            marka: favoriProduct.marka,
            favori: favoriProduct.favori
        )

        isFavorite.toggle()
        updateFavoriteIcon()
    }

    // Update favorite icon based on status
    func updateFavoriteIcon() {
        favoriteButton.image = isFavorite ? UIImage(systemName: "heart.fill") : UIImage(systemName: "heart")
    }

    // Increase product quantity
    @IBAction func increaseQuantity(_ sender: UIButton) {
        productQuantity += 1
        updateQuantityLabel()
    }

    // Decrease product quantity (minimum is 1)
    @IBAction func decreaseQuantity(_ sender: UIButton) {
        if productQuantity > 1 {
            productQuantity -= 1
            updateQuantityLabel()
        }
    }

    // Update quantity label
    private func updateQuantityLabel() {
        labelQuantity.text = "\(productQuantity)"
    }

    // Add to basket with animation
    @IBAction func buttonAddBasket(_ sender: UIButton) {
        // Play Lottie animation
        playLottieAnimation()

        // Add product to basket logic
        guard let name = labelProductName.text, !name.isEmpty,
              let category = labelProductCategory.text, !category.isEmpty,
              let image = labelProductImage.text, !image.isEmpty,
              let brand = labelProductBrand.text, !brand.isEmpty,
              let priceText = labelProductPrice.text?.components(separatedBy: " ").first,
              let price = Int(priceText.replacingOccurrences(of: ".", with: "")) else {
            print("Ürün bilgileri eksik veya hatalı.")
            return
        }

        viewModel.addBasket(
            name: name,
            image: image,
            category: category,
            price: price,
            brand: brand,
            orderCount: productQuantity,
            nickname: "talha_coskun"
        )

        print("\(name) ~ sepete \(productQuantity) adet eklendi")
    }

    // Play Lottie animation
    private func playLottieAnimation() {
        let animationView = LottieAnimationView(name: "Animation - 1729383463638")
        animationView.frame = CGRect(x: 0, y: -20, width: 100, height: 100)
        animationView.center = self.view.center
        animationView.contentMode = .scaleAspectFit
        self.view.addSubview(animationView)

        animationView.play { [weak self] (finished) in
            animationView.removeFromSuperview()
        }
    }
}
