require 'rack-flash'
class GamesController < ApplicationController
    use Rack::Flash

    get '/games/new' do
        if !logged_in?
            flash[:message] = "You must be logged in to create a game."
            redirect "/"
        else
            erb :'games/new'
        end
    end

    post '/games' do
        @game = Game.new(params[:game])
        @game.user = current_user

        if !params[:new_tag].empty?
            @game.tags << Tag.create(:name => params[:new_tag])
        end
        
        if @game.save
            flash[:message] = "Game saved."
            redirect "/games/#{@game.id}"
        end
    end

    
end

