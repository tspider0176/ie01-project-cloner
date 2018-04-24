## IE1 Corrector
m5211143 Tomohiro Saito

簡易プロジェクトクローニングツール for IE01

### 環境
```
$ ruby -v  
~> ruby 2.2.3 p173  

$ curl --version  
~> curl 7.43.0 (x86_64-apple-darwin15.0)  

$ git --verison  
~> git 2.6.0
```


### 準備
必要事項
- GitHub ssh鍵認証  
クローンは全てssh_url経由
- GitHub アクセストークン取得  
プロジェクトルートに `TOKEN` ファイルを作成し、トークンを書き込み保存

```sh
$ cd ./ie03-corrector
$ touch TOKEN
$ echo "[your token]" >> TOKEN
```

### 実行
#### 初回時

```sh
$ ruby corrector.rb [メーリングリストのcsvファイル] [GitHubクラスルームのroster.csvファイル]
```

ex.
```sh
$ ruby corrector.rb 11-3002-IE03-std5.csv classroom_roster.csv
```

実行後、ローカルに保存してある生徒情報をアップデートするかどうかが聞かれるので、 `y` を入力。GitHub API経由でローカルに保持されている受講生のアップデートが行われる。
初回実行時のみ、環境によっては時間がかかることが想定される。

#### 二回目以降かつ履修生に変動が無い場合:

```sh
ruby corrector.rb
```

自動的にリモートリポジトリのcloneが行われる。実行時にclassroom_roster.csvファイルにGitHubアカウントが登録されていない生徒は無条件で弾かれる。

### GitHub認証
アクセストークンの取得方法:  
http://tetu1984.hateblo.jp/entry/2012/09/30/235233
