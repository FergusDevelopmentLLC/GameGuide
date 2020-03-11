class ApplicationController < Sinatra::Base

  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
    enable :sessions
    set :session_secret, 'secure_password'
  end

  get '/' do
    erb :index
  end

  get '/error' do
    erb :error
  end

end
