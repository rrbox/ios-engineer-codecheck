//
//  RepositorySearchController.swift
//  iOSEngineerCodeCheck
//
//  Created by 史 翔新 on 2020/04/20.
//  Copyright © 2020 YUMEMI Inc. All rights reserved.
//

import UIKit

/// Repository を検索し, 該当するリポジトリを一覧で表示するコントローラーです.
class RepositorySearchController: UITableViewController, UISearchBarDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var repositories: [[String: Any]] = []
    var task: URLSessionTask?
    var word: String!
    var url: String!
    var index: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        searchBar.text = "GitHubのリポジトリを検索できるよー"
        searchBar.delegate = self
    }
    
    /// ユーザーが検索のために文字入力を開始したときの処理です.
    /// - note: デフォルトで表示しているテキストを消去します.
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        // ↓こうすれば初期のテキストを消せる
        searchBar.text = ""
        return true
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        task?.cancel()
    }
    
    /// ユーザーが文字入力を終え, 検索を開始したときの処理です.
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        // サーチバーに入力したテキストをプロパティにセットします.
        word = searchBar.text!
        
        // 入力がなかった場合はリポジトリデータを取得しません.
        guard word.count != 0 else {
            return
        }
        
        // URL を作成し, リポジトリの一覧の JSON を GET します.
        url = "https://api.github.com/search/repositories?q=\(word!)"
        task = URLSession.shared.dataTask(with: URL(string: url)!) { (data, res, err) in
            guard let jsonObject = try! JSONSerialization.jsonObject(with: data!) as? [String: Any] else {
                return
            }
            guard let items = jsonObject["items"] as? [[String: Any]] else {
                return
            }
            self.repositories = items
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        // 作成したタスクを実行します.
        task?.resume()
        
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
        return repositories.count
    }
    
    /// TableViewCell を初期化します.
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // TableViewCell をカスタマイズします.
        let cell = UITableViewCell()
        let repository = repositories[indexPath.row]
        cell.textLabel?.text = repository["full_name"] as? String ?? ""
        cell.detailTextLabel?.text = repository["language"] as? String ?? ""
        cell.tag = indexPath.row
        return cell
        
    }
    
    /// Table のアイテムを選択したときの処理です.
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        index = indexPath.row
        // 画面を遷移します.
        performSegue(withIdentifier: "Detail", sender: self)
        
    }
    
}