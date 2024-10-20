//
//  FavoritePage.swift
//  ECommerceApp
//
//  Created by Talha Coşkun on 14.10.2024.
//

import UIKit

class FavoritePage: UIViewController {

    @IBOutlet weak var tableView: UITableView! // TableView bağlantısı

    override func viewDidLoad() {
        super.viewDidLoad()

        // Delegate ve DataSource atamaları
        tableView.delegate = self
        tableView.dataSource = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData() // Sayfa her göründüğünde tabloyu güncelle
    }
}

// MARK: - UITableViewDelegate & UITableViewDataSource
extension FavoritePage: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return FavoriteManager.shared.favoriteProducts.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "favoriteCell", for: indexPath) as! FavoritePageCell
        let product = FavoriteManager.shared.favoriteProducts[indexPath.row]

        // Hücreyi yapılandır
        cell.configureCell(with: product)
        return cell
    }

    // Yana kaydırarak silme işlemi
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Sil") { _, _, completionHandler in
            // Ürünü favorilerden kaldır
            FavoriteManager.shared.favoriteProducts.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            completionHandler(true)
        }
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}
