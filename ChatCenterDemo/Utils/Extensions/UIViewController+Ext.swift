//
// UIViewController+Ext.swift
// ChatCenterDemo
//
// Copyright © 2025 edna. All rights reserved.
//

import UIKit

extension UIViewController {
    func validErrorFields() {
        alert(title: "Ошибка", message: "Проверьте правильность заполнения всех полей")
    }

    func alert(title: String, message: String = "") {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "ok",
                                     style: .default, handler: nil)
        alertController.addAction(OKAction)
        present(alertController, animated: true, completion: nil)
    }
}
