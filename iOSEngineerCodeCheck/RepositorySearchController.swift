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
    
    var repositories: [[String: Any]] = []
    var task: Task<(), Never>?
    var word: String?
    var index: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.searchBar.text = "GitHubのリポジトリを検索できるよー"
        self.searchBar.delegate = self
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
    
    /// リポジトリを検索するクエリを生成するメソッドです.
    func getSearchQueryURL(query: String) -> URL? {
        URL(string: "https://api.github.com/search/repositories?q=\(query)")
    }
    
    /// URL で通信し, リポジトリの値(辞書型)を取得します.
    func getRepositories(from url: URL) async throws -> [[String: Any]] {
        let (data, _) = try await URLSession.shared.data(for: URLRequest(url: url))
        guard let jsonObject = try JSONSerialization.jsonObject(with: data) as? [String: Any] else {
            // 受け取ったデータを JSONObject に変換できなかった際の処理です.
            throw RepositoriesArrayGetError.convertToDictionaryFailed
        }
        guard let items = jsonObject["items"] as? [[String: Any]] else {
            // 辞書に "items" の value がなかった際の処理です.
            throw RepositoriesArrayGetError.getRepotioriesArrayFromDictionaryFailed
        }
        return items
    }
    
    /// 辞書型のリポジトリデータをテーブルビューに表示します.
    func present(repositories: [[String: Any]]) {
        self.repositories = repositories
        // データが更新されるため, TableView の表示を更新します.
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    /// ユーザーが文字入力を終え, 検索を開始したときの処理です.
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        // サーチバーに入力したテキストをプロパティにセットします.
        self.word = searchBar.text
        
        guard let word = self.word else { return }
        
        // 入力がなかった場合はリポジトリデータを取得しません.
        guard word.count != 0 else { return }
        
        // URL を作成し, リポジトリの一覧の JSON を GET します.
        guard let url = self.getSearchQueryURL(query: word) else { return }
        self.task = Task {
            do {
                let repositories = try await self.getRepositories(from: url)
                self.present(repositories: repositories)
            } catch {
                print(error)
            }
        }
        
    }
    
    /// 画面遷移することを次の ViewController に通知します.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "Detail" {
            let destination = segue.destination as! RepositoryViewController
            destination.repositorySearch = self
        }
        
    }
    
    
    /// TableView の row の数を設定します.
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.repositories.count
    }
    
    /// TableViewCell を初期化します.
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // TableViewCell をカスタマイズします.
        let cell = UITableViewCell()
        let repository = self.repositories[indexPath.row]
        cell.textLabel?.text = repository["full_name"] as? String ?? ""
        cell.detailTextLabel?.text = repository["language"] as? String ?? ""
        cell.tag = indexPath.row
        return cell
        
    }
    
    /// Table のアイテムを選択したときの処理です.
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.index = indexPath.row
        // 画面を遷移します.
        performSegue(withIdentifier: "Detail", sender: self)
        
    }
    
}
