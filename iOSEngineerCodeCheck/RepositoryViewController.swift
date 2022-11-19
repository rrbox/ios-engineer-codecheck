//
//  RepositoryViewController.swift
//  iOSEngineerCodeCheck
//
//  Created by 史 翔新 on 2020/04/21.
//  Copyright © 2020 YUMEMI Inc. All rights reserved.
//

import UIKit

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
        
        let repository = repositorySearch.repositories[repositorySearch.index]
        
        titleLabel.text = repository["full_name"] as? String
        languageLabel.text = "Written in \(repository["language"] as? String ?? "")"
        starsLabel.text = "\(repository["stargazers_count"] as? Int ?? 0) stars"
        watchersLabel.text = "\(repository["wachers_count"] as? Int ?? 0) watchers"
        forksLabel.text = "\(repository["forks_count"] as? Int ?? 0) forks"
        issuesLabel.text = "\(repository["open_issues_count"] as? Int ?? 0) open issues"
        getImage(repository: repository)
        
    }
    
//    func image(from repository: [String: Any]) -> UIImage {
//
//    }
    func image(url: URL) async throws -> UIImage? {
        let (data, _) = try await URLSession.shared.data(for: URLRequest(url: url))
        return UIImage(data: data)
    }
    
    func getImage(repository: [String : Any]) {
        
        guard let owner = repository["owner"] as? [String: Any] else {
            return
        }
        guard let imgURL = owner["avatar_url"] as? String else {
            return
        }
        
        Task {
            do {
                let (data, _) = try await URLSession.shared.data(for: URLRequest(url: URL(string: imgURL)!))
                
                let image = UIImage(data: data)!
                DispatchQueue.main.async {
                    self.imageView.image = image
                }
            } catch {
                print(error)
            }
        }
        
    }
    
}
