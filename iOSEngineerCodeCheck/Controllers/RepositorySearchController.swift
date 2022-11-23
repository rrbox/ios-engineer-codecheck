//
//  RepositorySearchController.swift
//  iOSEngineerCodeCheck
//
//  Created by 史 翔新 on 2020/04/20.
//  Copyright © 2020 YUMEMI Inc. All rights reserved.
//

import UIKit

enum RepositoriesArrayGetError: Error {
    case convertToDictionaryFailed
    case getRepotioriesArrayFromDictionaryFailed
    case taskFailed
}

/// Repository を検索し, 該当するリポジトリを一覧で表示するコントローラーです.
class RepositorySearchController: UITableViewController, UISearchBarDelegate {
    
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
        
        if repositories.items.isEmpty {
            let alert = UIAlertController(
                title: "検索結果",
                message: "0件",
                preferredStyle: .alert)
            alert.addAction(UIAlertAction(
                title: "OK",
                style: .default))
            self.present(alert, animated: true)
        }
    }
    
    /// ユーザーが文字入力を終え, 検索を開始したときの処理です.
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        // サーチバーに入力したテキストをプロパティにセットします.
        guard let word = searchBar.text?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }
        
        // 入力がなかった場合はリポジトリデータを取得しません.
        guard word.count != 0 else { return }
        
        // URL を作成し, リポジトリの一覧の JSON を GET します.
        guard let url = GitHubAPI.getSearchRepositoriesURL(query: word) else { return }
        
        self.task = Task {
            do {
                let repositories = try await ObjectDownload<Repositories>(url: url).downloaded()
                self.present(repositories: repositories)
                self.repositories = repositories
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
