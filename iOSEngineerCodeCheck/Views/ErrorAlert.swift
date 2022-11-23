//
//  ErrorAlert.swift
//  iOSEngineerCodeCheck
//
//  Created by rrbox on 2022/11/23.
//

import UIKit

protocol ErrorAlertCreate {
    func create(title: String?,
                message: String?) -> UIAlertController
}

struct SingleButtonErrorAlert: ErrorAlertCreate {
    func create(title: String? = "Error", message: String? = "description") -> UIAlertController {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert)
        alert.addAction(UIAlertAction(
            title: "OK",
            style: .default))
        return alert
    }
}

struct ButtonLessErrorAlert: ErrorAlertCreate {
    func create(title: String? = "Error", message: String? = "description") -> UIAlertController {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            alert.dismiss(animated: true)
        }
        return alert
    }
}
