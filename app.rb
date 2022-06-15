require 'sinatra'
require 'sinatra/reloader'
require "json"

get "/" do
  File.open("data.json") do |f|
    @memos = JSON.load(f)
  end
  @memo_number = @memos.size - 1
  erb :index
end

post "/" do
  # paramsをjsonに追加する処理を書く
  memos = File.open("data.json") { |f| JSON.load(f) }
  memo_id = memos.size + 1
  memo_title = params[:memo_title]
  memo_content = params[:memo_content]
  hash = {"memo_id" =>memo_id, "memo_title" =>memo_title, "memo_content" =>memo_content}
  memos << hash
  open("data.json", "w") do |file|
    JSON.dump(memos, file)
  end
end

get "/new" do
  erb :new
end

get "/show" do
  @title = "sinatra_memo_app"
  @content = "メモアプリ"
  erb :show
end

get "/edit" do
  @title = "sinatra_memo_app"
  @content = "メモアプリ"
  erb :edit
end
