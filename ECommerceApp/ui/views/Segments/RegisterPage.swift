//
//  RegisterPage.swift
//  ECommerceApp
//
//  Created by Talha Coşkun on 18.10.2024.
//
import UIKit
import FirebaseAuth
import FirebaseFirestore

class RegisterPage: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var tfName: UITextField!
    @IBOutlet weak var tfSurname: UITextField!
    @IBOutlet weak var tfEmailRegister: UITextField!
    @IBOutlet weak var tfPasswordRegister: UITextField!

    // MARK: - Properties
    private let db = Firestore.firestore()  // Firestore veritabanı referansı

    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    // MARK: - UI Setup
    private func setupUI() {
        let placeholderColor = UIColor(red: 99.0 / 255.0, green: 99.0 / 255.0, blue: 102.0 / 255.0, alpha: 0.6)

        tfName.setCustomPlaceholder("Ad", color: placeholderColor)
        tfSurname.setCustomPlaceholder("Soyad", color: placeholderColor)
        tfEmailRegister.setCustomPlaceholder("Email", color: placeholderColor)
        tfPasswordRegister.setCustomPlaceholder("Şifre", color: placeholderColor)

        [tfName, tfSurname, tfEmailRegister, tfPasswordRegister].forEach {
            $0?.addCustomBottomBorder(color: .lightGray, width: 1.0)
        }
    }

    // MARK: - Actions
    @IBAction func registerUser(_ sender: UIButton) {
        guard let name = tfName.text, !name.isEmpty,
              let surname = tfSurname.text, !surname.isEmpty,
              let email = tfEmailRegister.text, !email.isEmpty,
              let password = tfPasswordRegister.text, !password.isEmpty else {
            showAlert(title: "Hata", message: "Lütfen tüm alanları doldurun.")
            return
        }

        createUser(email: email, password: password, name: name, surname: surname)
    }

    // MARK: - Firebase Methods
    private func createUser(email: String, password: String, name: String, surname: String) {
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] authResult, error in
            guard let self = self else { return }

            if let error = error {
                self.showAlert(title: "Kayıt Hatası", message: error.localizedDescription)
                return
            }

            guard let userID = authResult?.user.uid else { return }
            self.saveUserData(userID: userID, name: name, surname: surname, email: email)
        }
    }

    private func saveUserData(userID: String, name: String, surname: String, email: String) {
        let userData: [String: Any] = [
            "firstName": name,
            "lastName": surname,
            "email": email,
            "uid": userID
        ]

        db.collection("users").document(userID).setData(userData) { [weak self] error in
            guard let self = self else { return }

            if let error = error {
                self.showAlert(title: "Hata", message: "Veritabanına kaydedilirken hata: \(error.localizedDescription)")
            } else {
                self.showAlert(title: "Başarılı", message: "Kayıt başarılı!") {
                    self.dismiss(animated: true)
                }
            }
        }
    }

    // MARK: - Helper Methods
    private func showAlert(title: String, message: String, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Tamam", style: .default) { _ in
            completion?()
        })
        present(alert, animated: true)
    }
}

// MARK: - UITextField Extension (Placeholder Ayarı)
extension UITextField {
    func setCustomPlaceholder(_ text: String, color: UIColor) {
        attributedPlaceholder = NSAttributedString(
            string: text,
            attributes: [NSAttributedString.Key.foregroundColor: color]
        )
    }
}

// MARK: - UIView Extension (Alt Sınır Ekleme)
extension UIView {
    func addCustomBottomBorder(color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(
            x: 0,
            y: frame.size.height - width,
            width: frame.size.width,
            height: width
        )
        layer.addSublayer(border)
    }
}
