//
//  RepositoryDetail.swift
//  iOSEngineerCodeCheck
//
//  Created by rrbox on 2022/11/22.
//

import UIKit

// UIImage に Downloadable を実装します.
extension UIImage: OptionalDonwloadable {
    static func convert(from data: Data) throws -> Self? {
        Self(data: data)
    }
}

/// Repository を ``RepositoryView`` で表示する際に使用する構造体です.
struct RepositoryDetailOutput {
    var title: String
    var owner: String
    var language: String
    var stargazersCount: String
    var watchersCount: String
    var forksCount: String
    var openIssuesCount: String
    var ownerImageURL: ObjectDownload<UIImage>
}

extension RepositoryDetailOutput {
    init(from repository: Repository) throws {
        self.title = repository.name
        self.owner = repository.owner.login
        self.language = "\(repository.language ?? "other")"
        self.stargazersCount = "\(repository.stargazersCount)"
        self.watchersCount = "\(repository.watchersCount)"
        self.forksCount = "\(repository.forksCount)"
        self.openIssuesCount = "\(repository.openIssuesCount)"
        guard let url = URL(string: repository.owner.avatarUrl) else {
            throw RepositoryLoadError.imageURLLoadFailed
        }
        self.ownerImageURL = ObjectDownload(url: url)
    }
}
