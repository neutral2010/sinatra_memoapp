# !/usr/bin/env ruby

require 'pg'
# sinatra部分は任意のデータベース名で
conn = PG.connect( dbname: 'sinatra' )
'create table memo(id serial not null, title text not null, content text, primary key (id))'
