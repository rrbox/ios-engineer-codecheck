//
//  RepositorySearchController.swift
//  iOSEngineerCodeCheck
//
//  Created by 史 翔新 on 2020/04/20.
//  Copyright © 2020 YUMEMI Inc. All rights reserved.
//

import UIKit

/// Repository を検索し, 該当するリポジトリを一覧で表示するコントローラーです.
class RepositorySearchController: UITableViewController, UISearchBarDelegate, SearchProtocol {
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    weak var repositoryTableView: RepositoryTableView? {
        self.tableView as? RepositoryTableView
    }
    
    var repositories = Repositories()
    var task: Task<(), Never>?
    var index: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.searchBar.text = "GitHubのリポジトリを検索できるよー"
        self.searchBar.delegate = self
        self.repositoryTableView?.dataSource = self.repositoryTableView
    }
    
    /// ユーザーが検索のために文字入力を開始したときの処理です.
    /// - note: デフォルトで表示しているテキストを消去します.
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        // ↓こうすれば初期のテキストを消せる
        searchBar.text = ""
        return true
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.task?.cancel()
    }
    
    /// 辞書型のリポジトリデータをテーブルビューに表示します.
    func present(repositories: Repositories) {
        // データが更新されるため, TableView の表示を更新します.
        self.repositoryTableView?.present(repositories: repositories.items)
    }
    
    /// ユーザーが文字入力を終え, 検索を開始したときの処理です.
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.task = Task {
            do {
                let repositories = try await self.search(word: self.searchBar.text)
                self.present(repositories: repositories)
                self.repositories = repositories
                
            } catch let error as RepositorySearchError {
                switch error {
                case .percentEncodingFailed:
                    print(error)
                case .emptyWord:
                    print(error)
                case .urlCreationFailed:
                    print(error)
                case .repositoriesArrayEmptyError:
                    let alert = UIAlertController(
                        title: "検索結果",
                        message: "0件",
                        preferredStyle: .alert)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        alert.dismiss(animated: true)
                    }
                    self.present(alert, animated: true)
                }
            } catch {
                print(error)
            }
        }
        
    }
    
    /// 画面遷移することを次の ViewController に通知します.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "Detail" {
            let destination = segue.destination as! RepositoryViewController
            guard let index = self.index else { return }
            destination.selectedRepository = self.repositories.items[index]
        }
        
    }
    
    /// Table のアイテムを選択したときの処理です.
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.index = indexPath.row
        // 画面を遷移します.
        performSegue(withIdentifier: "Detail", sender: self)
        
    }
    
}
