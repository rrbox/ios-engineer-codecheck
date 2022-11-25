//
//  ObjectDownload.swift
//  iOSEngineerCodeCheck
//
//  Created by rrbox on 2022/11/24.
//

import Foundation

protocol Downloadable {}

/// 通信でオブジェクトをダウンロード可能にします. ダウンロード後は非オプショナル型で受け取ることができます.
protocol DefaultDownloadable: Downloadable {
    static func convert(from data: Data) throws -> Self
}

/// 通信でオブジェクトをダウンロード可能にします. ダウンロード後はオプショナル型で受け取ることができます.
protocol OptionalDonwloadable: Downloadable {
    static func convert(from data: Data) throws -> Self?
}

/// ``Downloadable`` に準拠したオブジェクトをダウンロードするメソッドと URL を持った構造体です.
struct ObjectDownload<T: Downloadable> {
    private let url: URL
    
    init(url: URL) {
        self.url = url
    }
    
}

extension ObjectDownload where T: DefaultDownloadable {
    
    /// オブジェクトが ``DefaultDownloadable`` の時, 非オプショナル型で T を受け取ることができます.
    func downloaded(_ session: URLSession = .shared) async throws -> T {
        let (data, _) = try await session.data(for: URLRequest(url: url))
        return try T.convert(from: data)
    }
    
}

extension ObjectDownload where T: OptionalDonwloadable {
    
    /// オブジェクトが ``OptionalDonwloadable`` の時, 非オプショナル型で T を受け取ることができます.
    func downloaded(_ session: URLSession = .shared) async throws -> T? {
        let (data, _) = try await session.data(for: URLRequest(url: url))
        return try T.convert(from: data)
    }
    
}
