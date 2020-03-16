require 'rack-flash'
class CommentsController < ApplicationController
    use Rack::Flash

    get "/comments/:id/edit" do
        if logged_in?
            @comment = Comment.find(params[:id])
            erb :'comments/edit'
        else
            flash[:message] = "Please log in to comment on a game."
            redirect "/games"
        end
    end

    post "/comments" do
        if logged_in?

            @game = Game.find(params[:game_id])

            if !params[:show_new_comment].empty?
                new_comment = Comment.new(:content => params[:show_new_comment])
                new_comment.user = current_user
                @game.comments << new_comment
                flash[:message] = "Thank you for adding a comment."
            else
                flash[:add_comment_message] = "Please enter a comment."
            end
            
            redirect "/games/#{@game.id}"
        else
            flash[:message] = "Please log in to comment on a game."
            redirect "/games"
        end
    end
    
    patch "/comments/:id" do
        if logged_in?
            @comment = Comment.find(params[:id])
            @comment.update(params[:comment])
            flash[:message] = "Comment updated."
            redirect "/games/#{@comment.game.id}"
        else
            flash[:message] = "Please log in to update a game comment."
            redirect "/games"
        end
    end

    delete "/comments/:id" do
        if logged_in?
            @comment = Comment.find(params[:id])
            @comment.destroy
            flash[:message] = "Comment deleted."
            redirect "/games/#{@comment.game.id}"
        else
            flash[:message] = "Please log in to update a game comment."
            redirect "/games"
        end
    end
end

