require 'rack-flash'
class CommentsController < ApplicationController
    use Rack::Flash

    get "/comments/:id/edit" do
        @comment = Comment.find(params[:id])
        erb :'comments/edit'
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

