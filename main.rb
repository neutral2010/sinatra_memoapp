# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require 'erb'
require 'json'

not_found do
  erb :error
end

helpers do
  def h(text)
    Rack::Utils.escape_html(text)
  end

  def read_file_name(id)
    File.basename("db/memos_#{id}.json")
  end

  def parse_json(file_name)
    JSON.parse(File.read("./db/#{file_name}"), symbolize_names: true)
  end
end

get '/' do
  all_files = Dir.glob('db/*.json')
  memos = all_files.map { |all_file| JSON.parse(File.read(all_file), symbolize_names: true) }
  @memos = memos.sort_by { |v| v[:created_at] }
  erb :index
end

get '/memos/new' do
  erb :new
end

post '/memos/:id' do
  memo = {
    id: SecureRandom.uuid,
    title: params['title'],
    content: params['content'],
    created_at: Time.now
  }
  File.open("./db/memos_#{memo[:id]}.json", 'w') do |file|
    JSON.dump(memo, file)
  end
  redirect '/'
end

get '/memos/:id' do
  @id = params[:id]
  file_name = read_file_name(@id)
  @memo = parse_json(file_name)
  erb :show
end

get '/memos/:id/edit' do
  @id = params[:id]
  file_name = read_file_name(@id)
  @memo = parse_json(file_name)
  erb :edit
end

patch '/memos/:id' do
  @id = params[:id]
  file_name = read_file_name(@id)
  memo = parse_json(file_name)
  memo[:title] = params[:title]
  memo[:content] = params[:content]
  memo[:created_at] = Time.now
  File.open("./db/#{file_name}", 'w') do |file|
    JSON.dump(memo, file)
  end

  file_name = read_file_name(@id)
  @memo = parse_json(file_name)
  redirect("/memos/#{@id}")
end

delete '/memos/:id' do
  @id = params[:id]
  file_name = read_file_name(@id)
  File.delete("./db/#{file_name}")
  redirect '/'
end
