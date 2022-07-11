# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
# require 'json'
require 'pg'
# require 'debug'

# DATA_JSON = 'data.json'



# def read_json
#   File.open(DATA_JSON) do |file|
#     JSON.parse(file.read)
#   end
# end

# def write_json(loaded_json)
#   File.open(DATA_JSON, 'w') do |file|
#     JSON.dump(loaded_json, file)
#   end
# end

# def find_memo(loaded_json, memo_id)
#   loaded_json['memos'].find do |memo|
#     memo['memo_id'] == memo_id
#   end
# end

# def create_new_id(loaded_json)
#   loaded_json['id_counter'] = loaded_json['id_counter'] + 1
#   write_json(loaded_json)
#   loaded_json['id_counter']
# end

# def add_new_memo(loaded_json, memo_title, memo_content)
#   memo_title = memo_title == '' ? 'タイトル未設定' : memo_title
#   loaded_json['memos'] << { 'memo_id' => create_new_id(loaded_json), 'memo_title' => memo_title,
#                             'memo_content' => memo_content }
#   write_json(loaded_json)
# end

# def change_memo(loaded_json, memo_id, memo_title, memo_content)
#   memo_title = memo_title == '' ? 'タイトル未設定' : memo_title
#   memo = find_memo(loaded_json, memo_id)
#   memo['memo_title'] = memo_title
#   memo['memo_content'] = memo_content
#   write_json(loaded_json)
# end

# def delete_memo(loaded_json, memo_id)
#   loaded_json['memos'].delete_if do |memo|
#     memo['memo_id'] == memo_id
#   end
#   write_json(loaded_json)
# end

helpers do
  def h(text)
    Rack::Utils.escape_html(text)
  end
end




def receive_memos(conn)
  # debugger
  all_memos = conn.exec( "select * from memos" ) do |result|
    result.map do |row|
      row
    end
  end
end

conn = PG.connect( dbname: 'memo_db' )

get '/memos' do
  @memos = receive_memos(conn)
  erb :index
end

def add_new_memo(conn, memo_title, memo_content)
  memo_title = memo_title == '' ? 'タイトル未設定' : memo_title
  conn.exec( "insert into memos (memo_title, memo_content) values ($1, $2)", [memo_title, memo_content] )
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

def select_memo(conn, memo_id)
  result = conn.exec( "select * from memos where memo_id = $1", [memo_id])
  memo_array = result.each do |memo|
    memo
  end
  memo_array[0]
end

get '/memos/:memo_id' do
  memo_id = params['memo_id'].to_i
  @memo = select_memo(conn, memo_id)
  erb :show
end

def delete_memo(conn, memo_id)
  conn.exec( "delete from memos where memo_id = $1", [memo_id])
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

def update_memo(conn, memo_id, memo_title, memo_content)
  memo_title = memo_title == '' ? 'タイトル未設定' : memo_title
  conn.exec( "update memos set memo_title = $1, memo_content = $2 where memo_id = $3", [memo_title, memo_content, memo_id])
end

patch '/memos/:memo_id' do
  memo_id = params['memo_id'].to_i
  memo_title = params['memo_title']
  memo_content = params['memo_content']
  update_memo(conn, memo_id, memo_title, memo_content)
  redirect to('/memos')
end
