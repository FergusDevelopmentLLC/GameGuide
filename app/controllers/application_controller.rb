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

  helpers do
    def logged_in?
      !!session[:user_id]
    end

    def current_user
      User.find(session[:user_id])
    end

    def can_edit_game?(game)
      if current_user.id == game.user.id
        true
      else
        false
      end
    end

    def can_edit_comment?(comment)
      if current_user.id == comment.user.id
          true
      else
          false
      end
    end

  end

end
