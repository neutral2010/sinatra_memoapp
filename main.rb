# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require 'erb'
require 'json'
# require 'debug'

not_found do
  erb :error
end

helpers do
  def h(text)
    Rack::Utils.escape_html(text)
  end

  # def read_file_name(id)
  #   File.basename("db/memos_#{id}.json")
  # end

  def parse_json(file_name)
    JSON.parse(File.read("./db/#{file_name}"), symbolize_names: true)
  end
end

module DB
  class << self
    def all
      all_files = Dir.glob('db/*.json')
      memos = all_files.map { |all_file| JSON.parse(File.read(all_file), symbolize_names: true) }
      memos.sort_by { |v| v[:created_at] }
    end

    def find(id)
      JSON.parse(File.read("db/memos_#{id}.json"), symbolize_names: true)
    end

    def create(memo)
      File.open("./db/memos_#{memo[:id]}.json", 'w') do |file|
        JSON.dump(memo, file)
      end
    end

    def update(memo)
      File.open("./db/memos_#{memo[:id]}.json", 'w') do |file|
        JSON.dump(memo, file)
      end
      JSON.parse(File.read("./db/memos_#{memo[:id]}.json"), symbolize_names: true)
    end

    def delete(id)
      File.delete("./db/memos_#{id}.json")
    end

    private

    def read_path; end
  end
end

get '/' do
  @memos = DB.all
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
  DB.create(memo)
  redirect '/'
end

get '/memos/:id' do
  id = params[:id]
  @memo = DB.find(id)
  erb :show
end

get '/memos/:id/edit' do
  id = params[:id]
  @memo = DB.find(id)
  erb :edit
end

patch '/memos/:id' do
  id = params[:id]
  memo = DB.find(id)
  memo[:title] = params[:title]
  memo[:content] = params[:content]
  memo[:created_at] = Time.now
  DB.update(memo)
  redirect("/memos/#{id}")
end

delete '/memos/:id' do
  id = params[:id]
  DB.delete(id)
  redirect '/'
end
