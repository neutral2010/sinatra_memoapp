require 'sinatra'
require 'sinatra/reloader'
require 'erb'
require 'json'
require "cgi"

# トップページ一覧表示
get '/' do
  all_files = Dir.glob('db/*.json')
  # @memosは、ハッシュ(jsonファイルがハッシュ化されたもの）が要素の配列
  @memos = all_files.map { |all_file| JSON.parse(File.read(all_file), symbolize_names: true) }
  erb :index
end

# 新規メモ作成ページの表示
get '/memos/new' do
  erb :new
end

# 新規メモ作成
post '/memos/:id' do
  memo = {
    "id" => SecureRandom.uuid,
    "title" => CGI.escapeHTML(params["title"]),
    "content" => CGI.escapeHTML(params["content"]),
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
  file_name = File.basename("db/memos_#{@id}.json")
  @memo = JSON.parse(File.read("./db/#{file_name}"), symbolize_names: true)
  erb :show
end

# 各メモを変更を編集する画面表示
get '/memos/:id/edit' do
  @id = params[:id]
  file_name = File.basename("db/memos_#{@id}.json")
  @memo = JSON.parse(File.read("./db/#{file_name}"), symbolize_names: true)
  erb :edit
end

# 各メモ変更
patch '/memos/:id' do
  @id = params[:id]
  file_name = File.basename("db/memos_#{@id}.json")
  memo = JSON.parse(File.read("./db/#{file_name}"), symbolize_names: true)
  memo = {
    "id" => memo[:id],
    "title" => CGI.escapeHTML(params[:title]),
    "content" => CGI.escapeHTML(params[:content]),
    "created_at" => Time.now
  }

  File.open("./db/#{file_name}", 'w') do |file|
    JSON.dump(memo, file)
  end

  file_name = File.basename("db/memos_#{@id}.json")
  memo = JSON.parse(File.read("./db/#{file_name}"), symbolize_names: true)
  # 成功したら、詳細表示画面へ
  redirect("/memos/#{@id}")
end

# 各メモ削除 ← 削除ボタンから来るところ
delete '/memos/:id' do
  @id = params[:id]
  File.delete("./db/memos_#{@id}.json")
  # 成功したら、トップページ（一覧表示画面へ）
  redirect '/'
end
