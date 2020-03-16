require 'rack-flash'
class TagsController < ApplicationController
    use Rack::Flash

    get '/tags' do
        @tags = Tag.all.sort_by { |tag| tag.games.count }.reverse
        erb :'tags/index'
    end

    post '/tags' do
        @game = Game.find(params[:game_id])
        
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

        redirect "/games/#{@game.id}"
    end

    get '/tags/:id' do
        @tag = Tag.find(params[:id])
        erb :'tags/show'
    end

end