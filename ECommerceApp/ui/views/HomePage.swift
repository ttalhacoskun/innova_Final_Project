//
//  ViewController.swift
//  ECommerceApp
//
//  Created by Talha Coşkun on 7.10.2024.
//
import UIKit
import Kingfisher

class HomePage: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var productsCollectionView: UICollectionView!
    @IBOutlet weak var categoryCollectionView: UICollectionView!
    @IBOutlet weak var buttonFilter: UIButton!
    @IBOutlet weak var informationCollectionView: UICollectionView!

    // MARK: - Properties
    private var viewModel = HomepageViewModel()
    private var productsList = [Products]()
    private var filteredProductsList = [Products]()
    private let categories = ["Tümü", "Teknoloji", "Kozmetik", "Aksesuar"]
    private let assetAdNames = ["images2", "images3", "images"]
    private var selectedCategoryIndex: Int = 0

    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDelegates()
        setupCollectionViewLayout()
        bindViewModel()
        categoryCollectionView.reloadData()
    }

    // MARK: - Setup Methods
    private func setupDelegates() {
        searchBar.delegate = self
        productsCollectionView.delegate = self
        productsCollectionView.dataSource = self
        categoryCollectionView.delegate = self
        categoryCollectionView.dataSource = self
        informationCollectionView.delegate = self
        informationCollectionView.dataSource = self

        informationCollectionView.showsHorizontalScrollIndicator = false
        informationCollectionView.showsVerticalScrollIndicator = false
    }

    private func setupCollectionViewLayout() {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 10, left: 15, bottom: 10, right: 15)
        layout.minimumInteritemSpacing = 15
        layout.minimumLineSpacing = 20

        let screenWidth = UIScreen.main.bounds.width
        let itemWidth = (screenWidth - 45) / 2
        layout.itemSize = CGSize(width: itemWidth, height: itemWidth * 1.4)

        productsCollectionView.collectionViewLayout = layout
    }

    private func bindViewModel() {
        _ = viewModel.productsList.subscribe(onNext: { [weak self] list in
            guard let self = self else { return }
            self.productsList = list
            self.filteredProductsList = list
            DispatchQueue.main.async {
                self.productsCollectionView.reloadData()
            }
        })
    }

    // MARK: - Actions
    @IBAction func buttonFilterTapped(_ sender: UIButton) {
        presentFilterAlert()
    }

    private func presentFilterAlert() {
        let alert = UIAlertController(title: "Filtreleme Seçenekleri", message: "Bir filtre seçin", preferredStyle: .actionSheet)

        alert.addAction(createFilterAction(title: "Artan Fiyat", comparator: { $0.fiyat ?? 0 < $1.fiyat ?? 0 }))
        alert.addAction(createFilterAction(title: "Azalan Fiyat", comparator: { $0.fiyat ?? 0 > $1.fiyat ?? 0 }))
        alert.addAction(createFilterAction(title: "İsme Göre", comparator: { $0.ad ?? "" < $1.ad ?? "" }))
        alert.addAction(UIAlertAction(title: "İptal", style: .cancel))

        present(alert, animated: true)
    }

    private func createFilterAction(title: String, comparator: @escaping (Products, Products) -> Bool) -> UIAlertAction {
        return UIAlertAction(title: title, style: .default) { _ in
            self.filteredProductsList.sort(by: comparator)
            self.productsCollectionView.reloadData()
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetail", let product = sender as? Products {
            let detailVC = segue.destination as! ProductsDetail
            detailVC.product = product
        }
    }
}

// MARK: - UISearchBarDelegate
extension HomePage: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            viewModel.getProducts()
        } else {
            viewModel.searchProducts(searchText: searchText)
        }
    }
}

// MARK: - UICollectionViewDelegate & UICollectionViewDataSource
extension HomePage: UICollectionViewDelegate, UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case categoryCollectionView:
            return categories.count
        case informationCollectionView:
            return assetAdNames.count
        default:
            return filteredProductsList.count
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView {
        case informationCollectionView:
            return configureInformationCell(at: indexPath)
        case categoryCollectionView:
            return configureCategoryCell(at: indexPath)
        default:
            return configureProductCell(at: indexPath)
        }
    }

    private func configureInformationCell(at indexPath: IndexPath) -> UICollectionViewCell {
        let cell = informationCollectionView.dequeueReusableCell(withReuseIdentifier: "informationCell", for: indexPath) as! informationCell
        cell.imformationİmage.image = UIImage(named: assetAdNames[indexPath.item])
        return cell
    }

    private func configureCategoryCell(at indexPath: IndexPath) -> UICollectionViewCell {
        let cell = categoryCollectionView.dequeueReusableCell(withReuseIdentifier: "categoryCell", for: indexPath)
        setupCategoryCell(cell, indexPath: indexPath)
        return cell
    }

    private func configureProductCell(at indexPath: IndexPath) -> UICollectionViewCell {
        let cell = productsCollectionView.dequeueReusableCell(withReuseIdentifier: "productCell", for: indexPath) as! ProductsCell
        setupProductCell(cell, indexPath: indexPath)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == categoryCollectionView {
            selectedCategoryIndex = indexPath.item
            applyCategoryFilter(categories[indexPath.item])
            categoryCollectionView.reloadData()
        } else {
            performSegue(withIdentifier: "toDetail", sender: filteredProductsList[indexPath.item])
        }
    }

    private func setupCategoryCell(_ cell: UICollectionViewCell, indexPath: IndexPath) {
        cell.contentView.subviews.forEach { $0.removeFromSuperview() }

        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.text = categories[indexPath.item]
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textColor = indexPath.item == selectedCategoryIndex ? .systemGreen : .black

        cell.contentView.addSubview(label)
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: cell.contentView.topAnchor, constant: 15),
            label.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor, constant: 13),
            label.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor, constant: -15),
            label.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor, constant: -5)
        ])
    }

    private func setupProductCell(_ cell: ProductsCell, indexPath: IndexPath) {
        let product = filteredProductsList[indexPath.item]
        cell.labelProductName.text = product.ad
        cell.labelProductCategory.text = product.kategori
        cell.labelProductBrand.text = product.marka
        cell.labelProductPrice.text = "\(product.fiyat ?? 0) ₺"
        cell.resimGoster(resimAdi: product.resim ?? "")
    }

    private func applyCategoryFilter(_ category: String) {
        filteredProductsList = category == "Tümü" ? productsList : productsList.filter { $0.kategori == category }
        productsCollectionView.reloadData()
    }
}
