//
//  ObjectDownload.swift
//  iOSEngineerCodeCheckTests
//
//  Created by rrbox on 2022/11/23.
//

import XCTest
@testable import iOSEngineerCodeCheck

extension String: OptionalDonwloadable {
    public static func convert(from data: Data) throws -> String? {
        String(data: data, encoding: .utf8)
    }
}

final class ObjectDownloadTests: XCTestCase {
    
    var data: String?
    
    override func setUp() {
        self.data = "test"
    }
    
    func testCreateObject() throws {
        guard let url = URL(string: "https://example") else {
            XCTFail()
            return
        }
        let object = ObjectDownload<String>(url: url)
        
    }

}
