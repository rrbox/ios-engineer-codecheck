//
//  RepositoryTableView.swift
//  iOSEngineerCodeCheck
//
//  Created by rrbox on 2022/11/21.
//

import UIKit

/// リポジトリを一覧表示するためのセルです.
class RepositoryCell: UITableViewCell {
    
    /// リポジトリをこのセルに表示します.
    func present(repository: Repository, cellForRowAt indexPath: IndexPath) {
        self.tag = indexPath.row
        var content = UIListContentConfiguration.valueCell()
        content.text = repository.fullName
        content.secondaryText = repository.language
        self.contentConfiguration = content
    }
    
}

/// リポジトリを一覧で表示します.
class RepositoryTableView: UITableView, UITableViewDataSource {
    private var repositories: [Repository] = []
    
    /// リポジトリの配列をテーブルにマッピングします.
    func present(repositories: [Repository]) {
        self.repositories = repositories
        DispatchQueue.main.async {
            self.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.repositories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = RepositoryCell()
        let repository = self.repositories[indexPath.row]
        cell.present(repository: repository, cellForRowAt: indexPath)
        return cell
    }
}
