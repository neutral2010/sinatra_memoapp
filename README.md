# My Favorites

Sinatraで作成したシンプルなWebアプリです。自分のお気に入りを書き留めておくメモです。<br>
コミュニケーションや、自分のことを伝えるツールのひとつとして、使うことができます。

新規追加・編集・削除機能があります。また登録したお気に入りを、ひとつずつ見るページもあります。

[![Image from Gyazo](https://i.gyazo.com/e1824b07814f7de857e3c404202fb07e.gif)](https://gyazo.com/e1824b07814f7de857e3c404202fb07e)

## 使うための環境

- Bundler version 2.2.3
- Ruby version 3.0.0
- postgres (PostgreSQL) 14.0

### データベースのテーブル作成用ファイル

```
schema.sql
```

以下のコマンドで、実行できます。

```
$ psql sinatra < schema.sql
```

## ブラウザに表示させるまでの手順

1. 自分の手元の環境にソースコードをコピーする。<br>

```  
 $ git clone https://github.com/neutral2010/sinatra_memoapp.git  
```

2. Bundlerがなかったら( `$ bundle -v` で確認できる。）<br>

```  
 $ gem install bundler
```

3. Gemfileを有効にするために

```
 $ bundle install 
```

4. 該当のディレクトリに移動して、次のコマンドでサーバーが起動。

```
 $ bundle exec ruby main.rb 
```

5. ブラウザで

```
 localhost:4567 
```

6. アプリが表示され、各機能が使えます。
