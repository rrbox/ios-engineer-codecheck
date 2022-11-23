//
//  RepositoryDetail.swift
//  iOSEngineerCodeCheck
//
//  Created by rrbox on 2022/11/22.
//

import UIKit

extension UIImage: OptionalDonwloadable {
    static func convert(from data: Data) throws -> Self? {
        Self(data: data)
    }
}

struct RepositoryDetailOutput {
    var fullName: String
    var language: String
    var stargazersCount: String
    var watchersCount: String
    var forksCount: String
    var openIssuesCount: String
    var ownerImageURL: ObjectDownload<UIImage>
}

extension RepositoryDetailOutput {
    init(from repository: Repository) throws {
        self.fullName = repository.fullName
        self.language = "Written in \(repository.language ?? "other")"
        self.stargazersCount = "\(repository.stargazersCount) stars"
        self.watchersCount = "\(repository.watchersCount) watchers"
        self.forksCount = "\(repository.forksCount) forks"
        self.openIssuesCount = "\(repository.openIssuesCount) open issues"
        guard let url = URL(string: repository.owner.avatarUrl) else {
            throw RepositoryLoadError.imageURLLoadFailed
        }
        self.ownerImageURL = ObjectDownload(url: url)
    }
}
