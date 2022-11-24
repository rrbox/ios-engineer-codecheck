//
//  ErrorAlert+Search.swift
//  iOSEngineerCodeCheck
//
//  Created by rrbox on 2022/11/24.
//

import UIKit

extension RepositorySearchError: PresentableError {
    func show(in parent: UIViewController) {
        if self == .repositoriesArrayEmptyError {
            parent.present(ButtonLessErrorAlert().create(
                title: "検索結果",
                message: "0件"), animated: true)
        } else {
            let alert = ButtonLessErrorAlert().create(message: self.localizedDescription)
            parent.present(alert, animated: true)
        }
    }
}
