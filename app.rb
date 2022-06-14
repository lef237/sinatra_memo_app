require 'sinatra'
require 'sinatra/reloader'

get "/" do
  erb :index
end

get '/hello' do
  content_type :json
  data= {
      message: "Hello"
  }
  data.to_json
end

get '/erb_template_page' do
  erb :erb_template_page
end
