//
//  RepositoryViewController.swift
//  iOSEngineerCodeCheck
//
//  Created by 史 翔新 on 2020/04/21.
//  Copyright © 2020 YUMEMI Inc. All rights reserved.
//

import UIKit

/// 特定のリポジトリについての情報を表示する ViewController です.
class RepositoryViewController: UIViewController {
    
    @IBOutlet weak var repositoryView: RepositoryView!
    
    var selectedRepository: Repository?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // リポジトリ検索コントローラから, 選択したリポジトリを取得します.
//        guard let index = self.selectedRepository?.index else { return }
        guard let repository = self.selectedRepository else { return }
        
        do {
            self.repositoryView.present(repository: try RepositoryDetailOutput(from: repository))
        } catch {
            print(error)
        }
        
    }
    
}
