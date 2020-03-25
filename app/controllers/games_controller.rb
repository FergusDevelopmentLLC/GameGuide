include FileUtils::Verbose
class GamesController < ApplicationController
    
    get "/games" do
        @games = Game.all.order(:name)
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
        @game = Game.find_by(:id => params[:id])
        erb :'/games/show'
    end

    get '/games/:id/edit' do
        @game = Game.find_by(:id => params[:id])

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
            
            @game.featured = 0
            
            if params[:featured]
                @game.featured = 1
            end

            if params[:image]
                tempfile = params[:image][:tempfile] 
                filename = params[:image][:filename]

                timestamp = Time.now.to_i
                image_file = filename.gsub(".", "#{timestamp.to_s}.")
                cp(tempfile.path, "public/uploads/#{image_file}")

                @game.image = image_file
            end

            if @game.valid?
            
                @game.save
                
                if params[:tag_ids]
                    params[:tag_ids].each {|tag_id|
                        tag = Tag.find(tag_id)
                        #cant do @game.tags << tag here because need user_id on the GameTagUser record
                        #so that if user is deleted, this tag association is also deleted
                        GameTagUser.create(:game => @game, :tag => tag, :user => current_user)
                    }
                end
                
                if !params[:new_tag].empty?
                    tag = Tag.find_or_create_by(:name => params[:new_tag].downcase)
                    if !@game.tags.include?(tag)
                        #cant do @game.tags << tag here because need user_id on the GameTagUser record
                        #so that if user is deleted, this tag association is also deleted
                        GameTagUser.create(:game => @game, :tag => tag, :user => current_user)
                    end
                end

                if @game.featured == 1
                    Game.delete_old_featured
                end
                
                flash[:message] = "Game saved."
                redirect "/games/#{@game.id}"
            else
                erb :'games/new'
            end
        else
            flash[:message] = "You must be logged in to create a game."
            redirect "/games"
        end
    end


    patch "/games/:id" do
        
        @game = Game.find_by(:id => params[:id])

        if logged_in? && can_edit_game?(@game)

            @game.update(params[:game])
            
            @game.featured = 0
            
            if params[:featured]
                @game.featured = 1
            end
            
            if params[:image] && !params[:clear_image] 
                tempfile = params[:image][:tempfile] 
                filename = params[:image][:filename]

                timestamp = Time.now.to_i
                image_file = filename.gsub(".", "#{timestamp.to_s}.")
                cp(tempfile.path, "public/uploads/#{image_file}")

                @game.image = image_file
            end

            if params[:clear_image]
                @game.image = nil
            end

            if @game.valid?
                    
                @game.tags.clear

                if params[:tag_ids]
                    params[:tag_ids].each {|tag_id|
                        tag = Tag.find(tag_id)
                        if !@game.tags.include?(tag)
                            #cant do @game.tags << tag here because need user_id on the GameTagUser record
                            #so that if user is deleted, this tag association is also deleted
                            GameTagUser.create(:game => @game, :tag => tag, :user => current_user)   
                        end
                    }
                end

                if !params[:new_tag].empty?
                    tag = Tag.find_or_create_by(:name => params[:new_tag].downcase)
                    
                    if !@game.tags.include?(tag)
                        #cant do @game.tags << tag here because need user_id on the GameTagUser record
                        #so that if user is deleted, this tag association is also deleted
                        GameTagUser.create(:game => @game, :tag => tag, :user => current_user)
                    end
                end

                @game.save
                
                if @game.featured == 1
                    Game.delete_old_featured
                end

                #delete any orphaned tags as result of game update
                Tag.all.find_all {|tag| tag.games.empty?}.each {|tag| tag.destroy}

                flash[:message] = "Game updated successfully."
                redirect "/games/#{@game.id}"

            else
                
                #the game is invalid here, this is only for repopulating form
                #with what the user previously selected
                
                @game.tags.clear

                if params[:tag_ids]
                    params[:tag_ids].each {|tag_id|
                        tag = Tag.find(tag_id)
                        if !@game.tags.include?(tag)
                            @game.tags << tag   
                        end
                    }
                end

                if params[:new_tag]
                    @new_tag = params[:new_tag]
                end

                erb :'/games/edit'
            end
        else
            flash[:message] = "You must be logged in and owner of a game to edit it."
            redirect "/games/#{@game.id}"
        end

    end

    delete '/games/:id' do
        @game = Game.find_by(:id => params[:id])

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

