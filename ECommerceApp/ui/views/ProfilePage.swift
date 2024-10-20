//
//  ProfilePage.swift
//  ECommerceApp
//
//  Created by Talha Coşkun on 19.10.2024.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class ProfilePage: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var userNameSettings: UILabel!
    @IBOutlet weak var userSurnameSettings: UILabel!
    @IBOutlet weak var userEmailLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!

    // MARK: - Properties
    private let settings = [
        "🌏  Dil Seçenekleri",
        "🔔   Bildirim Ayarları",
        "🔒   Gizlilik ve Güvenlik",
        "👤   Hesap Bilgileri",
        "ℹ️   Uygulama Hakkında"
    ]

    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        fetchUserData()
    }

    // MARK: - Setup Methods
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "SettingsCell")
    }

    // MARK: - Fetch User Data
    private func fetchUserData() {
        guard let userID = Auth.auth().currentUser?.uid else {
            showAlert(title: "Hata", message: "Giriş yapmadınız. Lütfen tekrar deneyin.")
            return
        }

        Firestore.firestore().collection("users").document(userID).getDocument { [weak self] document, error in
            guard let self = self else { return }

            if let error = error {
                self.showAlert(title: "Hata", message: "Kullanıcı bilgileri alınamadı: \(error.localizedDescription)")
                return
            }

            guard let data = document?.data() else {
                self.showAlert(title: "Hata", message: "Kullanıcı bilgisi bulunamadı.")
                return
            }

            self.updateUserUI(with: data)
        }
    }

    private func updateUserUI(with data: [String: Any]) {
        userNameSettings.text = (data["firstName"] as? String)?.trimmingCharacters(in: .whitespacesAndNewlines) ?? "Ad"
        userSurnameSettings.text = (data["lastName"] as? String)?.trimmingCharacters(in: .whitespacesAndNewlines) ?? "Soyad"
        userEmailLabel.text = (data["email"] as? String)?.trimmingCharacters(in: .whitespacesAndNewlines) ?? "Email Bulunamadı"
    }

    // MARK: - Logout
    @IBAction func buttonLogoutTapped(_ sender: Any) {
        do {
            try Auth.auth().signOut()
            navigateToLogin()
        } catch {
            showAlert(title: "Hata", message: "Çıkış yapılamadı: \(error.localizedDescription)")
        }
    }

    private func navigateToLogin() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let loginVC = storyboard.instantiateViewController(withIdentifier: "goLoginPage") as? LoginPage else {
            print("LoginPage bulunamadı.")
            return
        }

        if let navController = navigationController {
            navController.pushViewController(loginVC, animated: true)
        } else {
            loginVC.modalPresentationStyle = .fullScreen
            present(loginVC, animated: true)
        }
    }

    // MARK: - Language Selection
    private func showLanguageSelection() {
        let alertController = UIAlertController(
            title: "Dil Seç",
            message: "Bir dil seçin",
            preferredStyle: .actionSheet
        )

        let languages: [(String, String)] = [("İngilizce", "en"), ("Türkçe", "tr")]

        languages.forEach { title, code in
            let action = UIAlertAction(title: title, style: .default) { _ in
                self.changeLanguage(to: code)
            }
            alertController.addAction(action)
        }

        alertController.addAction(UIAlertAction(title: "İptal", style: .cancel))
        present(alertController, animated: true)
    }

    private func changeLanguage(to languageCode: String) {
        UserDefaults.standard.set([languageCode], forKey: "AppleLanguages")
        UserDefaults.standard.synchronize()
        reloadApp()
    }

    private func reloadApp() {
        guard let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate,
              let window = sceneDelegate.window else { return }
        window.rootViewController = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController()
        window.makeKeyAndVisible()
    }

    // MARK: - Alerts
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Tamam", style: .default))
        present(alert, animated: true)
    }
}

// MARK: - UITableViewDelegate & UITableViewDataSource
extension ProfilePage: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settings.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsCell", for: indexPath)
        cell.textLabel?.text = settings[indexPath.row]
        cell.accessoryType = .disclosureIndicator
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        indexPath.row == 0 ? showLanguageSelection() : showAlert(title: "Özellik Pasif", message: "Bu özellik henüz aktif değil.")
    }
}
