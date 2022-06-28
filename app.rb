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

def define_id(memos)
  if memos == {}
    0
  else
    memos.keys.map(&:to_i).max + 1
  end
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
  memo_id = loaded_json['id_counter'] + 1
  memo_title = h(params['memo_title'])
  memo_content = h(params['memo_content'])
  loaded_json['memos'] << { 'memo_id' => memo_id, 'memo_title' => memo_title, 'memo_content' => memo_content }
  loaded_json['id_counter'] = memo_id
  write_json(loaded_json)
  redirect to('/memos')
end

get '/memos/new' do
  erb :new
end

get '/memos/:memo_id' do
  memos = read_json['memos']
  memos.each do |memo|
    @memo = memo if memo['memo_id'] == params['memo_id'].to_i
  end
  @memo_id = params['memo_id']
  erb :show
end

delete '/memos/:memo_id' do
  loaded_json = read_json
  memos.delete(params['memo_id'])
  write_json(memos)
  redirect to('/memos')
end

get '/memos/:memo_id/edit' do
  @memo_id = params['memo_id']
  @memos = read_json
  @memo = @memos[params['memo_id']]
  erb :edit
end

patch '/memos/:memo_id' do
  memos = read_json
  memo_id = params['memo_id']
  memo_title = h(params['memo_title'])
  memo_content = h(params['memo_content'])
  memos[memo_id] = { 'memo_title' => memo_title, 'memo_content' => memo_content }
  write_json(memos)
  redirect to('/memos')
end
