//
//  ReadmeMetaData.swift
//  iOSEngineerCodeCheck
//
//  Created by rrbox on 2022/11/25.
//

import Foundation

struct ReadmeData {
    var body: String
}

extension ReadmeData: OptionalDonwloadable {
    static func convert(from data: Data) throws -> ReadmeData? {
        guard let body = String(data: data, encoding: .utf8) else { return nil }
        return ReadmeData(body: body)
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

