require 'rack-flash'
class CommentsController < ApplicationController
    use Rack::Flash

    get "/comments/:id/edit" do
        @comment = Comment.find_by(:id => params[:id])

        if logged_in? && can_edit_comment?(@comment)
            erb :'comments/edit'
        else
            flash[:message] = "You must be logged in and owner of a comment to edit it."
            redirect "/games"
        end
    end

    post "/comments" do
        if logged_in?

            @game = Game.find_by(:id => params[:game_id])

            new_comment = Comment.new(:content => params[:show_new_comment])
            if new_comment.valid?
                new_comment.user = current_user
                @game.comments << new_comment
                @game.updated_at = Time.now.to_i 
                @game.save
                flash[:message] = "Thank you for adding a comment."
            else
                flash[:add_comment_error] = "Please enter a comment."
            end
            
            redirect "/games/#{@game.id}"
        else
            flash[:message] = "Please log in to comment on a game."
            redirect "/games"
        end
    end
    
    patch "/comments/:id" do
        
        @comment = Comment.find_by(:id => params[:id])

        if logged_in? && can_edit_comment?(@comment)
            @comment.update(params[:comment])
            if @comment.valid?
                flash[:message] = "Comment updated."
                redirect "/games/#{@comment.game.id}"
            else
                erb :'/comments/edit'
            end
        else
            flash[:message] = "You must be logged in and owner of a comment to edit it."
            redirect "/games"
        end
    end

    delete "/comments/:id" do
        
        @comment = Comment.find_by(:id => params[:id])

        if logged_in? && can_edit_comment?(@comment)
            @comment.destroy
            flash[:message] = "Comment deleted."
            redirect "/games/#{@comment.game.id}"
        else
            flash[:message] = "You must be logged in and owner of a comment to edit it."
            redirect "/games"
        end
    end
end

