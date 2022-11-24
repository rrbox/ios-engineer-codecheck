//
//  NetWork.swift
//  iOSEngineerCodeCheck
//
//  Created by rrbox on 2022/11/21.
//

import Foundation

enum GitHubAPI {
    /// リポジトリを検索するクエリを生成するメソッドです.
    static func getSearchRepositoriesURL(query: String) -> URL? {
        URL(string: "https://api.github.com/search/repositories?q=\(query)")
    }
}
