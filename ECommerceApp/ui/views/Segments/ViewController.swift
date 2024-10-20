//
//  ViewController.swift
//  ECommerceApp
//
//  Created by Talha Coşkun on 19.10.2024.
//
import UIKit

class ViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var segmentedOutlet: UISegmentedControl!
    @IBOutlet weak var loginSegmentView: UIView!
    @IBOutlet weak var registerSegmentView: UIView!
    @IBOutlet weak var ecommerceLabel: UILabel!

    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        bringLoginViewToFront()
    }

    // MARK: - UI Configuration
    /// UI elemanlarının başlangıç yapılandırmasını yapar.
    private func configureUI() {
        // Segment kontrol metin rengi
        let titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        segmentedOutlet.setTitleTextAttributes(titleTextAttributes, for: .normal)

        // Navigasyon çubuğunu gizle
        navigationController?.setNavigationBarHidden(true, animated: true)
        navigationItem.hidesBackButton = true
    }

    /// Login görünümünü öne getirir.
    private func bringLoginViewToFront() {
        view.bringSubviewToFront(loginSegmentView)
    }

    // MARK: - Actions
    @IBAction func segmentAction(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            view.bringSubviewToFront(loginSegmentView)
        case 1:
            view.bringSubviewToFront(registerSegmentView)
        default:
            break
        }
    }
}
