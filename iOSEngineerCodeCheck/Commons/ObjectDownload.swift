//
//  ObjectDownload.swift
//  iOSEngineerCodeCheck
//
//  Created by rrbox on 2022/11/24.
//

import Foundation

protocol Downloadable {}

protocol DefaultDownloadable: Downloadable {
    static func convert(from data: Data) throws -> Self
}

protocol OptionalDonwloadable: Downloadable {
    static func convert(from data: Data) throws -> Self?
}

struct ObjectDownload<T: Downloadable> {
    private let url: URL
    
    init(url: URL) {
        self.url = url
    }
    
}

extension ObjectDownload where T: DefaultDownloadable {
    func downloaded(_ session: URLSession = .shared) async throws -> T {
        let (data, _) = try await session.data(for: URLRequest(url: url))
        return try T.convert(from: data)
    }
}

extension ObjectDownload where T: OptionalDonwloadable {
    func downloaded(_ session: URLSession = .shared) async throws -> T? {
        let (data, _) = try await session.data(for: URLRequest(url: url))
        return try T.convert(from: data)
    }
}
