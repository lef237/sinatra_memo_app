# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require 'json'

DATA_JSON = 'data.json'

def read_json
  File.open(DATA_JSON) do |file|
    JSON.parse(file.read)
  end
end

def write_json(loaded_json)
  File.open(DATA_JSON, 'w') do |file|
    JSON.dump(loaded_json, file)
  end
end

def find_memo(memos, memo_id)
  memos.find do |memo|
    memo['memo_id'] == memo_id
  end
end

def create_new_id(loaded_json)
  loaded_json['id_counter'] = loaded_json['id_counter'] + 1
  write_json(loaded_json)
end

def add_new_memo(loaded_json, memo_title, memo_content)
  memo_title = memo_title == '' ? 'タイトル未設定' : memo_title
  loaded_json['memos'] << { 'memo_id' => loaded_json['id_counter'], 'memo_title' => memo_title, 'memo_content' => memo_content }
  write_json(loaded_json)
end

def change_memo(loaded_json, memo_id, memo_title, memo_content)
  memos = loaded_json['memos']
  memo = find_memo(memos, memo_id)
  memo['memo_title'] = memo_title
  memo['memo_content'] = memo_content
  write_json(loaded_json)
end

def delete_memo(loaded_json, memo_id)
  loaded_json['memos'].delete_if do |memo|
    memo['memo_id'] == memo_id
  end
  write_json(loaded_json)
end

helpers do
  def h(text)
    Rack::Utils.escape_html(text)
  end
end

get '/memos' do
  @memos = read_json['memos']
  erb :index
end

post '/memos' do
  loaded_json = read_json
  create_new_id(loaded_json)
  memo_title = params['memo_title']
  memo_content = params['memo_content']
  add_new_memo(loaded_json, memo_title, memo_content)
  redirect to('/memos')
end

get '/memos/new' do
  erb :new
end

get '/memos/:memo_id' do
  memos = read_json['memos']
  memo_id = params['memo_id'].to_i
  @memo = find_memo(memos, memo_id)
  erb :show
end

delete '/memos/:memo_id' do
  loaded_json = read_json
  memo_id = params['memo_id'].to_i
  delete_memo(loaded_json, memo_id)
  redirect to('/memos')
end

get '/memos/:memo_id/edit' do
  memos = read_json['memos']
  memo_id = params['memo_id'].to_i
  @memo = find_memo(memos, memo_id)
  erb :edit
end

patch '/memos/:memo_id' do
  loaded_json = read_json
  memo_id = params['memo_id'].to_i
  memo_title = params['memo_title'] == '' ? 'タイトル未設定' : params['memo_title']
  memo_content = params['memo_content']
  change_memo(loaded_json, memo_id, memo_title, memo_content)
  redirect to('/memos')
end
