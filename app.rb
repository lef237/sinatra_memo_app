# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require 'pg'

def receive_memos(conn)
  # debugger
  all_memos = conn.exec( "select * from memos" ) do |result|
    result.map do |row|
      row
    end
  end
end

def add_new_memo(conn, memo_title, memo_content)
  memo_title = memo_title == '' ? 'タイトル未設定' : memo_title
  conn.exec( "insert into memos (memo_title, memo_content) values ($1, $2)", [memo_title, memo_content] )
end

def select_memo(conn, memo_id)
  result = conn.exec( "select * from memos where memo_id = $1", [memo_id])
  memo_array = result.each do |memo|
    memo
  end
  memo_array[0]
end

def delete_memo(conn, memo_id)
  conn.exec( "delete from memos where memo_id = $1", [memo_id])
end

def update_memo(conn, memo_id, memo_title, memo_content)
  memo_title = memo_title == '' ? 'タイトル未設定' : memo_title
  conn.exec( "update memos set memo_title = $1, memo_content = $2 where memo_id = $3", [memo_title, memo_content, memo_id])
end

helpers do
  def h(text)
    Rack::Utils.escape_html(text)
  end
end

conn = PG.connect( dbname: 'memo_db' )

get '/memos' do
  @memos = receive_memos(conn)
  erb :index
end

post '/memos' do
  memo_title = params['memo_title']
  memo_content = params['memo_content']
  add_new_memo(conn, memo_title, memo_content)
  redirect to('/memos')
end

get '/memos/new' do
  erb :new
end

get '/memos/:memo_id' do
  memo_id = params['memo_id'].to_i
  @memo = select_memo(conn, memo_id)
  erb :show
end

delete '/memos/:memo_id' do
  memo_id = params['memo_id'].to_i
  delete_memo(conn, memo_id)
  redirect to('/memos')
end

get '/memos/:memo_id/edit' do
  memo_id = params['memo_id'].to_i
  @memo = select_memo(conn, memo_id)
  erb :edit
end

patch '/memos/:memo_id' do
  memo_id = params['memo_id'].to_i
  memo_title = params['memo_title']
  memo_content = params['memo_content']
  update_memo(conn, memo_id, memo_title, memo_content)
  redirect to('/memos')
end
