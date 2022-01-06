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
end

# CRUD function and path for memo
module DB
  class << self
    def all
      all_files = Dir.glob('db/*.json')
      memos = all_files.map { |all_file| JSON.parse(File.read(all_file), symbolize_names: true) }
      memos.sort_by { |v| v[:created_at] }
    end

    def find(id)
      assert_id_format(id)
      parse_json(id)
    end

    def save(memo)
      assert_id_format(memo[:id])
      dump_json(memo)
    end

    def delete(id)
      assert_id_format(id)
      File.delete("./db/#{id}.json")
    end

    private

    def assert_id_format(id)
      raise "invalid id: #{id}" unless id =~ /\A[\w-]+\z/
    end

    def dump_json(memo)
      File.open("./db/#{memo[:id]}.json", 'w') do |file|
        JSON.dump(memo, file)
      end
    end

    def parse_json(id)
      JSON.parse(File.read("./db/#{id}.json"), symbolize_names: true)
    end
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
    title: params[:title],
    content: params[:content],
    created_at: Time.now
  }
  DB.save(memo)
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
  DB.save(memo)
  redirect("/memos/#{id}")
end

delete '/memos/:id' do
  id = params[:id]
  DB.delete(id)
  redirect '/'
end
