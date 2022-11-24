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
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var ownerLabel: UILabel!
    @IBOutlet weak var starsLabel: UILabel!
    @IBOutlet weak var forksLabel: UILabel!
    @IBOutlet weak var issuesLabel: UILabel!
    @IBOutlet weak var languageLabel: UILabel!
    @IBOutlet weak var ownerImage: UIImageView!
    
    /// ViewController に画像を表示します.
    /// - Parameter image: UIImage
    private func present(image: UIImage?, defaultImage: UIImage? = UIImage(systemName: "exclamationmark.square.fill")) {
        self.ownerImage.image = image ?? defaultImage
    }
    
    func present(repository: RepositoryDetailOutput) {
        self.titleLabel.text = repository.title
        self.ownerLabel.text = repository.owner
        self.starsLabel.text = repository.stargazersCount
        self.forksLabel.text = repository.forksCount
        self.issuesLabel.text = repository.openIssuesCount
        self.languageLabel.text = repository.language
        
        Task {
            await self.present(
                image: try? repository.ownerImageURL.downloaded(),
                defaultImage: UIImage(systemName: "person.circle"))
        }
    }
}
