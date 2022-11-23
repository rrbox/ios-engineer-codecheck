//
//  RepositoryDetailTests.swift
//  iOSEngineerCodeCheckTests
//
//  Created by rrbox on 2022/11/23.
//

import XCTest
@testable import iOSEngineerCodeCheck

final class RepositoryDetailTests: XCTestCase {
    let repository = Repository(fullName: "test",
                                stargazersCount: 0,
                                watchersCount: 1,
                                forksCount: 2,
                                openIssuesCount: 3,
                                owner: Owner(avatarUrl: "https://example"))
    
    func testOutputConvert() throws {
        let output = try RepositoryDetailOutput(from: self.repository)
        XCTAssertEqual(output.fullName, repository.fullName)
        XCTAssertEqual(output.language, "Written in \(self.repository.language ?? "other")")
        XCTAssertEqual(output.stargazersCount, "\(self.repository.stargazersCount) stars")
        XCTAssertEqual(output.watchersCount, "\(self.repository.watchersCount) watchers")
        XCTAssertEqual(output.forksCount, "\(self.repository.forksCount) forks")
        XCTAssertEqual(output.openIssuesCount, "\(self.repository.openIssuesCount) open issues")
    }
}
