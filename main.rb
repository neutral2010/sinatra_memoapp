# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require 'erb'
require 'json'
require 'pg'
require 'debug'

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
  CONN = PG.connect(dbname: 'sinatra')

  class << self
    def all
      result = CONN.exec('select* from memo')
      memos = []
      result.each do |row|
        memos << row
      end
      memos.each_index do |i|
        memos[i]['id'] = memos[i]['id'].to_i
      end
      memos.sort_by { |v| v['id'].to_i }
    end

    def find(id)
      assert_id_format(id)
      result = CONN.exec('select* from memo where id = $1', [id])
      get_selected_memo(result)
    end

    def create(title, content)
      CONN.exec('insert into memo (title, content) values ($1, $2)', [title, content])
    end

    def update(title, content, id)
      assert_id_format(id)
      result = CONN.exec('update memo set title = $1, content = $2 where id=$3', [title, content, id])
      get_selected_memo(result)
    end

    def delete(id)
      assert_id_format(id)
      CONN.exec('delete from memo where id = $1', [id])
    end

    private

    def assert_id_format(id)
      raise "invalid id: #{id}" unless id =~ /\A[\w-]+\z/
    end

    def get_selected_memo(result)
      memo = []
      result.each do |row|
        memo << row
      end
      @memo = memo[0]
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
  title = params[:title]
  content = params[:content]
  DB.create(title, content)
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
  title = params[:title]
  content = params[:content]
  id = params[:id]
  DB.update(title, content, id)
  redirect("/memos/#{id}")
end

delete '/memos/:id' do
  id = params[:id]
  DB.delete(id)
  redirect '/'
end
