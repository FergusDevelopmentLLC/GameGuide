require 'rack-flash'
class CommentsController < ApplicationController
    use Rack::Flash

    get "/comments/:id/edit" do
        @comment = Comment.find(params[:id])
        erb :'comments/edit'
    end

    post "/comments" do
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
    end
    
    patch "/comments/:id" do
        @comment = Comment.find(params[:id])
        @comment.update(params[:comment])
        flash[:message] = "Comment updated."
        redirect "/games/#{@comment.game.id}"
    end

    delete "/comments/:id" do
        @comment = Comment.find(params[:id])
        @comment.destroy
        flash[:message] = "Comment deleted."
        redirect "/games/#{@comment.game.id}"
    end
end

