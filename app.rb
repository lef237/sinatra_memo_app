# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require 'json'
require "erb"
include ERB::Util

DATA_JSON = 'data.json'

def open_json
  File.open(DATA_JSON) { |f| JSON.parse(f.read) }
end

get '/memos' do
  @memos = open_json
  erb :index
end

post '/memos' do
  memos = open_json
  memo_id = memos.keys.map{|memo_id| memo_id.to_i}.max + 1
  memo_title = h(params[:memo_title])
  memo_content = h(params[:memo_content])
  memos[memo_id] = { 'memo_title' => memo_title, 'memo_content' => memo_content }
  File.open(DATA_JSON, 'w') do |file|
    JSON.dump(memos, file)
  end
  redirect to('/memos')
end

get '/memos/new' do
  erb :new
end

get '/memos/:memo_id' do
  @memos = open_json
  @memo_id = params[:memo_id]
  @memo = @memos[h(params['memo_id'])]
  erb :show
end

delete '/memos/:memo_id' do
  memos = open_json
  memos.delete(h(params['memo_id']))
  File.open(DATA_JSON, 'w') do |file|
    JSON.dump(memos, file)
  end
  redirect to('/memos')
end

get '/memos/:memo_id/edit' do
  @memo_id = h(params[:memo_id])
  @memos = open_json
  @memo = @memos[h(params['memo_id'])]
  erb :edit
end

patch '/memos/:memo_id' do
  memos = open_json
  memo_id = h(params[:memo_id])
  memo_title = h(params[:memo_title])
  memo_content = h(params[:memo_content])
  memos[memo_id] = { 'memo_title' => memo_title, 'memo_content' => memo_content }

  File.open(DATA_JSON, 'w') do |file|
    JSON.dump(memos, file)
  end
  redirect to('/memos')
end
