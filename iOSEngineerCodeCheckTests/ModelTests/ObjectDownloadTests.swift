//
//  ObjectDownload.swift
//  iOSEngineerCodeCheckTests
//
//  Created by rrbox on 2022/11/23.
//

import XCTest
@testable import iOSEngineerCodeCheck

final class URLTestSession: URLProtocol {
    
    static var responses: [URL: Data] = [
        :
    ]
    
    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    override func startLoading() {
        if let url = self.request.url,
           let data = Self.responses[url] {
            // レスポンスを作って
            let response = HTTPURLResponse(
                url: url,
                statusCode: 200,
                httpVersion: "HTTP/2",
                headerFields: nil
            )!
            
            // レスポンスを受信したことをクライアントに通知
            self.client?.urlProtocol(
                self,
                didReceive: response,
                cacheStoragePolicy: .notAllowed
            )
            
            // データをクライアントに通知
            self.client?.urlProtocol(
                self,
                didLoad: data
            )
        }
        // ローディングの終了を通知
        client?.urlProtocolDidFinishLoading(self)
    }
    
    override func stopLoading() {
        
    }
    
}

extension String: OptionalDonwloadable {
    public static func convert(from data: Data) throws -> String? {
        String(data: data, encoding: .utf8)
    }
}

final class ObjectDownloadTests: XCTestCase {
    
    var data: String?
    var session: URLSession?
    
    override func setUp() {
        self.data = "test"
        URLTestSession.responses = [
            URL(string: "https://sample.com/sample_1")!: "sample_1".data(using: .utf8)!,
            URL(string: "https://sample.com/sample_2")!: "sample_2".data(using: .utf8)!
        ]
        // モックをConfigに登録
        let config = URLSessionConfiguration.ephemeral    // ephemeralでなく、defaultでもよい
        config.protocolClasses = [URLTestSession.self]
        self.session = URLSession(configuration: config)
    }
    
    func testCreateObject() async throws {
        guard let url = URL(string: "https://sample.com/sample_1") else {
            XCTFail()
            return
        }
        do {
            guard let session = self.session else {
                XCTFail()
                return
            }
            guard let object = try await ObjectDownload<String>(url: url).downloaded(session) else {
                XCTFail()
                return
            }
            XCTAssertEqual(object, "sample_1")
        } catch {
            XCTFail("\(error)")
        }
        
        guard let url = URL(string: "https://sample.com/sample_2") else {
            XCTFail()
            return
        }
        do {
            guard let session = self.session else {
                XCTFail()
                return
            }
            guard let object = try await ObjectDownload<String>(url: url).downloaded(session) else {
                XCTFail()
                return
            }
            XCTAssertEqual(object, "sample_2")
        } catch {
            XCTFail("\(error)")
        }
        
        
    }
    
}

final class DownloadableTest: XCTestCase {
    
    var data: Data?
    
    override func setUp() {
        self.data = "test".data(using: .utf8)
    }
    
    func testCreateObject() throws {
        guard let data = self.data else {
            XCTFail("Data の生成に失敗しています.")
            return
        }
        
        let testString = try String.convert(from: data)
        XCTAssertNotNil(testString)
        XCTAssertEqual(testString!, "test")
    }
    
}
