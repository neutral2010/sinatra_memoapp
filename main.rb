require 'sinatra'
require 'sinatra/reloader'
require 'erb'
require 'json'

# トップページ一覧表示
get '/' do
  # 作成されたjsonファイル
  all_files = Dir.glob('./db/*.json')
  # jsonファイルを一つづつrubyのハッシュに変換
  @memos = all_files.map {|file| JSON.parse(File.open(file).read)}
  # @memosは、ハッシュ(jsonファイルがハッシュ化されたもの）が要素の配列
  # ex [{"title"=>"", "content"=>"", "created_at"=>"2021-11-19 22:09:00 +0900"}, {"title"=>"", "content"=>"", #"created_at"=>"2021-11-19 22:51:07 +0900"}, {"id"=>":id", "title"=>"プリン", "content"=>"カスタード", #"created_at"=>"2021-11-20 02:37:00 +0900"}, {"id"=>":id", "title"=>"moko", "content"=>"kuroneko", #"created_at"=>"2021-11-20 02:44:22 +0900"}]
  erb :index
end
# index リストでタイトルが表示されている。タイトルから各詳細ページへのリンクと`追加`ボタン（これは新規作成画面に）

# 新規メモ作成ページの表示
get '/memos/new' do
  erb :new
end
#保存を押すと、、、↓

# 新規メモ作成
post '/memos/:id' do
  memo = {
    "id" => Time.now, # 🤔
    "title" => params["title"],
    "content" => params["content"],
    "created_at" => Time.now
  }

  @memos = File.open("./db/memos_#{memo["created_at"]}.json", 'w') do |file|
    JSON.dump(memo, file)
    end
 # 成功したら、トップページ（一覧表示画面へ）
  redirect '/'
end

# 各メモ詳細表示
get '/memos/:id' do
  # @id = params[:id]
  "Hello World"
  # erb :show
  # 変更ボタン → /memos/:id/edit
  # 削除ボタン
end

# 各メモを変更を編集する画面表示
get '/memos/:id/edit' do
erb :edit
end

# 各メモ変更
patch '/memos/:id' do
# 成功したら、トップページ（一覧表示画面へ）
  redirect '/'
end

# 各メモ削除 ← 削除ボタンから来るところ
delete '/memos/:id' do
# 成功したら、トップページ（一覧表示画面へ）
  redirect '/'
end
