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
        
        if params[:show_new_comment] #user is adding a comment to a game, from game show page
            if !params[:show_new_comment].empty?
                new_comment = Comment.new(:content => params[:show_new_comment])
                new_comment.user = current_user
                @game.comments << new_comment
                flash[:message] = "Thank you for adding a comment."
            else
                flash[:add_comment_message] = "Please enter a comment."
            end
        elsif params[:show_new_tag] #user is adding a tag to a game, from game show page
            if !params[:new_tag].empty?
                tag = Tag.find_or_initialize_by(:name => params[:new_tag].downcase)
                if(!tag.user) then tag.user = current_user end #if this is not an existing tag, assign current_user
                if(!@game.tags.include?(tag)) then @game.tags << tag end
                flash[:message] = "Thank you for adding a tag."
            else
                flash[:add_tag_message] = "Please enter a tag."
            end
        else #will get here from game edit, user is updatomg a game
            if !params[:game][:tag_ids]
                @game.tags.clear
            end
            if @game.update(params[:game]) 
                if !params[:new_tag].empty?
                    tag = Tag.find_or_initialize_by(:name => params[:new_tag].downcase)
                    if(!tag.user) then tag.user = current_user end #if this is not an existing tag, assign current_user
                    if(!@game.tags.include?(tag)) then @game.tags << tag end
                end
                flash[:message] = "Game updated successfully."
            end
        end
        redirect "/games/#{@game.id}"
    end

    get "/games" do
        @games = Game.all
        erb :'games/index'
    end

    get '/games/:id/edit' do
        @game = Game.find(params[:id])
        erb :'/games/edit'
    end

    helpers do
        def can_edit_comment?(comment)
            if current_user.id == comment.user.id
                true
            else
                false
            end
        end
        def can_edit_game?(game)
            if current_user.id == game.user.id
                true
            else
                false
            end
        end
    end
end

