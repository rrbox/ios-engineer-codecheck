//
//  MarkdownViewController.swift
//  iOSEngineerCodeCheck
//
//  Created by rrbox on 2022/11/25.
//

import WebKit

/// README ファイルを表示する際に想定されるエラーです.
enum ReadmeViewError: Error {
    case urlCreateFailed
    case jsCreateFailed
}

extension NSError: PresentableError {
    func show(in parent: UIViewController) {
        parent.present(ButtonLessErrorAlert().create(message: self.localizedDescription), animated: true)
    }
    
}

/// Markdown 形式のデータを WKWebView で表示するコントローラです.
class MarkdownViewController: UIViewController, WKNavigationDelegate {
    
    @IBOutlet weak var webView: WKWebView!
    var inputRepository: Repository?
    
    /// HTML にリポジトリの README.md を埋め込むための JavaScript の関数を作成します.
    func createJS(from repository: Repository) async throws -> ReadmeInjectionCommand {
        guard let metadataURL = GitHubAPI.getReadmeURL(query: repository) else {
            throw ReadmeViewError.urlCreateFailed
        }
        guard let markdown = try await ObjectDownload<ReadmeMetaData>(url: metadataURL)
            .downloaded()
            .downloadURL
            .downloaded() else {
            throw ReadmeViewError.jsCreateFailed
        }
        
        let command = markdown.sanitized().injectionCommand()
            
        return command
        
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
    
    /// HTML 読み込み後の処理です. JavaScript を実行して README.md を描画します.
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        guard let repository = self.inputRepository else { return }
        Task {
            do {
                let js = try await self.createJS(from: repository)
                DispatchQueue.main.async { [weak self] in
                    self?.webView.execute(js) {
                        if let error = $1 as? NSError {
                            ErrorAlert(error: error).show(in: self!)
                            print(error)
                        }
                    }
                }
            } catch let error as NSError {
                ErrorAlert(error: error).show(in: self)
            }
        }
    }
    
}
