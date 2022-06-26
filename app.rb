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

def write_json(memos)
  File.open(DATA_JSON, 'w') do |file|
    JSON.dump(memos, file)
  end
end

def make_memos_from_memo_id(memos, memo_id)
  memo_title = h(params[:memo_title])
  memo_content = h(params[:memo_content])
  memos[memo_id] = { 'memo_title' => memo_title, 'memo_content' => memo_content }
  memos
end

get '/memos' do
  @memos = open_json
  erb :index
end

post '/memos' do
  memos = open_json
  if memos == {}
    memo_id = 0
  else
    memo_id = memos.keys.map{|memo_id| memo_id.to_i}.max + 1
  end
  make_memos_from_memo_id(memos, memo_id)
  write_json(memos)
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
  write_json(memos)
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
  make_memos_from_memo_id(memos, memo_id)
  write_json(memos)
  redirect to('/memos')
end
