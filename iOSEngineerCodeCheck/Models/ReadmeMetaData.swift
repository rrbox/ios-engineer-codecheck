//
//  ReadmeMetaData.swift
//  iOSEngineerCodeCheck
//
//  Created by rrbox on 2022/11/25.
//

import Foundation

/// README.md をダウンロードする際に使用する構造体です. ダウンロードは ``ObjectDownload`` を使用します.
struct ReadmeData {
    var body: String
}

extension ReadmeData: OptionalDonwloadable {
    static func convert(from data: Data) throws -> ReadmeData? {
        guard let body = String(data: data, encoding: .utf8) else { return nil }
        return ReadmeData(body: body)
    }
}

struct Sanitized {
    let body: String
}

extension ReadmeData {
    func sanitized() -> Sanitized {
        return Sanitized(body: self.body
            .replacingOccurrences(of: "\n", with: "\\n")
            .replacingOccurrences(of: "\'", with: "\\'")
            .replacingOccurrences(of: "\"", with: "\\\""))
        
    }
    
}

struct ReadmeInjectionCommand {
    let body: String
}

extension Sanitized {
    func injectionCommand() -> ReadmeInjectionCommand {
        return ReadmeInjectionCommand(body: "insert('\(self.body)');")
    }
}

struct ReadmeMetaData: Decodable {
    var downloadURL: ObjectDownload<ReadmeData>
    
    enum CodingKeys: String, CodingKey {
        case downloadURL = "download_url"
    }
    
    enum DecodeError: Error {
        case decodeFailed
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        guard let url = URL(string: try container.decode(String.self, forKey: .downloadURL)) else {
            throw DecodeError.decodeFailed
        }
        self.downloadURL = .init(url: url)
    }
}

extension ReadmeMetaData: DefaultDownloadable {
    static func convert(from data: Data) throws -> ReadmeMetaData {
        let decoder = JSONDecoder()
        return try decoder.decode(ReadmeMetaData.self, from: data)
    }
}
