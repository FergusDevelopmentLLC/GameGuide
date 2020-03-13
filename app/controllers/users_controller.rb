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
            flash[:message] = "You must be logged in to see user profiles."
            redirect "/"
        else
            @user = User.find(params[:id])
            erb :'users/show'
        end
    end

    get "/users/:id/edit" do
        @user = User.find(params[:id])
        if !logged_in?
            flash[:message] = "You must be logged in to edit your profile."
            redirect "/"
        else
            if !can_edit_user?(@user)
                flash[:message] = "You cannot edit a user profile other than your own."
                redirect "/"
            else
                erb :'users/edit'
            end
        end
    end

    patch "/users/:id" do
        @user = User.find(params[:id])
        if(can_edit_user?(@user))
            @user.update(params[:user])
            session.clear
            flash[:message] = "Profile updated. Please log in again."
            redirect "/login"
        else
            flash[:message] = "You cannot edit a user profile other than your own."
            redirect "/"
        end
    end

    delete "/users/:id" do
        @user = User.find(params[:id])
        if(can_edit_user?(@user))
            @user.destroy
            session.clear
            flash[:message] = "Account deleted. Please sign up a new account or login."
            redirect "/"
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

