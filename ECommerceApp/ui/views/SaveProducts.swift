//
//  SaveProducts.swift
//  ECommerceApp
//
//  Created by Talha Coşkun on 7.10.2024.
//

import UIKit

class SaveProducts: UIViewController {

    @IBOutlet weak var tfKisiTel: UITextField!
    @IBOutlet weak var tfKisiAd: UITextField!
    
    var viewModel = SaveProductsViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    

    @IBAction func butonKaydet(_ sender: Any) {
      /*  if let kisi_adi = tfKisiAd.text, let kisi_tel = tfKisiTel.text {
            viewModel.kaydet(kisi_ad: kisi_adi, kisi_tel: kisi_tel)
        }*/
    }
    
    
}
