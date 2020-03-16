require 'rack-flash'
class GamesController < ApplicationController
    use Rack::Flash
    
    get '/games/new' do
        if !logged_in?
            flash[:message] = "Please log in to create or edit a game."
            redirect "/games"
        else
            erb :'games/new'
        end
    end

    post '/games' do
        
        if logged_in?
            @game = Game.new(params[:game])
            @game.user = current_user

            if params[:tag_ids]
                params[:tag_ids].each {|tag_id|
                    tag = Tag.find(tag_id)
                    #cant user @game << tag here because need user_id on the GameTagUser record
                    GameTagUser.create(:game => @game, :tag => tag, :user => current_user)
                }
            end
            
            if !params[:new_tag].empty?
                tag = Tag.find_or_create_by(:name => params[:new_tag].downcase)
                if !@game.tags.include?(tag)
                    #cant user @game << tag here because need user_id on the GameTagUser record
                    GameTagUser.create(:game => @game, :tag => tag, :user => current_user)
                end
            end
            
            if @game.save
                flash[:message] = "Game saved."
                redirect "/games/#{@game.id}"
            end
               
        else
            flash[:message] = "Please log in to create or edit a game."
            redirect "/games"
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
                tag = Tag.find_or_create_by(:name => params[:new_tag].downcase)
                if !@game.tags.include?(tag)
                    #cant user @game << tag here because need user_id on the GameTagUser record
                    GameTagUser.create(:game => @game, :tag => tag, :user => current_user)
                    flash[:message] = "Thank you for adding a tag."
                else
                    flash[:message] = "Game already has this tag."
                end
            else
                flash[:add_tag_message] = "Please enter a tag."
            end
        else #will get here from game edit, user is updating a game
            
            if @game.update(params[:game]) 
                
                if !params[:tag_ids]
                    @game.tags.clear
                else
                    params[:tag_ids].each {|tag_id|
                        tag = Tag.find(tag_id)
                        if !@game.tags.include?(tag)
                            #cant user @game << tag here because need user_id on the GameTagUser record
                            GameTagUser.create(:game => @game, :tag => tag, :user => current_user)   
                        end
                    }
                end

                if !params[:new_tag].empty?
                    tag = Tag.find_or_create_by(:name => params[:new_tag].downcase)
                    
                    if !@game.tags.include?(tag)
                        gtu = GameTagUser.new
                        gtu.tag = tag
                        gtu.user = current_user
                        gtu.game = @game
                        gtu.save
                    end
                end

                if @game.save
                    flash[:message] = "Game updated successfully."
                end

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

        if logged_in? && can_edit_game?(@game)
            erb :'/games/edit'
        else
            flash[:message] = "Please log in to create or edit a game."
            redirect "/games/#{@game.id}"
        end
    end

    delete '/games/:id' do
        @game = Game.find(params[:id])
        @game.destroy
        #delete any orphaned tags as a result
        Tag.all.find_all {|tag| tag.games.empty?}.each {|tag| tag.destroy}
        flash[:message] = "Game deleted."
        redirect "/games"
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

