require 'sinatra'
require 'sinatra/reloader'
require "json"

get "/" do
  File.open("data.json") do |f|
    @comments = JSON.load(f)["comment_data"]
  end
  @comments_number = @comments.size - 1
  erb :index
end

get "/new" do
  @title = "sinatra_memo_app"
  @content = "メモアプリ"
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
