//
//  Search.swift
//  iOSEngineerCodeCheck
//
//  Created by rrbox on 2022/11/23.
//

import Foundation

protocol SearchProtocol {
    associatedtype ResultType
    func search(word: String?) async throws -> ResultType
}

enum RepositorySearchError: Error {
    case percentEncodingFailed
    case emptyWord
    case urlCreationFailed
    case repositoriesArrayEmptyError
}

extension SearchProtocol where ResultType == Repositories {
    func search(word: String?) async throws -> Repositories {
        // 検索ワードにパーセントエンコーディングをかけます.
        guard let word = word?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            throw RepositorySearchError.percentEncodingFailed
        }
        
        // 入力がなかった場合はリポジトリデータを取得しません.
        guard word.count != 0 else {
            throw RepositorySearchError.emptyWord
        }
        
        // URL を作成し, リポジトリの一覧の JSON を GET します.
        guard let url = GitHubAPI.getSearchRepositoriesURL(query: word) else {
            throw RepositorySearchError.urlCreationFailed
        }
        
        let repositories = try await ObjectDownload<Repositories>(url: url).downloaded()
        
        guard !repositories.items.isEmpty else {
            throw RepositorySearchError.repositoriesArrayEmptyError
        }
        
        return repositories
    }

}

