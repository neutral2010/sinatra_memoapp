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
CONN = PG.connect( dbname: 'sinatra' )
module DB
  class << self
    CONN = PG.connect( dbname: 'sinatra' )
    def all
      # conn = PG.connect( dbname: 'sinatra' )
      result = CONN.exec("select* FROM memo")

      memos = []
      result.each do |row|
        memos << row
      end
    end

    def find(id)
      # assert_id_format(id)
      # parse_json(id)
      # CONN.exec("select* FROM memo where id='4'")
    end

    def save(title, content)
      conn = PG.connect( dbname: 'sinatra' )
      # assert_id_format(memo[:id])
      conn.prepare('sinatra', 'INSERT INTO memo (title, content) values ($1, $2)')
      conn.exec_prepared('sinatra', [title, content])
    end

    def delete(id)
      assert_id_format(id)
      # File.delete("./db/#{id}.json")
      # CONN.exec("delete FROM memo where id='id'")
    end

    private

    def assert_id_format(id)
      raise "invalid id: #{id}" unless id =~ /\A[\w-]+\z/
    end

  #   def dump_json(memo)
  #     File.open("./db/#{memo[:id]}.json", 'w') do |file|
  #       JSON.dump(memo, file)
  #     end
  #   end
  #
  #   def parse_json(id)
  #     JSON.parse(File.read("./db/#{id}.json"), symbolize_names: true)
  #   end
  # end
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
  CONN.exec('INSERT INTO memo (title, content) VALUES ($1, $2)', [params['title'], params['content']])

  # CONN.prepare('sinatra', 'INSERT INTO memo (title, content) values ($1, $2)')
  # CONN.exec_prepared('sinatra', [params['title'], params['content']])
  # DB.save(title, content)
  redirect '/'
end

get '/memos/:id' do
  # @memo = DB.find(id)
  result = CONN.exec("select* FROM memo where id = $1", [params[:id]])
  memo = []
  result.each do |row|
    memo << row
  end
  @memo = memo[0]
  erb :show
end

get '/memos/:id/edit' do
  id = params[:id]
  # @memo = DB.find(id)
  result = CONN.exec("select* FROM memo where id = $1", [params[:id]])
  memo = []
  result.each do |row|
    memo << row
  end
  @memo = memo[0]
  erb :edit
end

patch '/memos/:id' do
  id = params[:id]
  title = params[:title]
  content = params[:content]
  # @memo = DB.find(id)
  # result = CONN.exec("update memo set title = 'つっちゃん', content = 'つっちゃん' where id=12")
  # id部分の変数化
  # result = CONN.exec("update memo set title = 'モコちゃん', content = 'モコちゃん' where id=$1", [params[:id]])
  result = CONN.exec("update memo set title = $1, content = $2 where id=$3",[title, content, id])

  memo = []
  result.each do |row|
    memo << row
  end
  @memo = memo[0]
  # DB.save(memo)
  redirect("/memos/#{id}")
end

delete '/memos/:id' do
  id = params[:id]
  # DB.delete(id)
  CONN.exec("delete FROM memo where id = $1", [params[:id]])
  redirect '/'
end
