# 株式会社ゆめみ iOS エンジニアコードチェック課題

## アプリ仕様

このアプリは GitHub のリポジトリーを検索するアプリです。

## 環境

- IDE : Xcode 14.1
- Swift バージョン : Swift 5.7
- 開発ターゲット : iOS 16.1
- サードパーティのライブラリ
    - [Marked](https://github.com/markedjs/marked)
    - [GitHub-markdown.css](https://github.com/sindresorhus/github-markdown-css)

### 動作

1. サーチバーにキーワードを入力
2. GitHub API（`search/repositories`）でリポジトリーを検索し、結果一覧を概要（リポジトリ名）で表示
3. 特定の結果を選択したら、該当リポジトリの詳細（リポジトリ名、オーナーアイコン、プロジェクト言語、Star 数、Watcher 数、Fork 数、Issue 数）を表示
4. そのページの README.md ボタンをタップ
5. そのリポジトリの README.md を表示

<details><summary>スクリーンショット</summary>

||通常|ダークモード|
|---|---|---|
|検索|<img src = "https://user-images.githubusercontent.com/87851278/203947924-1fada1c6-2a40-48b6-a87f-7b6a0f9ef0a5.png" width = 320>
|一覧|<img src = "https://user-images.githubusercontent.com/87851278/203948436-8f707060-b298-49c5-a58f-8626d3725e68.png" width = 320>
|リポジトリ表示|<img scr = "https://user-images.githubusercontent.com/87851278/203948560-73953d50-7e4c-4fb2-92dd-8fe07f37ebd7.png" width = 320>
|README.md表示|<img src = "https://user-images.githubusercontent.com/87851278/203948742-1ebca264-3dd8-455a-b0b7-45f050935483.png" width = 320>

</details>

### 課題点

- 本アプリは MVC パターンで設計しましたが, 正しく MVC パターンを活用できているのかは怪しいところです. 
- マークダウンの表示機能を追加しましたが, ダークモードに対応できなかったり, 一部のリポジトリでうまく表示できないといった, 不具合が若干残る形となってしまいました. 
- 全体として, 知識のなさが目立ったと思います. UIKit についてはもちろん, MVC パターン, ネットワーク, テストなどについては, 調べながらのプログラミングとなっていました. 今後のためにも, 開発の経験はさらに増やしていく必要があると感じました.

### 課題の進め方(PR, Issue の見方)について

- 課題用の issue を用意していただきましたが, 新しく自分で issue を立て, 自分の立てた issue を中心に作業を進めました.
- 変更は全て develop ブランチへマージし, main ブランチは提出時まで保持し続けています. 従って, 全ての変更の流れを見たい場合は, [Develop PR](https://github.com/rrbox/ios-engineer-codecheck/pull/17) から確認できます.
- また自分で立てた issue のみの [milestone](https://github.com/rrbox/ios-engineer-codecheck/milestone/2) を作成しています. close された issue は時間に沿って並んでいるはずなのでそちらも参考にしていただければと思います.
- この README.md を書き終えた時点で develop をマージし, 課題の issue は最後のチェックに利用したいと思います.

---

<details><summary>課題の詳細</summary>

## 概要

本プロジェクトは株式会社ゆめみ（以下弊社）が、弊社に iOS エンジニアを希望する方に出す課題のベースプロジェクトです。本課題が与えられた方は、下記の概要を詳しく読んだ上で課題を取り組んでください。

## アプリ仕様

本アプリは GitHub のリポジトリーを検索するアプリです。

![動作イメージ](README_Images/app.gif)

### 環境

- IDE：基本最新の安定版（本概要更新時点では Xcode 13.0）
- Swift：基本最新の安定版（本概要更新時点では Swift 5.5）
- 開発ターゲット：基本最新の安定版（本概要更新時点では iOS 15.0）
- サードパーティーライブラリーの利用：オープンソースのものに限り制限しない

### 動作

1. 何かしらのキーワードを入力
2. GitHub API（`search/repositories`）でリポジトリーを検索し、結果一覧を概要（リポジトリ名）で表示
3. 特定の結果を選択したら、該当リポジトリの詳細（リポジトリ名、オーナーアイコン、プロジェクト言語、Star 数、Watcher 数、Fork 数、Issue 数）を表示

## 課題取り組み方法

Issues を確認した上、本プロジェクトを [**Duplicate** してください](https://help.github.com/en/github/creating-cloning-and-archiving-repositories/duplicating-a-repository)（Fork しないようにしてください。必要ならプライベートリポジトリーにしても大丈夫です）。今後のコミットは全てご自身のリポジトリーで行ってください。

コードチェックの課題 Issue は全て [`課題`](https://github.com/yumemi/ios-engineer-codecheck/milestone/1) Milestone がついており、難易度に応じて Label が [`初級`](https://github.com/yumemi/ios-engineer-codecheck/issues?q=is%3Aopen+is%3Aissue+label%3A初級+milestone%3A課題)、[`中級`](https://github.com/yumemi/ios-engineer-codecheck/issues?q=is%3Aopen+is%3Aissue+label%3A中級+milestone%3A課題+) と [`ボーナス`](https://github.com/yumemi/ios-engineer-codecheck/issues?q=is%3Aopen+is%3Aissue+label%3Aボーナス+milestone%3A課題+) に分けられています。課題の必須／選択は下記の表とします：

|   | 初級 | 中級 | ボーナス
|--:|:--:|:--:|:--:|
| 新卒／未経験者 | 必須 | 選択 | 選択 |
| 中途／経験者 | 必須 | 必須 | 選択 |


課題 Issueをご自身のリポジトリーにコピーするGitHub Actionsをご用意しております。  
[こちらのWorkflow](./.github/workflows/copy-issues.yml)を[手動でトリガーする](https://docs.github.com/ja/actions/managing-workflow-runs/manually-running-a-workflow)ことでコピーできますのでご活用下さい。

課題が完成したら、リポジトリーのアドレスを教えてください。

## 参考記事

提出された課題の評価ポイントに関しては、[こちらの記事](https://qiita.com/lovee/items/d76c68341ec3e7beb611)に詳しく書かれてありますので、ぜひご覧ください。
ライブラリの利用に関しては [こちらの記事](https://qiita.com/ykws/items/b951a2e24ca85013e722)も参照ください。

</details>
