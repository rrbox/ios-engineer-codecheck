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

protocol Downloadable {
    static func convert(from data: Data) throws -> Self
}

struct ObjectDownload<T: Downloadable> {
    private let url: URL
    
    init(url: URL) {
        self.url = url
    }
    
    func downloaded() async throws -> T {
        let (data, _) = try await URLSession.shared.data(for: URLRequest(url: url))
        return try T.convert(from: data)
    }
}
