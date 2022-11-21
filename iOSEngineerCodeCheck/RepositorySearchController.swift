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

class RepositoryCell: UITableViewCell {
    func present(repository: Repository, cellForRowAt indexPath: IndexPath) {
        self.textLabel?.text = repository.fullName
        self.detailTextLabel?.text = repository.language
        self.tag = indexPath.row
    }
}

/// Repository を検索し, 該当するリポジトリを一覧で表示するコントローラーです.
class RepositorySearchController: UITableViewController, UISearchBarDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var repositories = Repositories()
    var task: Task<(), Never>?
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
    func getRepositories(from url: URL) async throws -> Repositories {
        let (data, _) = try await URLSession.shared.data(for: URLRequest(url: url))
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let result = try decoder.decode(Repositories.self, from: data)
        return result
    }
    
    /// 辞書型のリポジトリデータをテーブルビューに表示します.
    func present(repositories: Repositories) {
        self.repositories = repositories
        // データが更新されるため, TableView の表示を更新します.
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    /// ユーザーが文字入力を終え, 検索を開始したときの処理です.
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        // サーチバーに入力したテキストをプロパティにセットします.
        guard let word = searchBar.text else { return }
        
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
            guard let index = self.index else { return }
            destination.selectedRepository = self.repositories.items[index]
        }
        
    }
    
    
    /// TableView の row の数を設定します.
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.repositories.items.count
    }
    
    /// TableViewCell を初期化します.
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // TableViewCell をカスタマイズします.
        let cell = RepositoryCell()
        let repository = self.repositories.items[indexPath.row]
        cell.present(repository: repository, cellForRowAt: indexPath)
        return cell
        
    }
    
    /// Table のアイテムを選択したときの処理です.
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.index = indexPath.row
        // 画面を遷移します.
        performSegue(withIdentifier: "Detail", sender: self)
        
    }
    
}
