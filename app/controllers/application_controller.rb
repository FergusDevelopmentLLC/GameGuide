class ApplicationController < Sinatra::Base

  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
    enable :sessions
    set :session_secret, 'secure_password'
  end

  get '/' do
    @latest_game = Game.order(:created_at).last
    @featured = Game.get_featured_except(@latest_game)
    erb :index
  end

  helpers do
  
    def logged_in?
      !!current_user
    end

    def current_user
      User.find_by(:id => session[:user_id])
    end

    def can_edit_user?(user)
      current_user == user
    end

    def can_edit_game?(game)
      current_user == game.user
    end

    def can_edit_comment?(comment)
      current_user == comment.user
    end

  end

end
