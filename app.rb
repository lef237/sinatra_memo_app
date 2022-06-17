# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require 'json'

get '/' do
  File.open('data.json') do |f|
    @memos = JSON.parse(f.read)
  end
  erb :index
end

post '/' do
  memos = File.open('data.json') { |f| JSON.parse(f.read) }
  memo_title = params[:memo_title]
  memo_content = params[:memo_content]
  hash = { 'memo_title' => memo_title, 'memo_content' => memo_content }
  memos << hash
  open('data.json', 'w') do |file|
    JSON.dump(memos, file)
  end
  redirect to('/')
end

get '/new' do
  erb :new
end

get '/show/:id' do
  @id = params[:id].to_i
  File.open('data.json') do |f|
    @memos = JSON.parse(f.read)
  end
  @memo = @memos[params[:id].to_i]
  erb :show
end

delete '/show/:id' do
  memos = File.open('data.json') { |f| JSON.parse(f.read) }
  memos.delete_at(params['id'].to_i)
  open('data.json', 'w') do |file|
    JSON.dump(memos, file)
  end
  redirect to('/')
end

get '/edit/:id' do
  @id = params[:id]
  File.open('data.json') do |f|
    @memos = JSON.parse(f.read)
  end
  @memo = @memos[params['id'].to_i]
  erb :edit
end

patch '/' do
  memos = File.open('data.json') { |f| JSON.parse(f.read) }
  memo_id = params[:memo_id].to_i
  memo_title = params[:memo_title]
  memo_content = params[:memo_content]
  memos[memo_id] = { 'memo_id' => memo_id, 'memo_title' => memo_title, 'memo_content' => memo_content }

  open('data.json', 'w') do |file|
    JSON.dump(memos, file)
  end
  redirect to('/')
end
