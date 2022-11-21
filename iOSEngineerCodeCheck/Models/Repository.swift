//
//  Repository.swift
//  iOSEngineerCodeCheck
//
//  Created by rrbox on 2022/11/20.
//

import Foundation

struct Owner: Codable {
    var avatarUrl: String
}

struct Repository: Codable {
    var fullName: String
    var language: String?
    var stargazersCount: Int
    var watchersCount: Int
    var forksCount: Int
    var openIssuesCount: Int
    var owner: Owner
}

struct Repositories: Codable {
    var items: [Repository] = []
}

extension Repositories {
    
    /// URL で通信し, リポジトリの値を取得します.
    static func load(from url: URL) async throws -> Repositories {
        let (data, _) = try await URLSession.shared.data(for: URLRequest(url: url))
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let result = try decoder.decode(Repositories.self, from: data)
        return result
    }
}

struct RepositoryDetailOutput {
    var fullName: String
    var language: String
    var stargazersCount: String
    var watchersCount: String
    var forksCount: String
    var openIssuesCount: String
    var ownerImageURL: URL
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
        self.ownerImageURL = url
    }
}
