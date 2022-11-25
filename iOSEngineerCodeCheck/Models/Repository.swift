//
//  Repository.swift
//  iOSEngineerCodeCheck
//
//  Created by rrbox on 2022/11/20.
//

import Foundation

/// リポジトリ JSON の owner のデータをデコードできる構造体です.
struct Owner: Codable {
    var login: String
    var avatarUrl: String
}

/// リポジトリ JSON をデコードできる構造体です.
struct Repository: Codable {
    var name: String
    var fullName: String
    var language: String?
    var stargazersCount: Int
    var watchersCount: Int
    var forksCount: Int
    var openIssuesCount: Int
    var owner: Owner
}

/// リポジトリ配列 JSON をデコードできる構造体です.
struct Repositories: Codable {
    var items: [Repository] = []
}

// Repositories に Downloadable を実装します.
extension Repositories: DefaultDownloadable {
    static func convert(from data: Data) throws -> Repositories {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let result = try decoder.decode(Repositories.self, from: data)
        return result
    }
}
