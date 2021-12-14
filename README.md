# My Favorites

Sinatraで作成したシンプルなWebアプリです。自分のお気に入りを書き留めておくメモです。<br>
コミュニケーションや、自分のことを伝えるツールのひとつとして、使うことができます。

新規追加・編集・削除機能があります。また登録したお気に入りを、ひとつずつ見るページもあります。

## 使うための環境
- Ruby version 3.0.0
- DBをインストールする必要はありません。

## ブラウザに表示させるまでの手順
1. 自分の手元の環境にソースコードをコピーする。<br>
```
   
 $ git clone https://github.com/neutral2010/sinatra_memoapp.git
   
```
2. Bundlerがなかったら( `$ bundle -v` で確認できる。）、<br>
```
   
 $ gem install bundler

```
3. Gemfileを有効にするために
```
 
 $ bundle install
 
```
4. 該当のディレクトリに移動して
```

 $ bundle exec ruby main.rb
 
```
5. サーバーが起動して、ブラウザにアプリが表示されます。各機能を試せます。

##  その他
あらかじめ、サンプルデータを３つ入れてあります。
