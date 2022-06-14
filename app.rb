require 'sinatra'
require 'sinatra/reloader'

get "/" do
  @title = "sinatra_memo_app"
  @content = "メモアプリ"
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
