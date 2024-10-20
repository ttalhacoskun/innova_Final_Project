//
//  FavoriProductRepostory.swift
//  ECommerceApp
//
//  Created by Talha Coşkun on 19.10.2024.
//

import Foundation
import RxSwift

class FavoriProductRepository {

    // MARK: - Properties
    var favoriProductList = BehaviorSubject<[FavoriProduct]>(value: [])
    private let db: FMDatabase?

    // MARK: - Initialization
    init() {
        let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        let databaseURL = URL(fileURLWithPath: documentDirectory).appendingPathComponent("favori.db")
        db = FMDatabase(path: databaseURL.path)
        print("Veritabanı Yolu: \(databaseURL.path)")
        createTableIfNeeded()
    }

    // MARK: - Private Methods

    /// Veritabanında tabloyu oluşturur.
    private func createTableIfNeeded() {
        guard openDatabase() else { return }

        let createTableQuery = """
        CREATE TABLE IF NOT EXISTS favori (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            ad TEXT NOT NULL,
            resim TEXT,
            kategori TEXT,
            fiyat INTEGER,
            marka TEXT,
            favori INTEGER
        );
        """

        executeQuery(query: createTableQuery, message: "Favori tablosu oluşturuldu veya zaten mevcut.")
        closeDatabase()
    }

    /// Veritabanını açar.
    private func openDatabase() -> Bool {
        guard db?.open() == true else {
            print("Veritabanı açılamadı.")
            return false
        }
        return true
    }

    /// Veritabanını kapatır.
    private func closeDatabase() {
        db?.close()
    }

    /// SQL sorgusunu çalıştırır ve hata durumunda loglama yapar.
    private func executeQuery(query: String, values: [Any]? = nil, message: String? = nil) {
        do {
            try db?.executeUpdate(query, values: values)
            if let message = message { print(message) }
        } catch {
            print("SQL Hatası: \(error.localizedDescription)")
        }
    }

    // MARK: - Public Methods

    /// Favorilere ürün ekler.
    func favoriEkle(ad: String, resim: String, kategori: String, fiyat: Int, marka: String, favori: Int) {
        guard openDatabase() else { return }

        let insertQuery = """
        INSERT INTO favori (ad, resim, kategori, fiyat, marka, favori)
        VALUES (?, ?, ?, ?, ?, ?);
        """
        executeQuery(query: insertQuery, values: [ad, resim, kategori, fiyat, marka, favori], message: "\(ad) favorilere eklendi.")
        favoriUrunleriYukle()
        closeDatabase()
    }

    /// Favori ürünleri veritabanından yükler.
    func favoriUrunleriYukle() {
        guard openDatabase() else { return }

        let selectQuery = "SELECT * FROM favori;"
        var liste = [FavoriProduct]()

        do {
            let resultSet = try db?.executeQuery(selectQuery, values: nil)
            while resultSet?.next() == true {
                let product = FavoriProduct(
                    id: Int(resultSet?.int(forColumn: "id") ?? 0),
                    ad: resultSet?.string(forColumn: "ad") ?? "",
                    resim: resultSet?.string(forColumn: "resim") ?? "",
                    kategori: resultSet?.string(forColumn: "kategori") ?? "",
                    fiyat: Int(resultSet?.int(forColumn: "fiyat") ?? 0),
                    marka: resultSet?.string(forColumn: "marka") ?? "",
                    favori: Int(resultSet?.int(forColumn: "favori") ?? 0)
                )
                liste.append(product)
            }
            favoriProductList.onNext(liste)
        } catch {
            print("Veri yükleme hatası: \(error.localizedDescription)")
        }

        closeDatabase()
    }

    /// Veritabanından favori ürünü siler.
    func favoriKaldir(id: Int) {
        guard openDatabase() else { return }

        let deleteQuery = "DELETE FROM favori WHERE id = ?;"
        executeQuery(query: deleteQuery, values: [id], message: "Ürün id: \(id) favorilerden silindi.")
        favoriUrunleriYukle()
        closeDatabase()
    }
}
