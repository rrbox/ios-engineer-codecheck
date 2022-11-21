//
//  RepositoryView.swift
//  iOSEngineerCodeCheck
//
//  Created by rrbox on 2022/11/21.
//

import UIKit

/// ``RepositoryViewController`` で画像を取得する際に使用されるエラーです.
enum RepositoryLoadError: Error {
    case ownerDataLoadFailed
    case imageURLLoadFailed
}

class RepositoryView: UIView {
    
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var languageLabel: UILabel!
    @IBOutlet private weak var starsLabel: UILabel!
    @IBOutlet private weak var watchersLabel: UILabel!
    @IBOutlet private weak var forksLabel: UILabel!
    @IBOutlet private weak var issuesLabel: UILabel!
    
    /// リポジトリデータの辞書から, Owner のアバター画像の URL を取得します.
    /// - Parameter repository: JSON から生成したリポジトリデータの辞書です.
    /// - Returns: Owner のアバター画像の URL です.
    func getURL(from repository: Repository) throws -> URL {
        
        // リポジトリからアバター画像を取り出すために, owner key のオブジェクトを取り出します.
        guard let result = URL(string: repository.owner.avatarUrl) else {
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
    func present(image: UIImage?, defaultImage: UIImage? = UIImage(systemName: "exclamationmark.square.fill")) {
        self.imageView.image = image ?? defaultImage
    }
    
    /// リポジトリデータを表示するメソッドです.
    func present(repository: Repository) {
        // リポジトリの要素を対応するプロパティで表示します.
        self.titleLabel.text = repository.fullName
        self.languageLabel.text = "Written in \(repository.language ?? "other")"
        self.starsLabel.text = "\(repository.stargazersCount) stars"
        self.watchersLabel.text = "\(repository.watchersCount) watchers"
        self.forksLabel.text = "\(repository.forksCount) forks"
        self.issuesLabel.text = "\(repository.openIssuesCount) open issues"
        
        Task {
            try? await self.present(
                image: self.getImage(url: self.getURL(from: repository)),
                defaultImage: UIImage(systemName: "person.circle"))
        }
    }
}
