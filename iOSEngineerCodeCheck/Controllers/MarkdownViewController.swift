//
//  MarkdownViewController.swift
//  iOSEngineerCodeCheck
//
//  Created by rrbox on 2022/11/25.
//

import WebKit

enum ReadmeViewError: Error {
    case urlCreateFailed
    case jsCreateFailed
}

class MarkdownViewController: UIViewController, WKNavigationDelegate {
    
    @IBOutlet weak var webView: WKWebView!
    var inputRepository: Repository?
    
    func createJS(from repository: Repository) async throws -> String {
        guard let metadataURL = GitHubAPI.getReadmeURL(query: repository) else {
            throw ReadmeViewError.urlCreateFailed
        }
        guard let markdown = try await ObjectDownload<ReadmeMetaData>(url: metadataURL)
            .downloaded()
            .downloadURL
            .downloaded()?
            .body else {
            throw ReadmeViewError.jsCreateFailed
        }
        let js = "insert('\(markdown.replacingOccurrences(of: "\n", with: "\\n"))');"
        //        let js = "insert('\(markdown)');"
        return js
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.webView.navigationDelegate = self
        guard let url = Bundle.main.url(forResource: "md", withExtension: "html") else {
            fatalError()
        }
        let req = URLRequest(url: url)
        self.webView.load(req)
        
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        guard let repository = self.inputRepository else { return }
        Task {
            do {
                let js = try await self.createJS(from: repository)
                DispatchQueue.main.async { [weak self] in
                    self?.webView.evaluateJavaScript(js)
                }
            } catch {
                fatalError("\(error)")
            }
        }
    }
    
}
