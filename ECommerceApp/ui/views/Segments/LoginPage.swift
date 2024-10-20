//
//  LoginPageViewController.swift
//  ECommerceApp
//
//  Created by Talha Coşkun on 18.10.2024.
//
import UIKit
import FirebaseAuth
import FirebaseFirestore

class LoginPage: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var tfEmail: UITextField!
    @IBOutlet weak var tfPassword: UITextField!

    // MARK: - Properties
    private let db = Firestore.firestore()  // Firestore veritabanı referansı

    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupPlaceholders()
        configureNavigationBar()
    }

    // MARK: - Setup Methods
    /// Placeholderları ve alt sınırları ayarlar.
    private func setupPlaceholders() {
        let placeholderColor = UIColor(red: 99.0/255.0, green: 99.0/255.0, blue: 102.0/255.0, alpha: 0.6)
        
        tfEmail.setPlaceholder("Email", color: placeholderColor)
        tfPassword.setPlaceholder("Password", color: placeholderColor)

        tfEmail.addBottomBorderWithColor(color: .lightGray, width: 0.5)
        tfPassword.addBottomBorderWithColor(color: .lightGray, width: 0.5)
    }

    /// Navigation bar'ı gizler ve geri tuşunu devre dışı bırakır.
    private func configureNavigationBar() {
        navigationItem.hidesBackButton = true
        navigationController?.setNavigationBarHidden(true, animated: true)
    }

    // MARK: - Actions
    @IBAction func loginUser(_ sender: UIButton) {
        guard let email = tfEmail.text, !email.isEmpty,
              let password = tfPassword.text, !password.isEmpty else {
            showAlert(title: "Hata", message: "Lütfen tüm alanları doldurun.")
            return
        }

        signInUser(email: email, password: password)
    }

    // MARK: - Firebase Methods
    /// Firebase Authentication ile giriş yapar.
    private func signInUser(email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
            guard let self = self else { return }

            if let error = error {
                self.showAlert(title: "Giriş Hatası", message: error.localizedDescription)
                return
            }

            guard let userID = authResult?.user.uid else { return }
            self.verifyUserInFirestore(userID: userID)
        }
    }

    /// Firestore'da kullanıcının verilerini doğrular.
    private func verifyUserInFirestore(userID: String) {
        db.collection("users").document(userID).getDocument { [weak self] document, error in
            guard let self = self else { return }

            if let error = error {
                self.showAlert(title: "Veri Hatası", message: "Kullanıcı verisi doğrulanamadı: \(error.localizedDescription)")
                return
            }

            if let document = document, document.exists {
                let data = document.data()
                let firstName = data?["firstname"] as? String ?? "Ad"
                let lastName = data?["lastName"] as? String ?? "Soyad"
                print("Kullanıcı adı: \(firstName) \(lastName) doğrulandı.")
            } else {
                self.showAlert(title: "Hata", message: "Kullanıcı verisi bulunamadı.")
            }
        }
    }

    // MARK: - Helper Methods
    /// Uyarı mesajı gösterir.
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Tamam", style: .default))
        present(alert, animated: true)
    }
}

// MARK: - UIView Extension (Alt Sınır Ekleme)
extension UIView {
    /// Görünüme alt sınır ekler.
    func addBottomBorderWithColor(color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(
            x: 0,
            y: frame.size.height - width,
            width: frame.size.width - 25,
            height: width
        )
        layer.addSublayer(border)
    }
}

// MARK: - UITextField Extension (Placeholder Ayarı)
extension UITextField {
    /// Placeholder metnini ve rengini ayarlar.
    func setPlaceholder(_ text: String, color: UIColor) {
        attributedPlaceholder = NSAttributedString(
            string: text,
            attributes: [NSAttributedString.Key.foregroundColor: color]
        )
    }
}
