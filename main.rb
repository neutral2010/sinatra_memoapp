require 'sinatra'
require 'sinatra/reloader'
require 'erb'
require 'json'

# トップページ一覧表示
get '/' do
  # 作成されたjsonファイル
  all_files = Dir.glob('db/*.json')
  # @memosは、ハッシュ(jsonファイルがハッシュ化されたもの）が要素の配列
  @memos = all_files.map { |all_file| JSON.parse(File.read(all_file), symbolize_names: true)}
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
    "id" => SecureRandom.uuid,
    "title" => params["title"],
    "content" => params["content"],
    "created_at" => Time.now
  }

  File.open("./db/memos_#{memo["id"]}.json", 'w') do |file|
    JSON.dump(memo, file)
  end
 # 成功したら、トップページ（一覧表示画面へ）
  redirect '/'
end

# 各メモ詳細表示

get '/memos/:id' do
  @id = params[:id]
  all_files = Dir.glob('db/*.json')
  @memos = all_files.map { |all_file| JSON.parse(File.read(all_file), symbolize_names: true)}
  erb :show
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
