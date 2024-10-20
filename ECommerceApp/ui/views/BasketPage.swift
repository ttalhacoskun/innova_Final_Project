//
//  BasketPage.swift
//  ECommerceApp
//
//  Created by Talha Coşkun on 16.10.2024.
//

import UIKit
import Lottie

class BasketPage: UIViewController {
    
    @IBOutlet weak var productsBasketTableView: UITableView!
    @IBOutlet weak var subtotalLabel: UILabel!
    @IBOutlet weak var DeliveryFeeLabel: UILabel!
    @IBOutlet weak var DiscountLabel: UILabel!
    @IBOutlet weak var checkForButton: UIButton!
    
    var basketProductsList = [ProductsBasket]()
    var viewModel = BasketpageViewModel()
    
    private var animationView: LottieAnimationView?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Delegate ve DataSource atamaları
        productsBasketTableView.delegate = self
        productsBasketTableView.dataSource = self
        productsBasketTableView.isScrollEnabled = true
        productsBasketTableView.rowHeight = 110
        productsBasketTableView.estimatedRowHeight = 110

        // Ödeme butonuna tıklama hedefi ekleme
        checkForButton.addTarget(self, action: #selector(showPaymentAnimation), for: .touchUpInside)

        // Ürünleri ViewModel'den almak için subscription
        _ = viewModel.basketProductsList.subscribe(onNext: { list in
            self.basketProductsList = list
            DispatchQueue.main.async {
                self.productsBasketTableView.reloadData()
                self.updatePriceLabels() // Fiyatları güncelle
            }
        })
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.getBasketProducts() // Sepet ürünlerini getir
    }

    // Ödeme animasyonu gösterme
    @objc private func showPaymentAnimation() {
        animationView = .init(name: "Animation - 1729382109894") // JSON dosya adı
        animationView?.frame = view.bounds
        animationView?.contentMode = .scaleAspectFit
        animationView?.loopMode = .playOnce // Animasyon bir kez oynasın
        
        if let animationView = animationView {
            view.addSubview(animationView)
            animationView.play { [weak self] (finished) in
                animationView.removeFromSuperview() // Animasyon bitince kaldır
            }
        }
    }

    // Fiyatları güncelleme
    private func updatePriceLabels() {
        let subtotal = basketProductsList.reduce(0) { $0 + ($1.fiyat ?? 0) * ($1.siparisAdeti ?? 1) }
        subtotalLabel.text = formatPrice(Double(subtotal))

        let deliveryFee = Double(subtotal) * 0.20
        DeliveryFeeLabel.text = formatPrice(deliveryFee)

        let discount = Double(subtotal) * 0.05
        DiscountLabel.text = formatPrice(-discount)

        let total = Double(subtotal) + deliveryFee - discount
        checkForButton.setTitle("Ödeme Yapın: \(formatPrice(total))", for: .normal)
    }

    // Fiyat formatlama fonksiyonu
    private func formatPrice(_ value: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencySymbol = "₺"
        formatter.locale = Locale(identifier: "tr_TR")
        formatter.maximumFractionDigits = 2
        formatter.groupingSeparator = "."
        formatter.decimalSeparator = ","
        return formatter.string(from: NSNumber(value: value)) ?? "\(value) ₺"
    }
}

// MARK: - UITableViewDelegate ve UITableViewDataSource
extension BasketPage: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return basketProductsList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "basketProductCell", for: indexPath) as! ProductBasketCell
        let basketProduct = basketProductsList[indexPath.item]

        // Hücreyi yapılandırma
        cell.configureCell(with: basketProduct)
        cell.resimGoster(resimAd: basketProduct.resim!)

        // Miktar artırma
        cell.increaseAction = { [weak self] in
            basketProduct.siparisAdeti? += 1
            self?.productsBasketTableView.reloadRows(at: [indexPath], with: .none)
            self?.updatePriceLabels() // Fiyatları güncelle
        }

        // Miktar azaltma
        cell.decreaseAction = { [weak self] in
            guard basketProduct.siparisAdeti ?? 1 > 1 else { return }
            basketProduct.siparisAdeti? -= 1
            self?.productsBasketTableView.reloadRows(at: [indexPath], with: .none)
            self?.updatePriceLabels() // Fiyatları güncelle
        }

        return cell
    }

    // Ürün silme işlemi için swipe action
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let silAction = UIContextualAction(style: .destructive, title: "Sil") { _, _, completionHandler in
            let product = self.basketProductsList[indexPath.item]
            let alert = UIAlertController(title: "Silme İşlemi", message: "\(product.ad ?? "Ürün") silinsin mi?", preferredStyle: .alert)

            let iptalAction = UIAlertAction(title: "İptal", style: .cancel) { _ in
                completionHandler(false) // İptal edildi
            }
            alert.addAction(iptalAction)

            let evetAction = UIAlertAction(title: "Evet", style: .destructive) { _ in
                self.viewModel.sil(basketId: product.sepetId!)
                self.basketProductsList.remove(at: indexPath.item)
                self.productsBasketTableView.deleteRows(at: [indexPath], with: .automatic)
                self.updatePriceLabels() // Fiyatları güncelle
                completionHandler(true) // Başarılı
            }
            alert.addAction(evetAction)

            self.present(alert, animated: true)
        }

        return UISwipeActionsConfiguration(actions: [silAction])
    }
}
