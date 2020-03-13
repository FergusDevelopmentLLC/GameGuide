class UsersController < ApplicationController
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
end

