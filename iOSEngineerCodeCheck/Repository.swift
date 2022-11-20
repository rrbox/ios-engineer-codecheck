//
//  Repository.swift
//  iOSEngineerCodeCheck
//
//  Created by rrbox on 2022/11/20.
//

import Foundation

struct Owner: Codable {
    var avatarUrl: String = ""
}

struct Repository: Codable {
    var fullName: String = ""
    var language: String = ""
    var stargazersCount: Int = 0
    var watchersCount: Int = 0
    var forksCount: Int = 0
    var openIssuesCount: Int = 0
    var owner: Owner
}

struct Repositories: Codable {
    var items: [Repository] = []
}
