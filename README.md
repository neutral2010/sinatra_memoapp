# sinatra_memoapp
Sinatraで作るシンプルなWebアプリ
# sinatra_memoapp

Sinatraで作るシンプルなWebアプリとして、自分のお気に入りを書き留めておくメモを作りました。
コミュニケーションや自分のことをしてもらう手段の一つとして、使うことができます。

## 使うための環境
- Ruby version 3.0.0
- DBをインストールする必要はありません。

## ブラウザに表示させるまでの手順
1. 自分の手元の環境にソースコードをコピーする。<br>
   `$ git clone https://github.com/neutral2010/sinatra_memoapp.git `
2. Bundlerがなかったら( `$ bundle -v` で確認できる。）、<br>`$ gem install bundler`
3. Gemfileを有効にするために、`$ bundle install`
4. 該当のディレクトリに移動して、 `bundle exec ruby main.rb`
5. サーバーが起動して、ブラウザにアプリが表示される。

###  その他
あらかじめ、サンプルデータが３つ入っています。
