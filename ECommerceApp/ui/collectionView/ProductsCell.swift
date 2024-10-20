//
//  CollectionViewCell.swift
//  ECommerceApp
//
//  Created by Talha Coşkun on 7.10.2024.
//

import UIKit
import Kingfisher

class ProductsCell: UICollectionViewCell {

    // MARK: - Outlets
    @IBOutlet weak var labelProductName: UILabel!
    @IBOutlet weak var labelProductCategory: UILabel!
    @IBOutlet weak var labelProductPrice: UILabel!
    @IBOutlet weak var labelProductBrand: UILabel!
    @IBOutlet weak var productImageView: UIImageView!

    // MARK: - Properties
    var viewModel = SaveProductsViewModel()

    // MARK: - Lifecycle Methods
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
        configureStackViews()
    }

    // MARK: - UI Setup
    private func setupUI() {
        contentView.layer.cornerRadius = 12.0
        contentView.layer.masksToBounds = true
        contentView.backgroundColor = UIColor.systemGray6

        productImageView.contentMode = .scaleAspectFit
        productImageView.clipsToBounds = true
    }

    // MARK: - Stack View Configuration
    private func configureStackViews() {
        let ratingLabel = createRatingLabel()

        let nameAndRatingStackView = createHorizontalStackView(
            arrangedSubviews: [labelProductName, UIView(), ratingLabel],
            spacing: 8
        )

        let infoStackView = createVerticalStackView(
            arrangedSubviews: [labelProductBrand, labelProductCategory, labelProductPrice],
            spacing: 5
        )

        let mainStackView = createVerticalStackView(
            arrangedSubviews: [productImageView, nameAndRatingStackView, infoStackView],
            spacing: 10
        )

        contentView.addSubview(mainStackView)
        setupConstraints(for: mainStackView)
    }

    private func createRatingLabel() -> UILabel {
        let ratingLabel = UILabel()
        ratingLabel.font = UIFont.systemFont(ofSize: 14)
        ratingLabel.textColor = .systemGreen
        ratingLabel.text = "⭐ 4.6"
        ratingLabel.setContentHuggingPriority(.required, for: .horizontal)
        return ratingLabel
    }

    private func createHorizontalStackView(arrangedSubviews: [UIView], spacing: CGFloat) -> UIStackView {
        let stackView = UIStackView(arrangedSubviews: arrangedSubviews)
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = spacing
        return stackView
    }

    private func createVerticalStackView(arrangedSubviews: [UIView], spacing: CGFloat) -> UIStackView {
        let stackView = UIStackView(arrangedSubviews: arrangedSubviews)
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = spacing
        return stackView
    }

    private func setupConstraints(for stackView: UIStackView) {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        ])
    }

    // MARK: - Image Loading
    func resimGoster(resimAdi: String) {
        guard let url = URL(string: "http://kasimadalan.pe.hu/urunler/resimler/\(resimAdi)") else {
            print("Geçersiz URL.")
            productImageView.image = UIImage(named: "placeholder")
            return
        }

        productImageView.kf.setImage(with: url) { [weak self] result in
            switch result {
            case .success(let value):
                print("Resim yüklendi: \(value.source.url?.absoluteString ?? "")")
            case .failure(let error):
                print("Resim yükleme hatası: \(error.localizedDescription)")
                self?.productImageView.image = UIImage(named: "placeholder")
            }
        }
    }
}
