//
//  RepositoryDetailTests.swift
//  iOSEngineerCodeCheckTests
//
//  Created by rrbox on 2022/11/23.
//

import XCTest
@testable import iOSEngineerCodeCheck

final class RepositoryDetailTests: XCTestCase {
    let repository = Repository(name: "test_repository",
                                fullName: "test",
                                stargazersCount: 0,
                                watchersCount: 1,
                                forksCount: 2,
                                openIssuesCount: 3,
                                owner: Owner(login: "test_user",
                                             avatarUrl: "https://example"))
    
    func testOutputConvert() throws {
        let output = try RepositoryDetailOutput(from: self.repository)
        XCTAssertEqual(output.title, repository.name)
        XCTAssertEqual(output.owner, repository.owner.login)
        XCTAssertEqual(output.language, "\(self.repository.language ?? "other")")
        XCTAssertEqual(output.stargazersCount, "\(self.repository.stargazersCount)")
        XCTAssertEqual(output.watchersCount, "\(self.repository.watchersCount)")
        XCTAssertEqual(output.forksCount, "\(self.repository.forksCount)")
        XCTAssertEqual(output.openIssuesCount, "\(self.repository.openIssuesCount)")
    }
}
