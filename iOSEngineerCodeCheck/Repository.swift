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
