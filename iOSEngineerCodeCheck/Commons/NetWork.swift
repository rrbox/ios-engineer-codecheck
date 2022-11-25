//
//  NetWork.swift
//  iOSEngineerCodeCheck
//
//  Created by rrbox on 2022/11/21.
//

import Foundation

/// GitHub API の URL を提供する名前空間です.
enum GitHubAPI {
    /// リポジトリを検索するクエリを生成するメソッドです.
    static func getSearchRepositoriesURL(query: String) -> URL? {
        URL(string: "https://api.github.com/search/repositories?q=\(query)")
    }
    
    /// README.md を取得する際に使用する関数です.
    static func getReadmeURL(query: Repository) -> URL? {
        URL(string: "https://api.github.com/repos/\(query.owner.login)/\(query.name)/readme")
    }
}
