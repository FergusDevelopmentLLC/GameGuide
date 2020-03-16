require 'rack-flash'
class GamesController < ApplicationController
    use Rack::Flash
    
    get "/games" do
        @games = Game.all
        erb :'games/index'
    end

    get '/games/new' do
        if !logged_in?
            flash[:message] = "Please log in to create a game."
            redirect "/games"
        else
            erb :'games/new'
        end
    end

    get '/games/:id' do
        @game = Game.find(params[:id])
        erb :'/games/show'
    end

    get '/games/:id/edit' do
        @game = Game.find(params[:id])

        if logged_in? && can_edit_game?(@game)
            erb :'/games/edit'
        else
            flash[:message] = "You must be logged in and owner of a game to edit it."
            redirect "/games/#{@game.id}"
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
            flash[:message] = "You must be logged in to create a game."
            redirect "/games"
        end
    end


    patch "/games/:id" do
        
        @game = Game.find(params[:id])

        if logged_in? && can_edit_game?(@game)

            if @game.update(params[:game]) 
                
                @game.tags.clear

                if params[:tag_ids]
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
                        #cant user @game << tag here because need user_id on the GameTagUser record
                        GameTagUser.create(:game => @game, :tag => tag, :user => current_user)
                    end
                end

                if @game.save
                    flash[:message] = "Game updated successfully."
                end

            end
        else
            flash[:message] = "You must be logged in and owner of a game to edit it."
        end

        redirect "/games/#{@game.id}"
    end

    delete '/games/:id' do
        @game = Game.find(params[:id])

        if logged_in? && can_edit_game?(@game)
            @game.destroy
            #delete any orphaned tags as a result
            Tag.all.find_all {|tag| tag.games.empty?}.each {|tag| tag.destroy}
            flash[:message] = "Game deleted."
            redirect "/games"
        else
            flash[:message] = "You must be logged in and owner of a game to edit it."
            redirect "/games/#{@game.id}"
        end
        
    end

end

