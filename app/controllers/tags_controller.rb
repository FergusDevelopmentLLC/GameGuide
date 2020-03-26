class TagsController < ApplicationController
    
    get '/tags' do
        @tags = Tag.all.sort_by { |tag| tag.games.count }.reverse
        erb :'tags/index'
    end

    get '/tags/:id' do
        @tag = Tag.find_by(:id => params[:id])
        @games = @tag.games
        erb :'tags/show'
    end

    post '/tags' do
        @game = Game.find_by(:id => params[:game_id])
        if logged_in?
            tag = Tag.find_or_create_by(:name => params[:new_tag].downcase)
            if tag.valid?
                if !@game.tags.include?(tag)
                    #cant do @game.tags << tag here because need user_id on the GameTagUser record
                    #so that if user is deleted, this tag association is also deleted
                    GameTagUser.create(:game => @game, :tag => tag, :user => current_user)
                    @game.updated_at = Time.now.to_i #trigger the updated_at so game appears on home
                    @game.save
                    flash[:message] = "Thank you for adding a tag"
                else
                    flash[:add_tag_error] = "Game already has this tag"
                end
            else
                flash[:add_tag_error] = "Please enter a tag"
            end
        else
            flash[:message] = "You must be logged in to add a tag"
        end

        redirect "/games/#{@game.id}"
    end

end