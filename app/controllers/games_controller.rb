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

    get '/games/:id' do
        @game = Game.find(params[:id])
        erb :'/games/show'
    end

    patch "/games/:id" do
        @game = Game.find(params[:id])
        if params[:show_new_tag]
            if !params[:show_new_tag].empty?
                new_tag = Tag.new(:name => params[:show_new_tag])
                new_tag.user = current_user
                @game.tags << new_tag
            else
                flash[:add_tag_message] = "Please enter a tag."
            end
            redirect "/games/#{@game.id}"
        end
        if params[:show_new_comment]
            if !params[:show_new_comment].empty?
                new_comment = Comment.new(:content => params[:show_new_comment])
                new_comment.user = current_user
                @game.comments << new_comment
            else
                flash[:add_comment_message] = "Please enter a comment."
            end
            redirect "/games/#{@game.id}"
        end
    end
    

    get "/games" do
        @games = Game.all
        erb :'games/index'
    end

    helpers do
        def can_edit_comment?(comment)
            if (current_user.id == comment.user.id)
                true
            else
                false
            end
        end
    end
end

