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

/// 一つの OK ボタンを備えたエラーアラートを作成する構造体です.
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

/// ボタンがなく, 時間で消えるエラーアラートを作成する構造体です.
struct ButtonLessErrorAlert: ErrorAlertCreate {
    func create(title: String? = "Error", message: String? = "description") -> UIAlertController {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            alert.dismiss(animated: true)
        }
        return alert
    }
}

/// エラーを表示可能にするプロトコルです.
protocol PresentableError: Error {
    
    /// エラーを ``SingleButtonErrorAlert`` か ``ButtonLessErrorAlert`` で parent に表示します.
    func show(in parent: UIViewController)
    
}

/// ``PresentableError`` が実装されたエラーを表示する機能を提供する構造体です.
struct ErrorAlert<E: PresentableError> {
    var error: E
    func show(in parent: UIViewController) {
        self.error.show(in: parent)
    }
    
    init(error: E) {
        self.error = error
    }
}
