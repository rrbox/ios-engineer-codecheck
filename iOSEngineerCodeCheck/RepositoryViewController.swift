//
//  RepositoryViewController.swift
//  iOSEngineerCodeCheck
//
//  Created by 史 翔新 on 2020/04/21.
//  Copyright © 2020 YUMEMI Inc. All rights reserved.
//

import UIKit

/// ``RepositoryViewController`` で画像を取得する際に使用されるエラーです.
enum RepositoryLoadError: Error {
    case ownerDataLoadFailed
    case imageURLLoadFailed
}

/// 特定のリポジトリについての情報を表示する ViewController です.
class RepositoryViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var languageLabel: UILabel!
    @IBOutlet weak var starsLabel: UILabel!
    @IBOutlet weak var watchersLabel: UILabel!
    @IBOutlet weak var forksLabel: UILabel!
    @IBOutlet weak var issuesLabel: UILabel!
    
    var repositorySearch: RepositorySearchController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // リポジトリ検索コントローラから, 選択したリポジトリを取得します.
        let repository = repositorySearch.repositories[repositorySearch.index]
        
        // リポジトリの要素を対応するプロパティで表示します.
        titleLabel.text = repository["full_name"] as? String
        languageLabel.text = "Written in \(repository["language"] as? String ?? "")"
        starsLabel.text = "\(repository["stargazers_count"] as? Int ?? 0) stars"
        watchersLabel.text = "\(repository["wachers_count"] as? Int ?? 0) watchers"
        forksLabel.text = "\(repository["forks_count"] as? Int ?? 0) forks"
        issuesLabel.text = "\(repository["open_issues_count"] as? Int ?? 0) open issues"
        
        Task {
            try? await self.present(image: self.getImage(url: self.getURL(from: repository)))
        }
        
    }
    
    /// リポジトリデータの辞書から, Owner のアバター画像の URL を取得します.
    /// - Parameter repository: JSON から生成したリポジトリデータの辞書です.
    /// - Returns: Owner のアバター画像の URL です.
    func getURL(from repository: [String: Any]) throws -> URL {
        
        // リポジトリからアバター画像を取り出すために, owner key のオブジェクトを取り出します.
        guard let owner = repository["owner"] as? [String: Any] else {
            throw RepositoryLoadError.ownerDataLoadFailed
        }
        
        guard let imageURLString = owner["avatar_url"] as? String else {
            throw RepositoryLoadError.imageURLLoadFailed
        }
        guard let result = URL(string: imageURLString) else {
            throw RepositoryLoadError.imageURLLoadFailed
        }
        return result
    }
    
    /// URL から画像オブジェクトを作成します.
    /// - Parameter url: 画像の URL を指定してください.
    /// - Returns: UIImage を作成します.
    func getImage(url: URL) async throws -> UIImage? {
        let (data, _) = try await URLSession.shared.data(for: URLRequest(url: url))
        return UIImage(data: data)
    }
    
    /// ViewController に画像を表示します.
    /// - Parameter image: UIImage
    func present(image: UIImage?) {
        self.imageView.image = image ?? UIImage(systemName: "person.circle")
    }
    
}
