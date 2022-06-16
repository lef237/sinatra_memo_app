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
  redirect to('/')
end

get "/new" do
  erb :new
end

get "/show/:id" do
  @id = params[:id].to_i
  File.open("data.json") do |f|
    @memos = JSON.load(f)
  end
  @memo = @memos[params[:id].to_i]
  erb :show
end

delete "/show/:id" do
  memos = File.open("data.json") { |f| JSON.load(f) }
  memos.delete_at(params["id"].to_i)
  open("data.json", "w") do |file|
    JSON.dump(memos, file)
  end
  redirect to('/')
end

# delete '/show/:id' do
#   memos = File.open("data.json") { |f| JSON.load(f) }
#   memos.delete(:id)
#   open("data.json", "w") do |file|
#     JSON.dump(memos, file)
#   end
#   redirect to('/')
# end

get "/edit/:id" do
  File.open("data.json") do |f|
    @memos = JSON.load(f)
  end
  @memo = @memos[params['id'].to_i]
  erb :edit
end

patch "/" do
  memos = File.open("data.json") { |f| JSON.load(f) }
  memo_id = params[:memo_id].to_i
  memo_title = params[:memo_title]
  memo_content = params[:memo_content]
  memos[memo_id] = {"memo_id" =>memo_id, "memo_title" =>memo_title, "memo_content" =>memo_content}

  open("data.json", "w") do |file|
    JSON.dump(memos, file)
  end
  redirect to('/')
end


# post "/edit/:id" do
#   File.open("data.json") do |f|
#     @memos = JSON.load(f)
#   end
#   @memo = @memos[params[:id].to_i]
#   erb :edit
# end
