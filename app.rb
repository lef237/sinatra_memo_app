# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require 'json'
require "erb"
include ERB::Util

DATA_JSON = 'data.json'

get '/memos' do
  @memos = File.open(DATA_JSON) { |f| JSON.parse(f.read) }
  erb :index
end

post '/memos' do
  memos = File.open(DATA_JSON) { |f| JSON.parse(f.read) }
  memo_title = h(params[:memo_title])
  memo_content = h(params[:memo_content])
  hash = { 'memo_title' => memo_title, 'memo_content' => memo_content }
  memos << hash
  File.open(DATA_JSON, 'w') do |file|
    JSON.dump(memos, file)
  end
  redirect to('/memos')
end

get '/memos/new' do
  erb :new
end

get '/memos/:memo_id' do
  @memo_id = h(params[:memo_id]).to_i
  File.open(DATA_JSON) do |f|
    @memos = JSON.parse(f.read)
  end
  @memo = @memos[h(params[:memo_id]).to_i]
  erb :show
end

delete '/memos/:memo_id' do
  memos = File.open(DATA_JSON) { |f| JSON.parse(f.read) }
  memos.delete_at(h(params['memo_id']).to_i)
  File.open(DATA_JSON, 'w') do |file|
    JSON.dump(memos, file)
  end
  redirect to('memos/')
end

get '/memos/:memo_id/edit' do
  @memo_id = h(params[:memo_id])
  File.open(DATA_JSON) do |f|
    @memos = JSON.parse(f.read)
  end
  @memo = @memos[h(params['memo_id']).to_i]
  erb :edit
end

patch '/memos/:memo_id' do
  memos = File.open(DATA_JSON) { |f| JSON.parse(f.read) }
  memo_id = h(params[:memo_id]).to_i
  memo_title = h(params[:memo_title])
  memo_content = h(params[:memo_content])
  memos[memo_id] = { 'memo_id' => memo_id, 'memo_title' => memo_title, 'memo_content' => memo_content }

  File.open(DATA_JSON, 'w') do |file|
    JSON.dump(memos, file)
  end
  redirect to('/memos')
end
