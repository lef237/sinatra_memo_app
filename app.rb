# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require 'json'

DATA_JSON = 'data.json'

get '/' do
  @memos = File.open(DATA_JSON) { |f| JSON.parse(f.read) }
  erb :index
end

post '/' do
  memos = File.open(DATA_JSON) { |f| JSON.parse(f.read) }
  memo_title = params[:memo_title]
  memo_content = params[:memo_content]
  hash = { 'memo_title' => memo_title, 'memo_content' => memo_content }
  memos << hash
  File.open(DATA_JSON, 'w') do |file|
    JSON.dump(memos, file)
  end
  redirect to('/')
end

get '/new' do
  erb :new
end

get '/show/:memo_id' do
  @memo_id = params[:memo_id].to_i
  File.open(DATA_JSON) do |f|
    @memos = JSON.parse(f.read)
  end
  @memo = @memos[params[:memo_id].to_i]
  erb :show
end

delete '/show/:memo_id' do
  memos = File.open(DATA_JSON) { |f| JSON.parse(f.read) }
  memos.delete_at(params['memo_id'].to_i)
  File.open(DATA_JSON, 'w') do |file|
    JSON.dump(memos, file)
  end
  redirect to('/')
end

get '/edit/:memo_id' do
  @memo_id = params[:memo_id]
  File.open(DATA_JSON) do |f|
    @memos = JSON.parse(f.read)
  end
  @memo = @memos[params['memo_id'].to_i]
  erb :edit
end

patch '/' do
  memos = File.open(DATA_JSON) { |f| JSON.parse(f.read) }
  memo_id = params[:memo_id].to_i
  memo_title = params[:memo_title]
  memo_content = params[:memo_content]
  memos[memo_id] = { 'memo_id' => memo_id, 'memo_title' => memo_title, 'memo_content' => memo_content }

  File.open(DATA_JSON, 'w') do |file|
    JSON.dump(memos, file)
  end
  redirect to('/')
end
