require 'rack-flash'
class UsersController < ApplicationController
    use Rack::Flash

    get '/signup' do
        session.clear
        erb :'users/new'
    end

    post '/signup' do
        @user = User.new(params[:user])
        if(@user.save)
            session[:user_id] = @user.id
            redirect "/"
        end
    end

    get '/login' do
        erb :'users/login'
    end

    post '/login' do
        @user = User.find_by(:username => params[:user][:username])
        if(@user && @user.authenticate(params[:user][:password]))
            session[:user_id] = @user.id
        end
        redirect "/"
    end

    get '/logout' do
        session.clear
        redirect "/"
    end

    get '/users/:id' do
        if !logged_in?
            flash[:message] = "You must be logged in to see user profiles"
            redirect "/"
        else
            @user = User.find(params[:id])
            erb :'users/show'
        end
    end

    helpers do
        def can_edit_user?(user)
            if (current_user.id == user.id)
                true
            else
                false
            end
        end
    end
end

