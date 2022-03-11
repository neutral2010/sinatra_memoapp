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

# CRUD function and path for mem
module MemoOfSinatraDb
  CONN = PG.connect(dbname: 'sinatra')
  private_constant :CONN

  class << self
    def all
      CONN.exec('SELECT * FROM memo ORDER BY id ASC;')
    end

    def find(id)
      assert_id_format(id)
      result_of_find = CONN.exec('SELECT * FROM memo WHERE id = $1', [id])
      make_array_from_retrieved_memo(result_of_find)
    end

    def create(title, content)
      CONN.exec('INSERT INTO memo (title, content) VALUES ($1, $2)', [title, content])
    end

    def update(id, title, content)
      assert_id_format(id)
      result_of_update = CONN.exec('UPDATE memo SET title = $1, content = $2 WHERE id=$3', [title, content, id])
      make_array_from_retrieved_memo(result_of_update)
    end

    def delete(id)
      assert_id_format(id)
      CONN.exec('DELETE FROM memo WHERE id = $1', [id])
    end

    private

    def assert_id_format(id)
      raise "invalid id: #{id}" unless id =~ /\A\d+\z/
    end

    def make_array_from_retrieved_memo(result)
      memos = []
      result.each do |row|
        memos << row
      end
      @memo = memos[0]
    end
  end
end

get '/' do
  @memos = MemoOfSinatraDb.all
  erb :index
end

get '/memos/new' do
  erb :new
end

post '/memos' do
  title = params[:title]
  content = params[:content]
  MemoOfSinatraDb.create(title, content)
  redirect '/'
end

get '/memos/:id' do
  id = params[:id]
  @memo = MemoOfSinatraDb.find(id)
  erb :show
end

get '/memos/:id/edit' do
  id = params[:id]
  @memo = MemoOfSinatraDb.find(id)
  erb :edit
end

patch '/memos/:id' do
  title = params[:title]
  content = params[:content]
  id = params[:id]
  MemoOfSinatraDb.update(id, title, content)
  redirect("/memos/#{id}")
end

delete '/memos/:id' do
  id = params[:id]
  MemoOfSinatraDb.delete(id)
  redirect '/'
end
